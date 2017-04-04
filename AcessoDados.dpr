program AcessoDados;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  ClsDAOPrincipal in 'ClsDAOPrincipal.pas',
  FireDAC.Comp.Client, System.Variants,
  System.Classes;
var
  DAO: TDAOPrincipal;
  Descricoes: TStringList;
  i: integer;
  function Persistir: integer;
  var
    Proc: TFDStoredProc;
  begin
    DAO.AssociaTransacao;
    try
      Proc := DAO.getProcedimento('PERSISTIR');
      try
        Proc.ParamByName('ID').Value := null;
        proc.ParamByName('DESCRICAO').AsString := 'SEGUNDO TESTE';
        proc.ExecProc;
        result := proc.ParamByName('OUTID').AsInteger;
      finally
        Proc.Free;
      end;
      DAO.ConfirmaTransacao;
    except
      DAO.CancelaTransacao;
    end;
  end;
  function RecuperarDescricoes: TStringList;
  const
    SQL = 'select descricao from teste';
  var
    consulta: TFDQuery;
  begin
    Persistir;

    Result := TStringList.Create;
    consulta := DAO.getConsulta(SQL);
    try
      consulta.OpenOrExecute;
      while not consulta.Eof do begin
        Result.Add(consulta.FieldByName('DESCRICAO').AsString);
        consulta.Next;
      end;
    finally
      consulta.Free;
    end;
  end;
begin
  try
    DAO := TDAOPrincipal.Create('D:\Leandro\Projetos\DAO Delphi 10\DataBase\DATABASE.fdb');
    DAO.Conectar();
    try
      Descricoes := RecuperarDescricoes;
      for i := 0 to Descricoes.Count - 1 do begin
        Writeln(Descricoes[i]);
      end;
      Readln;
    finally
      DAO.Desconectar();
    end;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
