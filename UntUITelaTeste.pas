unit UntUITelaTeste;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, ClsLogicaTeste, Vcl.StdCtrls;

type
  TUITelaTeste = class(TForm)
    DBGrid1: TDBGrid;
    BtnIncluir: TButton;
    BtnAlterar: TButton;
    BtnExcluir: TButton;
    procedure FormShow(Sender: TObject);
    procedure BtnIncluirClick(Sender: TObject);
    procedure BtnAlterarClick(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
  private
    FDados: TDataSource;
    FLogica: TLogicaTeste;
    function getCodigoSelecionado: integer;
  public
    constructor Create(const Dados: TDataSource; const Logica: TLogicaTeste); reintroduce;
  end;

var
  UITelaTeste: TUITelaTeste;

implementation

{$R *.dfm}

{ TUITelaTeste }

procedure TUITelaTeste.BtnAlterarClick(Sender: TObject);
var
  Codigo: integer;
begin
  Codigo := self.getCodigoSelecionado;
  if Codigo > 0 then self.FLogica.Alterar(Codigo);
end;

procedure TUITelaTeste.BtnExcluirClick(Sender: TObject);
var
  Codigo: integer;
begin
  Codigo := self.getCodigoSelecionado;
  if Codigo > 0 then self.FLogica.Excluir(Codigo);
end;

procedure TUITelaTeste.BtnIncluirClick(Sender: TObject);
begin
  self.FLogica.Incluir;
end;

constructor TUITelaTeste.Create(const Dados: TDataSource; const Logica: TLogicaTeste);
begin
  inherited Create(Application);
  FDados := Dados;
  FLogica := Logica;
end;

procedure TUITelaTeste.FormShow(Sender: TObject);
begin
  DBGrid1.DataSource := FDados;
end;

function TUITelaTeste.getCodigoSelecionado: integer;
begin
  Result := DBGrid1.DataSource.DataSet.FieldByName('ID').Value;
end;

end.
