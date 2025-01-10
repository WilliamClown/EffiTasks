unit Controller.Users;

interface

uses
  Horse,
  System.JSON,
  Service.Users,
  System.SysUtils;

type
  TControllerUsers = class
  public
    class procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TUsersController }

class procedure TControllerUsers.Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LBody: TJSONObject;
  LUserName, LPassword: string;
  LResponse: TJSONObject;
begin
  LResponse := nil; // Inicializa a variável para evitar o erro "Variable required"
  try
    // Obtém o corpo da requisição como TJSONObject
    LBody := Req.Body<TJSONObject>;

    if not Assigned(LBody) then
    begin
      Res.Send('Corpo da requisição inválido.').Status(400);
      Exit;
    end;

    LUserName := LBody.GetValue<string>('USER_NAME', '');
    LPassword := LBody.GetValue<string>('USER_PASS', '');

    if (LUserName = '') or (LPassword = '') then
    begin
      Res.Send('Usuário ou senha não informados.').Status(400);
      Exit;
    end;

    if TServiceUsers.Authenticate(LUserName, LPassword) then
    begin
      LResponse := TJSONObject.Create;
      try
        LResponse.AddPair('status', 'success');
        LResponse.AddPair('message', 'Login realizado com sucesso.');
        Res.Send(LResponse.ToJSON).Status(200);
      finally
        FreeAndNil(LResponse);
      end;
    end
    else
    begin
      Res.Send('Usuário ou senha inválidos.').Status(401);
    end;
  except
    on E: Exception do
      Res.Send('Erro no servidor: ' + E.Message).Status(500);
  end;
end;

end.
