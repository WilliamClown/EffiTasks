unit Service.Users;

interface

uses
  System.SysUtils,
  System.Hash,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param;

type
  TServiceUsers = class
  public
    class function Authenticate(const AUserName, APassword: string): Boolean;
  end;

implementation

uses
  DAO.Database;

{ TUsersService }


class function TServiceUsers.Authenticate(const AUserName, APassword: string): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    try
      Query.Connection := TDatabaseConnection.GetInstance.GetConnection;
      Query.SQL.Text := 'SELECT COUNT(*) AS CNT FROM USERS WHERE USER_NAME = :USER_NAME AND USER_PASS = :USER_PASS';
      Query.ParamByName('USER_NAME').AsString := AUserName;
      Query.ParamByName('USER_PASS').AsString := APassword;
      Query.Open;

      if Query.FieldByName('CNT').AsInteger > 0 then
        Result := True;
    except
      on E: Exception do
        raise Exception.Create('Erro ao acessar o banco de dados: ' + E.Message);
    end;
  finally
    Query.Free;
  end;
end;
end.
