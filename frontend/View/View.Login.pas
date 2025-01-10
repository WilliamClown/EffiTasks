unit View.Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFormLogin = class(TForm)
    pnMain: TPanel;
    lblLoginTitulo: TLabel;
    Label1: TLabel;
    edtUserName: TEdit;
    Label2: TLabel;
    edtPassword: TEdit;
    pnBotaoLogin: TPanel;
    pnBotaoSair: TPanel;
    procedure pnBotaoLoginClick(Sender: TObject);
    procedure pnBotaoSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLogin: TFormLogin;

implementation

uses
  REST.Client, REST.Types, System.JSON, System.Hash;

{$R *.dfm}

procedure TFormLogin.FormCreate(Sender: TObject);
begin
  edtPassword.PasswordChar := '*';
end;

procedure TFormLogin.pnBotaoLoginClick(Sender: TObject);
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  LJSON: TJSONObject;
  LPasswordHash: string;
begin
  RESTClient := TRESTClient.Create('http://localhost:9000');
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);

  try
    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Resource := 'login';
    RESTRequest.Method := TRESTRequestMethod.rmPOST;

    if Trim(edtUserName.Text) = '' then
    begin
      ShowMessage('O nome de usuário não pode estar vazio.');
      Exit;
    end;

    if Trim(edtPassword.Text) = '' then
    begin
      ShowMessage('A senha não pode estar vazia.');
      Exit;
    end;

    // Criptografa a senha antes do envio
    LPasswordHash := THashMD5.GetHashString(edtPassword.Text);

    LJSON := TJSONObject.Create;
    try
      LJSON.AddPair('USER_NAME', edtUserName.Text);
      LJSON.AddPair('USER_PASS', LPasswordHash);

      RESTRequest.AddBody(LJSON.ToJSON, TRESTContentType.ctAPPLICATION_JSON);
    finally
      LJSON.Free;
    end;

    try
      RESTRequest.Execute;
    except
      on E: Exception do
      begin
        ShowMessage('Erro ao conectar ao servidor: ' + E.Message);
        Exit;
      end;
    end;

    case RESTResponse.StatusCode of
      200:
        begin
          ShowMessage('Login realizado com sucesso!');
          ModalResult := MrOk;
        end;
      401:
        ShowMessage('Usuário ou senha inválidos.');
      500:
        ShowMessage('Erro interno do servidor. Verifique os logs no backend.');
    else
      ShowMessage('Erro inesperado: ' + IntToStr(RESTResponse.StatusCode) + ' - ' + RESTResponse.Content);
    end;
  finally
    RESTClient.Free;
    RESTRequest.Free;
    RESTResponse.Free;
  end;
end;

procedure TFormLogin.pnBotaoSairClick(Sender: TObject);
begin
  ModalResult := mrClose;
end;

end.

