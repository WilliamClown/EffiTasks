unit Controller.Task;

interface

uses
  Horse,
  System.JSON,
  Service.Task, System.SysUtils;

type
  TControllerTasks = class
  public
    class procedure GetTasks(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure AddTask(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure UpdateTaskStatus(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure DeleteTask(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetTotalTasks(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetPendingTasksAveragePriority(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetTasksCompletedLast7Days(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure MoveTaskStatus(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TTasksController }

class procedure TControllerTasks.GetTasks(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  TasksList: TJSONArray;
begin
  TasksList := TServiceTasks.GetAllTasks;
  Res.Send<TJSONArray>(TasksList).Status(200);
end;

class procedure TControllerTasks.AddTask(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  TaskData: TJSONObject;
begin
  TaskData := Req.Body<TJSONObject>;
  if TServiceTasks.AddTask(TaskData) then
    Res.Send('Tarefa adicionada com sucesso.').Status(201)
  else
    Res.Send('Erro ao adicionar tarefa.').Status(400);
end;

class procedure TControllerTasks.UpdateTaskStatus(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  TaskID: Integer;
  NewStatus, NewDescription: string;
  NewPriority: Integer;
begin
  try
    if not TryStrToInt(Req.Params['id'], TaskID) then
    begin
      Res.Send('ID da tarefa inválido.').Status(400);
      Exit;
    end;

    NewStatus := Req.Body<TJSONObject>.GetValue<string>('status', '');
    if NewStatus.IsEmpty then
    begin
      Res.Send('Status não informado.').Status(400);
      Exit;
    end;

    NewDescription := Req.Body<TJSONObject>.GetValue<string>('description', '');
    if NewDescription.IsEmpty then
    begin
      Res.Send('Descrição não informado.').Status(400);
      Exit;
    end;

    NewPriority := Req.Body<TJSONObject>.GetValue<Integer>('priority');
    if NewPriority < 0 then
    begin
      Res.Send('Prioridade não informado.').Status(400);
      Exit;
    end;

    if TServiceTasks.UpdateTaskStatus(TaskID, NewStatus, NewPriority, NewDescription) then
      Res.Send('Status da tarefa atualizado com sucesso.').Status(200)
    else
      Res.Send('Erro ao atualizar status da tarefa.').Status(400);
  except
    on E: Exception do
      Res.Send('Erro no servidor: ' + E.Message).Status(500);
  end;
end;

class procedure TControllerTasks.DeleteTask(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  TaskID: Integer;
begin
  try
    if not TryStrToInt(Req.Params['id'], TaskID) then
    begin
      Res.Send('ID da tarefa inválido.').Status(400);
      Exit;
    end;

    if TServiceTasks.DeleteTask(TaskID) then
      Res.Send('Tarefa removida com sucesso.').Status(200)
    else
      Res.Send('Erro ao remover tarefa.').Status(400);
  except
    on E: Exception do
      Res.Send('Erro no servidor: ' + E.Message).Status(500);
  end;
end;

class procedure TControllerTasks.GetTotalTasks(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  TotalTasks: Integer;
begin
  try
    TotalTasks := TServiceTasks.GetTotalTasks;
    Res.Send(TJSONObject.Create.AddPair('total_tasks', TotalTasks.ToString)).Status(200);
  except
    on E: Exception do
      Res.Send('Erro no servidor: ' + E.Message).Status(500);
  end;
end;

class procedure TControllerTasks.MoveTaskStatus(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  TaskID: Integer;
  NewStatus: string;
begin
  try
    if not TryStrToInt(Req.Params['id'], TaskID) then
    begin
      Res.Send('ID da tarefa inválido.').Status(400);
      Exit;
    end;

    NewStatus := Req.Body<TJSONObject>.GetValue<string>('status', '');
    if NewStatus.IsEmpty then
    begin
      Res.Send('Status não informado.').Status(400);
      Exit;
    end;

    if TServiceTasks.MoveTaskStatus(TaskID, NewStatus) then
      Res.Send('Status da tarefa atualizado com sucesso.').Status(200)
    else
      Res.Send('Erro ao atualizar status da tarefa.').Status(400);
  except
    on E: Exception do
      Res.Send('Erro no servidor: ' + E.Message).Status(500);
  end;
end;

class procedure TControllerTasks.GetPendingTasksAveragePriority(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  AveragePriority: Double;
begin
  try
    AveragePriority := TServiceTasks.GetPendingTasksAveragePriority;
    Res.Send(TJSONObject.Create.AddPair('average_priority', FormatFloat('0.00', AveragePriority))).Status(200);
  except
    on E: Exception do
      Res.Send('Erro no servidor: ' + E.Message).Status(500);
  end;
end;

class procedure TControllerTasks.GetTasksCompletedLast7Days(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  CompletedCount: Integer;
begin
  try
    CompletedCount := TServiceTasks.GetTasksCompletedLast7Days;
    Res.Send(TJSONObject.Create.AddPair('completed_last_7_days', CompletedCount.ToString)).Status(200);
  except
    on E: Exception do
      Res.Send('Erro no servidor: ' + E.Message).Status(500);
  end;
end;

end.
