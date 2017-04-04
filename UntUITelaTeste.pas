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
  private
    FDados: TDataSource;
    FLogica: TLogicaTeste;
  public
    constructor Create(const Dados: TDataSource; const Logica: TLogicaTeste); reintroduce;
  end;

var
  UITelaTeste: TUITelaTeste;

implementation

{$R *.dfm}

{ TUITelaTeste }

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

end.
