program AcessoDados;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  ClsDAOPrincipal in 'ClsDAOPrincipal.pas',
  FireDAC.Comp.Client,
  System.Variants,
  System.Classes,
  System.SysUtils,
  UntUITelaTeste in 'UntUITelaTeste.pas' {UITelaTeste},
  ClsOrigemDados in 'ClsOrigemDados.pas',
  Vcl.Forms,
  ClsLogicaTeste in 'ClsLogicaTeste.pas',
  ClsLogicaDAO in 'ClsLogicaDAO.pas';

var
  Logica: TLogicaTeste;

begin
  try
    Logica := TLogicaTeste.Create;
    try
      Logica.ExibirTela();
    finally
      Logica.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
