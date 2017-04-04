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

  end;
implementation

{ TLogicaTeste }

uses UntUITelaTeste;

constructor TLogicaTeste.Create;
begin
  FDAO := TLogicaDAO.Create;
end;

destructor TLogicaTeste.Destroy;
begin
  FDAO.Free;
  inherited;
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
  FDAO.Incluir;
end;

end.
