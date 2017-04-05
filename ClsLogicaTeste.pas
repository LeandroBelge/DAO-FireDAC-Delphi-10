unit ClsLogicaTeste;

interface
uses
  ClsLogicaDAO;
type
  TLogicaTeste = class
  private
    FDAO: TLogicaDAO;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ExibirTela;
    procedure Incluir;
    procedure Alterar(const Codigo: integer);
    procedure Excluir(const Codigo: integer);

  end;
implementation

{ TLogicaTeste }

uses UntUITelaTeste;

procedure TLogicaTeste.Alterar(const Codigo: integer);
begin
  FDAO.Persistir(Codigo, 'TESTE ALTERAÇÃO');
end;

constructor TLogicaTeste.Create;
begin
  FDAO := TLogicaDAO.Create;
end;

destructor TLogicaTeste.Destroy;
begin
  FDAO.Free;
  inherited;
end;

procedure TLogicaTeste.Excluir(const Codigo: integer);
begin
  FDAO.Excluir(Codigo);
end;

procedure TLogicaTeste.ExibirTela;
var
  Tela: TUITelaTeste;
begin
  Tela := TUITelaTeste.Create(self.FDAO.getOrigemDados, self);
  try
    Tela.ShowModal();
  finally
    Tela.Free;
  end;
end;

procedure TLogicaTeste.Incluir;
begin
  FDAO.Persistir(0, 'TESTE INCLUSÃO');
end;

end.
