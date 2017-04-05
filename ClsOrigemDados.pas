unit ClsOrigemDados;

interface

uses
  FireDAC.Comp.DataSet,  Data.DB, FireDAC.Comp.Client;
type
  TOrigemDados = class
  private
  public
    Nome: string;
    SQLOriginal: String;
    Filtros: String;
    Ordem: String;
    Consulta: TFDQuery;
    FonteDados: TDataSource;

    Constructor Create(const NomeOrigem: String);
    destructor Destroy; override;

    procedure AtualizaOrigem;
    procedure Refresh (const EventName: String);

    function GetName(): string;
  end;
implementation

uses
  System.SysUtils;

{ TOrigemDados }

procedure TOrigemDados.AtualizaOrigem;
var
  Comando: string;
  PosicaoWhere: Integer;
  ComandoAntesWhere: string;
  ComandoDepoisWhere: string;
begin
  Comando := SQLOriginal;
  if Filtros <> '' then begin
    PosicaoWhere := Pos('WHERE', Trim(UpperCase(Comando)));
    if PosicaoWhere > 0 then begin
      ComandoAntesWhere := Copy(Comando, 1, PosicaoWhere -1);
      ComandoDepoisWhere := Copy(Comando, PosicaoWhere +5, Length(Comando) - Length(ComandoAntesWhere));
      Comando := ComandoAntesWhere + ' WHERE (' + Filtros + ') AND ' + ComandoDepoisWhere;
    end
    else begin
      Comando := Comando + ' WHERE (' + Filtros + ')';
    end;
  end;
  if Ordem <> '' then begin
    Comando := Comando + ' ORDER BY ' + Ordem;
  end;
  try
    self.Consulta.Active := False;
    self.Consulta.Open(Comando);
  except
    on E: Exception do begin
      raise Exception.Create('Erro inesperado ao realizar a operação.');
    end;
  end;

end;

constructor TOrigemDados.Create(const NomeOrigem: String);
begin
  inherited Create;
  Nome := NomeOrigem;
  SQLOriginal := EmptyStr;
  Filtros := EmptyStr;
  Ordem := EmptyStr;
  Consulta := TFDQuery.Create(Consulta);
  FonteDados := TDataSource.Create(FonteDados);
  FonteDados.DataSet := Consulta;
end;

destructor TOrigemDados.Destroy;
begin
  inherited Destroy;
  FreeAndNil(Consulta);
  FreeandNil(FonteDados);
end;

function TOrigemDados.GetName: string;
begin
  Result := self.Nome;
end;

procedure TOrigemDados.Refresh(const EventName: String);
begin
  if AnsiUpperCase(EventName) = AnsiUpperCase(self.Nome) then begin
    AtualizaOrigem;
  end;
end;

end.
