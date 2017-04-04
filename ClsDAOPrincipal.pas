unit ClsDAOPrincipal;

interface
uses
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Comp.Client,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.IB,
  FireDAC.Phys.FB,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI,
  FireDAC.DApt,
  System.Generics.Collections,
  Data.DB,
  ClsOrigemDados;
type
  TDAOPrincipal = class
  private
    FPathDataBase: string;
    FConexao: TFDConnection;
    FTransacao: TFDTransaction;
    FEventosBD: TFDEventAlerter;
    FOrigensDados: TList<TOrigemDados>;
    procedure DoAlert(ASender: TFDCustomEventAlerter; const NomeEvento: String; const AArgument: Variant);
    function getStringConection: string;
  public
    constructor Create(const PathDataBase: string);
    destructor Destroy; override;
    procedure Conectar;
    procedure Desconectar;
    procedure AssociaTransacao;
    procedure ConfirmaTransacao;
    procedure CancelaTransacao;
    function NovaOrigemDados(const NomeOrigem, SQLOriginal, Filtros, Ordem: string): TDataSource;

    function getConsulta(const QueryStr: string): TFDQuery;
    function getProcedimento(const NomeProc: string): TFDStoredProc;
  end;
implementation

uses
  System.SysUtils, Vcl.Forms;

{ TDAOPrincipal }

procedure TDAOPrincipal.AssociaTransacao;
begin
  if not Assigned(FTransacao) then begin
    self.FTransacao := TFDTransaction.Create(nil);
    self.FTransacao.Connection := FConexao;
    self.FTransacao.StartTransaction;
  end;
end;

procedure TDAOPrincipal.CancelaTransacao;
begin
  if Assigned(FTransacao) then begin
    self.FTransacao.Rollback;
    FreeAndNil(FTransacao);
  end;
end;

procedure TDAOPrincipal.Conectar;
begin
  if not Assigned(FConexao) then begin
    FConexao := TFDConnection.Create(nil);
    FConexao.Params.Clear;
    FConexao.LoginPrompt := false;
    FConexao.Open(self.getStringConection);

    FEventosBD := TFDEventAlerter.Create(nil);
    FEventosBD.Connection := FConexao;
    FEventosBD.Options.Synchronize := True;
    FEventosBD.Options.Timeout := 10000;
    FEventosBD.OnAlert := DoAlert;
    FEventosBD.Active := True;

    FEventosBD.Names.Clear;
    FEventosBD.Names.Add('TESTE');

  end;
end;

procedure TDAOPrincipal.ConfirmaTransacao;
begin
  if Assigned(FTransacao) then begin
    self.FTransacao.Commit;
    FreeAndNil(FTransacao);
  end;
end;

constructor TDAOPrincipal.Create(const PathDataBase: string);
begin
  FPathDataBase := PathDataBase;
  FOrigensDados := TList<TOrigemDados>.Create;
end;

procedure TDAOPrincipal.Desconectar;
begin
  if self.FConexao.Connected then begin
    self.FConexao.Connected := false;
    self.FConexao.Close;
  end;
end;

destructor TDAOPrincipal.Destroy;
begin
  FOrigensDados.Free;
  self.Desconectar;
  inherited;
end;

procedure TDAOPrincipal.DoAlert(ASender: TFDCustomEventAlerter; const NomeEvento: String; const AArgument: Variant);
var
  Origem: TOrigemDados;
begin
  if not Assigned(FOrigensDados) then exit;
  for Origem in FOrigensDados do begin
    if CompareText(NomeEvento, Origem.Nome) = 0 then begin
      Origem.Refresh(NomeEvento);
    end;
  end;
end;

function TDAOPrincipal.getConsulta(const QueryStr: string): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FConexao;
  if QueryStr <> EmptyStr then Result.SQL.Add(QueryStr);
end;

function TDAOPrincipal.getProcedimento(const NomeProc: string): TFDStoredProc;
begin
  Result := TFDStoredProc.Create(nil);
  Result.Connection := FConexao;
  Result.StoredProcName := NomeProc;
  Result.Prepare;
end;

function TDAOPrincipal.getStringConection: string;
begin
  result := ' Database='+ FPathDataBase + ';' +
            ' User_Name=SYSDBA; '+
            ' Password=masterkey; '+
            ' CharacterSet=WIN1252; '+
            ' DriverID=IB; '+
            ' Protocol=TCPIP; '+
            ' Server=localhost;';
end;

function TDAOPrincipal.NovaOrigemDados(const NomeOrigem, SQLOriginal, Filtros, Ordem: string): TDataSource;
var
  OrigemDados: TOrigemDados;
begin
  try
    if not FConexao.Connected then exit;
    OrigemDados := TOrigemDados.Create(NomeOrigem);
    //Seta alguns parâmetros da Origem
    OrigemDados.SQLOriginal := SQLOriginal;
    OrigemDados.Filtros := Filtros;
    OrigemDados.Ordem := Ordem;
    OrigemDados.Consulta.Connection := FConexao;
    OrigemDados.Consulta.FetchOptions.CursorKind := ckDynamic;
    OrigemDados.Consulta.FetchOptions.Unidirectional := true;
    OrigemDados.Consulta.FetchOptions.Mode := fmOnDemand;
    OrigemDados.Consulta.FetchOptions.RowsetSize := 50;
    OrigemDados.Consulta.FetchOptions.Items := [fiDetails];
    OrigemDados.Consulta.FetchOptions.AutoClose := false;
    OrigemDados.AtualizaOrigem;
    FOrigensDados.Add(OrigemDados);
    Result := OrigemDados.FonteDados;
  except
    on E: Exception do begin
      if ((Copy(E.Message, 1, 26) = 'Unable to complete network')
        or (E.Message = 'Cannot perform operation -- DB is not open')
        or (E.Message = 'connection lost to database')
        or (E.Message = 'Error writing data to the connection')) then begin
//        Self.NotificaQuedaConexao;
        Application.Terminate;
      end;
    end;
  end;
end;

end.
