unit AcessoDados;

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
  TAcessoDados = class
  private
    FConexao: TFDConnection;
    FTransacao: TFDTransaction;
    procedure Conectar;
    function getStringConection: string;
  public
    constructor Create;
    procedure Desconectar;
    procedure AssociaTransacao;
    procedure ConfirmaTransacao;
    procedure CancelaTransacao;
    function getConsulta: TFDQuery;
    function getProcedimento(const NomeProc: string): TFDStoredProc;
    function getComando: TFDCommand;
  end;
implementation

uses
  System.SysUtils, Vcl.Forms;

{ TAcessoDados }

procedure TAcessoDados.AssociaTransacao;
begin
  if not Assigned(FTransacao) then begin
    self.FTransacao := TFDTransaction.Create(nil);
    self.FTransacao.Connection := FConexao;
    self.FTransacao.StartTransaction;
  end;
end;

procedure TAcessoDados.CancelaTransacao;
begin
  if Assigned(FTransacao) then begin
    self.FTransacao.Rollback;
    FreeAndNil(FTransacao);
  end;
end;

procedure TAcessoDados.Conectar;
begin
  if not Assigned(FConexao) then begin
    FConexao := TFDConnection.Create(nil);
    FConexao.Params.Clear;
    FConexao.LoginPrompt := false;
    FConexao.Open(self.getStringConection);
  end;
end;

procedure TAcessoDados.ConfirmaTransacao;
begin
  if Assigned(FTransacao) then begin
    self.FTransacao.Commit;
    FreeAndNil(FTransacao);
  end;
end;

function TAcessoDados.getComando: TFDCommand;
begin
  Result := TFDCommand.Create(nil);
  Result.Connection := FConexao;
  Result.Prepare();
end;

function TAcessoDados.getConsulta: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FConexao;
end;

function TAcessoDados.getProcedimento(const NomeProc: string): TFDStoredProc;
begin
  Result := TFDStoredProc.Create(nil);
  Result.Connection := FConexao;
  Result.StoredProcName := NomeProc;
  Result.Prepare;
end;

constructor TAcessoDados.Create;
begin
  self.Conectar;
end;

procedure TAcessoDados.Desconectar;
begin
  self.FConexao.Connected := false;
  self.FConexao.Close;
end;

function TAcessoDados.getStringConection: string;
begin
  result := ExtractFilePath(Application.ExeName)+'Dados\Dipetrol.fdb;'+
            ' User_Name=SYSDBA; '+
            ' Password=masterkey; '+
            ' CharacterSet=WIN1252; '+
            ' DriverID=IB; '+
            ' Protocol=TCPIP; '+
            ' Server=localhost;';
end;

end.
