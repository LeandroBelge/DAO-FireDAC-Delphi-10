unit ClsLogicaDAO;

interface
uses ClsDAOPrincipal, Data.DB;
type
  TLogicaDAO = class
  private
    FDAO: TDAOPrincipal;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Incluir;
    procedure Alterar;
    function getOrigemDados: TDataSource;
  end;
implementation

uses
  System.SysUtils, FireDAC.Comp.Client, System.Variants;



{ TLogicaDAO }

procedure TLogicaDAO.Alterar;
const
  COMANDO_SQL = 'update teste set descricao = %s where id = %d';
var
  comando: TFDQuery;
begin
  FDAO.AssociaTransacao;
  try
    comando := FDAO.getConsulta(Format(COMANDO_SQL, [QuotedStr('DESCRIÇÃO'), 3]));
    try
      comando.ExecSQL;
    finally
      comando.Free;
    end;
    FDAO.ConfirmaTransacao;
  finally
    FDAO.CancelaTransacao;
  end;
end;

constructor TLogicaDAO.Create;
begin
  FDAO := TDAOPrincipal.Create('D:\Leandro\Projetos\DAO Delphi 10\DataBase\DATABASE.fdb');
  FDAO.Conectar;
end;

destructor TLogicaDAO.Destroy;
begin
  FDAO.Destroy;
  FDAO := nil;
  inherited;
end;

function TLogicaDAO.getOrigemDados: TDataSource;
begin
  Result := FDAO.NovaOrigemDados('TESTE', 'Select * from teste', EmptyStr, 'ID DESC');
end;

procedure TLogicaDAO.Incluir;
var
  Proc: TFDStoredProc;
begin
  FDAO.AssociaTransacao;
  try
    Proc := FDAO.getProcedimento('PERSISTIR');
    try
      Proc.ParamByName('ID').Value := null;
      proc.ParamByName('DESCRICAO').AsString := 'QUARTO TESTE';
      proc.ExecProc;
    finally
      Proc.Free;
    end;
    FDAO.ConfirmaTransacao;
  except
    FDAO.CancelaTransacao;
  end;
end;

end.
