program TarefasBackEnd;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Backend.Application in 'Backend.Application.pas',
  Service.Users in 'Service\Service.Users.pas',
  Controller.Users in 'Controller\Controller.Users.pas',
  DAO.Database in 'DAO\DAO.Database.pas',
  Controller.Task in 'Controller\Controller.Task.pas',
  Service.Task in 'Service\Service.Task.pas';

begin
  try
    Writeln('Iniciando o servidor Horse...');
    InitializeServer;
  except
    on E: Exception do
    begin
      Writeln('Erro ao iniciar o servidor: ' + E.Message);
      Readln;
    end;
  end;
end.
