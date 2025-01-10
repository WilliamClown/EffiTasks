unit Controller.Task;

interface

uses
  System.JSON,
  TaskServiceFactory;

type
  TControllerTask = class
  private
    FTaskService: ITaskService;
  public
    constructor Create;
    destructor Destroy; override;
    function GetAllTasks: TJSONArray;
    function SaveTask(TaskData: TJSONObject): Boolean;
    function UpdateTask(TaskID: Integer; TaskData: TJSONObject): Boolean;
    function DeleteTask(TaskID: Integer): Boolean;
    function MoveTaskStatus(TaskID: Integer; Status: Integer): Boolean;
    function GetTotalTasks: Integer;
    function GetPendingTasksAveragePriority: Double;
    function GetTasksCompletedLast7Days: Integer;
  end;

implementation

constructor TControllerTask.Create;
begin
  FTaskService := TTaskServiceFactory.CreateService;
end;

destructor TControllerTask.Destroy;
begin
  FTaskService := nil;
  inherited;
end;

function TControllerTask.GetAllTasks: TJSONArray;
begin
  Result := FTaskService.GetAllTasks;
end;

function TControllerTask.SaveTask(TaskData: TJSONObject): Boolean;
begin
  Result := FTaskService.SaveNewTask(TaskData);
end;

function TControllerTask.UpdateTask(TaskID: Integer; TaskData: TJSONObject): Boolean;
begin
  Result := FTaskService.UpdateExistingTask(TaskID, TaskData);
end;

function TControllerTask.DeleteTask(TaskID: Integer): Boolean;
begin
  Result := FTaskService.DeleteTask(TaskID);
end;

function TControllerTask.GetTotalTasks: Integer;
begin
  Result := FTaskService.GetTotalTasks;
end;

function TControllerTask.MoveTaskStatus(TaskID: Integer; Status: Integer): Boolean;
var
  TaskData: TJSONObject;
  CurrentStatus: Integer;
begin
  TaskData := TJSONObject.Create;
  try
    CurrentStatus := Status;

    // Incrementa o status com limites definidos
    case CurrentStatus of
      0: CurrentStatus := 1;
      1: CurrentStatus := 2;
      2: Exit(False); // Não mover se já estiver com status final
    end;

    TaskData.AddPair('status', TJSONNumber.Create(CurrentStatus));
    Result := FTaskService.MoveStatusTask(TaskID, TaskData);
  finally
    TaskData.Free;
  end;
end;

function TControllerTask.GetPendingTasksAveragePriority: Double;
begin
  Result := FTaskService.GetPendingTasksAveragePriority;
end;

function TControllerTask.GetTasksCompletedLast7Days: Integer;
begin
  Result := FTaskService.GetTasksCompletedLast7Days;
end;

end.

