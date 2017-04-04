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
  Vcl.Forms;

var
  DAO: TDAOPrincipal;
  Descricoes: TStringList;
  i: integer;
  Tela: TUITelaTeste;
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
  procedure Alterar(const ID: integer; const Descricao: string);
  const
    COMANDO_SQL = 'update teste set descricao = %s where id = %d';
  var
    comando: TFDQuery;
  begin
    DAO.AssociaTransacao;
    try
      comando := DAO.getConsulta(Format(COMANDO_SQL, [QuotedStr(Descricao), ID]));
      try
        comando.ExecSQL;
      finally
        comando.Free;
      end;
      DAO.ConfirmaTransacao;
    finally
      DAO.CancelaTransacao;
    end;
  end;
begin
  try
    DAO := TDAOPrincipal.Create('D:\Leandro\Projetos\DAO Delphi 10\DataBase\DATABASE.fdb');
    DAO.Conectar();
    try
      Tela := TUITelaTeste.Create(DAO.NovaOrigemDados('TESTE', 'Select * from teste', EmptyStr, 'ID DESC'));
      Tela.Show();
    finally
      //DAO.Desconectar();
    end;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
