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
    procedure Persistir(const Codigo: integer; const Descricao: string);
    procedure Excluir(const Codigo: integer);
    function getOrigemDados: TDataSource;
  end;
implementation

uses
  System.SysUtils, FireDAC.Comp.Client, System.Variants;



{ TLogicaDAO }
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

procedure TLogicaDAO.Excluir(const Codigo: integer);
var
  proc: TFDStoredProc;
begin
  FDAO.AssociaTransacao;
  try
    proc := FDAO.getProcedimento('EXCLUIR');
    try
      proc.ParamByName('ID').Value := Codigo;
      proc.ExecProc;
    finally
      proc.Free;
    end;
    FDAO.ConfirmaTransacao;
  finally
    FDAO.CancelaTransacao;
  end;
end;

function TLogicaDAO.getOrigemDados: TDataSource;
begin
  Result := FDAO.NovaOrigemDados('TESTE', 'Select * from teste', EmptyStr, 'ID DESC');
end;

procedure TLogicaDAO.Persistir(const Codigo: integer; const Descricao: string);
var
  proc: TFDStoredProc;
begin
  FDAO.AssociaTransacao;
  try
    proc := FDAO.getProcedimento('PERSISTIR');
    try
      proc.ParamByName('ID').Value := Codigo;
      proc.ParamByName('DESCRICAO').AsString := Descricao;
      proc.ExecProc;
    finally
      proc.Free;
    end;
    FDAO.ConfirmaTransacao;
  finally
    FDAO.CancelaTransacao;
  end;
end;

end.
