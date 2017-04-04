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
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.IB,
  FireDAC.Phys.FB,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI,
  FireDAC.DApt;
type
  TDAOPrincipal = class
  private
    FPathDataBase: string;
    FConexao: TFDConnection;
    FTransacao: TFDTransaction;
    FEventosBD: TFDEventAlerter;
    procedure DoAlert(ASender: TFDCustomEventAlerter; const AEventName: String; const AArgument: Variant);
    function getStringConection: string;
  public
    constructor Create(const PathDataBase: string);
    procedure Conectar;
    procedure Desconectar;
    procedure AssociaTransacao;
    procedure ConfirmaTransacao;
    procedure CancelaTransacao;
    function getConsulta(const QueryStr: string): TFDQuery;
    function getProcedimento(const NomeProc: string): TFDStoredProc;
  end;
implementation

uses
  System.SysUtils;

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
end;

procedure TDAOPrincipal.Desconectar;
begin
  self.FConexao.Connected := false;
  self.FConexao.Close;
end;

procedure TDAOPrincipal.DoAlert(ASender: TFDCustomEventAlerter; const AEventName: String; const AArgument: Variant);
begin
//  if CompareText(AEventName, 'Customers') = 0 then qryCustomers.Refresh;
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

end.
