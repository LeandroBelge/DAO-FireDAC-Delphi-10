unit UntUITelaTeste;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TUITelaTeste = class(TForm)
    DBGrid1: TDBGrid;
    procedure FormShow(Sender: TObject);
  private
    FDados: TDataSource;
  public
    constructor Create(const Dados: TDataSource); reintroduce;
  end;

var
  UITelaTeste: TUITelaTeste;

implementation

{$R *.dfm}

{ TUITelaTeste }

constructor TUITelaTeste.Create(const Dados: TDataSource);
begin
  inherited Create(Application);
  FDados := Dados;
end;

procedure TUITelaTeste.FormShow(Sender: TObject);
begin
  DBGrid1.DataSource := FDados;
end;

end.
