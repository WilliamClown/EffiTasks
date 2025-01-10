program TarefasFrontend;

uses
  Vcl.Forms,
  View.Login in 'View\View.Login.pas' {FormLogin},
  View.Principal in 'View\View.Principal.pas' {FormPrincipal},
  Controller.Task in 'Controller\Controller.Task.pas',
  View.Cadastro.Tarefa in 'View\View.Cadastro.Tarefa.pas' {FormCadastroTask},
  TaskServiceFactory in 'Service\TaskServiceFactory.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
