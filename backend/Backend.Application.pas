unit Backend.Application;

interface

uses
  Horse,
  Horse.Jhonson,
  System.SysUtils,
  System.JSON,
  Controller.Users,
  Controller.Task;

procedure InitializeServer;

implementation

procedure InitializeServer;
begin
  THorse.Use(Jhonson);

  // Rota de autenticação
  THorse.Post('/login', TControllerUsers.Login);

  // Rotas de tarefas
  THorse.Get('/tasks', TControllerTasks.GetTasks);
  THorse.Post('/tasks', TControllerTasks.AddTask);
  THorse.Put('/tasks/:id', TControllerTasks.UpdateTaskStatus);
  THorse.Delete('/tasks/:id', TControllerTasks.DeleteTask);
  THorse.Get('/tasks/total', TControllerTasks.GetTotalTasks);
  THorse.Get('/tasks/average-priority', TControllerTasks.GetPendingTasksAveragePriority);
  THorse.Get('/tasks/completed-last-7-days', TControllerTasks.GetTasksCompletedLast7Days);
  THorse.Put('/tasks/:id/move-status', TControllerTasks.MoveTaskStatus);

  THorse.Listen(9000);
end;

end.
