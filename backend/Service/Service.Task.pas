unit Service.Task;

interface

uses
  System.JSON,
  System.SysUtils,
  Data.DB,
  FireDAC.Comp.Client,
  System.DateUtils,
  System.Variants,
  FireDAC.Stan.Param;

type
  TServiceTasks = class
  public
    class function GetAllTasks: TJSONArray;
    class function AddTask(TaskData: TJSONObject): Boolean;
    class function UpdateTaskStatus(TaskID: Integer; NewStatus: string; NewPriority: Integer; NewDescription: string): Boolean;
    class function DeleteTask(TaskID: Integer): Boolean;
    class function GetTotalTasks: Integer;
    class function GetPendingTasksAveragePriority: Double;
    class function GetTasksCompletedLast7Days: Integer;
    class function MoveTaskStatus(TaskID: Integer; NewStatus: string): Boolean;
  end;

implementation

uses
  DAO.Database;

{ TServiceTasks }

class function TServiceTasks.GetAllTasks: TJSONArray;
var
  Query: TFDQuery;
  TaskObj: TJSONObject;
  TasksList: TJSONArray;
begin
  TasksList := TJSONArray.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := TDatabaseConnection.GetInstance.GetConnection;
    Query.SQL.Text := 'SELECT * FROM TASK';
    Query.Open;
    while not Query.Eof do
    begin
      TaskObj := TJSONObject.Create;
      TaskObj.AddPair('id', Query.FieldByName('ID_TASK').AsString);
      TaskObj.AddPair('description', Query.FieldByName('DESCRIPTION').AsString);
      TaskObj.AddPair('priority', Query.FieldByName('PRIORITY').AsString);
      TaskObj.AddPair('status', Query.FieldByName('STATUS').AsString);
      TaskObj.AddPair('created', DateToISO8601(Query.FieldByName('CREATED').AsDateTime));

      if Query.FieldByName('FINISHED').IsNull then
        TaskObj.AddPair('finished', TJSONNull.Create)
      else
        TaskObj.AddPair('finished', DateToISO8601(Query.FieldByName('FINISHED').AsDateTime));
      TasksList.AddElement(TaskObj);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
  Result := TasksList;
end;

class function TServiceTasks.AddTask(TaskData: TJSONObject): Boolean;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    try
      Query.Connection := TDatabaseConnection.GetInstance.GetConnection;
      Query.SQL.Text :=
        'INSERT INTO TASK (DESCRIPTION, PRIORITY, STATUS, CREATED, FINISHED) VALUES (:DESCRIPTION, :PRIORITY, :STATUS, :CREATED, :FINISHED)';
      Query.ParamByName('DESCRIPTION').AsString := TaskData.GetValue<string>('description');
      Query.ParamByName('PRIORITY').AsInteger := TaskData.GetValue<Integer>('priority');
      Query.ParamByName('STATUS').AsString := TaskData.GetValue<string>('status');

      Query.ParamByName('FINISHED').DataType := ftDateTime;
      Query.ParamByName('FINISHED').ParamType := ptInput;

      if Query.ParamByName('STATUS').AsString = '2' then
        Query.ParamByName('FINISHED').AsDateTime := Now
      else
        Query.ParamByName('FINISHED').Clear;

      Query.ParamByName('CREATED').AsDateTime := Now;
      Query.ExecSQL;
      Result := True;
    except
      Result := False;
    end;
  finally
    Query.Free;
  end;
end;

class function TServiceTasks.UpdateTaskStatus(TaskID: Integer; NewStatus: string; NewPriority: Integer;
  NewDescription: string): Boolean;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    try
      Query.Connection := TDatabaseConnection.GetInstance.GetConnection;
      Query.SQL.Text := 'UPDATE TASK SET STATUS = :STATUS, DESCRIPTION = :DESCRIPTION, PRIORITY = :PRIORITY, FINISHED = :FINISHED  WHERE ID_TASK = :ID';

      Query.ParamByName('STATUS').AsString := NewStatus;
      Query.ParamByName('DESCRIPTION').AsString := NewDescription;
      Query.ParamByName('PRIORITY').Asinteger := NewPriority;
      Query.ParamByName('ID').AsInteger := TaskID;

      Query.ParamByName('FINISHED').DataType := ftDateTime;
      Query.ParamByName('FINISHED').ParamType := ptInput;

      if NewStatus = '2' then
        Query.ParamByName('FINISHED').AsDateTime := Now
      else
        Query.ParamByName('FINISHED').Clear;

      Query.ExecSQL;
      Result := Query.RowsAffected > 0;
    except
      Result := False;
    end;
  finally
    Query.Free;
  end;
end;

class function TServiceTasks.DeleteTask(TaskID: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    try
      Query.Connection := TDatabaseConnection.GetInstance.GetConnection;
      Query.SQL.Text := 'DELETE FROM TASK WHERE ID_TASK = :ID';
      Query.ParamByName('ID').AsInteger := TaskID;
      Query.ExecSQL;
      Result := Query.RowsAffected > 0;
    except
      Result := False;
    end;
  finally
    Query.Free;
  end;
end;

class function TServiceTasks.GetTotalTasks: Integer;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := TDatabaseConnection.GetInstance.GetConnection;
    Query.SQL.Text := 'SELECT COUNT(*) AS TOTAL FROM TASK';
    Query.Open;
    Result := Query.FieldByName('TOTAL').AsInteger;
  finally
    Query.Free;
  end;
end;

class function TServiceTasks.MoveTaskStatus(TaskID: Integer; NewStatus: string): Boolean;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    try
      Query.Connection := TDatabaseConnection.GetInstance.GetConnection;
      Query.SQL.Text := 'UPDATE TASK SET STATUS = :STATUS, FINISHED = :FINISHED WHERE ID_TASK = :ID';
      Query.ParamByName('STATUS').AsString := NewStatus;

      Query.ParamByName('FINISHED').DataType := ftDateTime;
      Query.ParamByName('FINISHED').ParamType := ptInput;

      if NewStatus = '2' then
        Query.ParamByName('FINISHED').AsDateTime := Now
      else
        Query.ParamByName('FINISHED').Clear;

      Query.ParamByName('ID').AsInteger := TaskID;
      Query.ExecSQL;
      Result := Query.RowsAffected > 0;
    except
      Result := False;
    end;
  finally
    Query.Free;
  end;
end;

class function TServiceTasks.GetPendingTasksAveragePriority: Double;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := TDatabaseConnection.GetInstance.GetConnection;
    Query.SQL.Text := 'SELECT AVG(PRIORITY) AS AVG_PRIORITY FROM TASK WHERE STATUS = 0';
    Query.Open;
    Result := Query.FieldByName('AVG_PRIORITY').AsFloat;
  finally
    Query.Free;
  end;
end;

class function TServiceTasks.GetTasksCompletedLast7Days: Integer;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := TDatabaseConnection.GetInstance.GetConnection;
    Query.SQL.Text := 'SELECT COUNT(*) AS COMPLETED_COUNT FROM TASK WHERE STATUS = 2 AND CREATED >= DATEADD(DAY, -7, GETDATE())';
    Query.Open;
    Result := Query.FieldByName('COMPLETED_COUNT').AsInteger;
  finally
    Query.Free;
  end;
end;

end.
