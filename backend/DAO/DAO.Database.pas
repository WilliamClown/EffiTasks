unit DAO.Database;

interface

uses
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Phys.MSSQL,
  System.SysUtils;

type
  TDatabaseConnection = class
  private
    class var FInstance: TDatabaseConnection;
    FConnection: TFDConnection;
    function CreateConnection: TFDConnection;
  public
    constructor Create;
    destructor Destroy; override;
    class function GetInstance: TDatabaseConnection;
    function GetConnection: TFDConnection;
  end;

implementation

uses
  Vcl.Forms;

{ TDatabaseConnection }

constructor TDatabaseConnection.Create;
begin
  FConnection := CreateConnection;
end;

function TDatabaseConnection.CreateConnection: TFDConnection;
begin
  Result := TFDConnection.Create(Application);
  Result.DriverName := 'MSSQL';
  Result.Params.DriverID := 'MSSQL';
  Result.Params.Database := 'master';
  Result.Params.UserName := 'sa';
  Result.Params.Password := 'SqlServer2022!';
  Result.Params.Add('Server=localhost');
  Result.Params.Add('Port=1433');

  Result.LoginPrompt := False;
  try
    Result.Connected := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao conectar ao banco de dados: ' + E.Message);
  end;
end;

destructor TDatabaseConnection.Destroy;
begin
  FConnection.Free;
  Inherited;
end;

class function TDatabaseConnection.GetInstance: TDatabaseConnection;
begin
  if not Assigned(FInstance) then
    FInstance := TDatabaseConnection.Create;
  Result := FInstance;
end;

function TDatabaseConnection.GetConnection: TFDConnection;
begin
  if not FConnection.Connected then
    FConnection.Connected := True;
  Result := FConnection;
end;

end.
