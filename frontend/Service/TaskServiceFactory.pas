unit TaskServiceFactory;

interface

uses
  System.JSON,
  System.SysUtils,
  Data.DB,
  FireDAC.Comp.Client,
  REST.Client,
  System.DateUtils;

type
  ITaskService = interface
    ['{C3B7E5D2-6DF6-4B8A-B87C-7E6532A8B1D9}']
    function GetAllTasks: TJSONArray;
    function SaveNewTask(TaskData: TJSONObject): Boolean;
    function UpdateExistingTask(TaskID: Integer; TaskData: TJSONObject): Boolean;
    function DeleteTask(TaskID: Integer): Boolean;
    function GetTotalTasks: Integer;
    function GetPendingTasksAveragePriority: Double;
    function GetTasksCompletedLast7Days: Integer;
    function MoveStatusTask(TaskID: Integer; TaskData: TJSONObject): Boolean;
  end;

  TTaskServiceBase = class(TInterfacedObject, ITaskService)
  public
    function GetAllTasks: TJSONArray; virtual; abstract;
    function SaveNewTask(TaskData: TJSONObject): Boolean; virtual; abstract;
    function UpdateExistingTask(TaskID: Integer; TaskData: TJSONObject): Boolean; virtual; abstract;
    function DeleteTask(TaskID: Integer): Boolean; virtual; abstract;
    function GetTotalTasks: Integer; virtual; abstract;
    function GetPendingTasksAveragePriority: Double; virtual; abstract;
    function GetTasksCompletedLast7Days: Integer; virtual; abstract;
    function MoveStatusTask(TaskID: Integer; TaskData: TJSONObject): Boolean; virtual; abstract;
  end;

  TRESTTaskService = class(TTaskServiceBase)
  private
    function CreateRESTClient: TRESTClient;
  public
    function GetAllTasks: TJSONArray; override;
    function SaveNewTask(TaskData: TJSONObject): Boolean; override;
    function UpdateExistingTask(TaskID: Integer; TaskData: TJSONObject): Boolean; override;
    function DeleteTask(TaskID: Integer): Boolean; override;
    function GetTotalTasks: Integer; override;
    function GetPendingTasksAveragePriority: Double; override;
    function GetTasksCompletedLast7Days: Integer; override;
    function MoveStatusTask(TaskID: Integer; TaskData: TJSONObject): Boolean; override;
  end;

  TTaskServiceFactory = class
  public
    class function CreateService: ITaskService;
  end;

implementation

uses
  REST.Types;

{ TRESTTaskService }

function TRESTTaskService.CreateRESTClient: TRESTClient;
begin
  Result := TRESTClient.Create('http://localhost:9000');
end;

function TRESTTaskService.GetAllTasks: TJSONArray;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
begin
  RESTClient := CreateRESTClient;
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  try
    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Resource := 'tasks';
    RESTRequest.Method := TRESTRequestMethod.rmGET;

    RESTRequest.Execute;

    if RESTResponse.StatusCode = 200 then
      Result := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONArray
    else
      Result := nil;

  finally
    RESTClient.Free;
    RESTRequest.Free;
    RESTResponse.Free;
  end;
end;

function TRESTTaskService.SaveNewTask(TaskData: TJSONObject): Boolean;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  CreatedDate: TDateTime;
begin
  RESTClient := CreateRESTClient;
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  try
    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Resource := 'tasks';
    RESTRequest.Method := TRESTRequestMethod.rmPOST;

    if TaskData.GetValue<TJSONValue>('created') = nil then
    begin
      CreatedDate := Now;
      TaskData.AddPair('CREATED', DateToISO8601(CreatedDate));
    end;

    RESTRequest.AddBody(TaskData.ToJSON, TRESTContentType.ctAPPLICATION_JSON);
    RESTRequest.Execute;

    Result := RESTResponse.StatusCode = 201;
  finally
    RESTClient.Free;
    RESTRequest.Free;
    RESTResponse.Free;
  end;
end;

function TRESTTaskService.UpdateExistingTask(TaskID: Integer; TaskData: TJSONObject): Boolean;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  TaskIDStr: string;
begin
  RESTClient := CreateRESTClient;
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  try
    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;

    TaskIDStr := IntToStr(TaskID);
    RESTRequest.Resource := 'tasks/' + TaskIDStr;
    RESTRequest.Method := TRESTRequestMethod.rmPUT;

    if TaskData.GetValue<TJSONValue>('created') = nil then
    begin
      TaskData.AddPair('CREATED', DateToISO8601(Now));
    end;

    RESTRequest.AddBody(TaskData.ToJSON, TRESTContentType.ctAPPLICATION_JSON);
    RESTRequest.Execute;

    Result := RESTResponse.StatusCode = 200;
  finally
    RESTClient.Free;
    RESTRequest.Free;
    RESTResponse.Free;
  end;
end;

function TRESTTaskService.DeleteTask(TaskID: Integer): Boolean;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  TaskIDStr: string;
begin
  RESTClient := CreateRESTClient;
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  try
    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;

    TaskIDStr := IntToStr(TaskID);
    RESTRequest.Resource := 'tasks/' + TaskIDStr;
    RESTRequest.Method := TRESTRequestMethod.rmDELETE;

    RESTRequest.Execute;

    Result := RESTResponse.StatusCode = 200;
  finally
    RESTClient.Free;
    RESTRequest.Free;
    RESTResponse.Free;
  end;
end;

function TRESTTaskService.GetTotalTasks: Integer;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  JSONObj: TJSONObject;
begin
  RESTClient := CreateRESTClient;
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  try
    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Resource := 'tasks/total';
    RESTRequest.Method := TRESTRequestMethod.rmGET;

    RESTRequest.Execute;

    if RESTResponse.StatusCode = 200 then
    begin
      JSONObj := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONObject;
      if Assigned(JSONObj) then
        Result := JSONObj.GetValue<Integer>('total_tasks')
      else
        Result := 0;
    end
    else
      Result := 0;
  finally
    RESTClient.Free;
    RESTRequest.Free;
    RESTResponse.Free;
  end;
end;

function TRESTTaskService.MoveStatusTask(TaskID: Integer; TaskData: TJSONObject): Boolean;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  TaskIDStr: string;
begin
  RESTClient := CreateRESTClient;
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  try
    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;

    TaskIDStr := IntToStr(TaskID);
    RESTRequest.Resource := 'tasks/' + TaskIDStr + '/move-status';
    RESTRequest.Method := TRESTRequestMethod.rmPUT;

    RESTRequest.AddBody(TaskData.ToJSON, TRESTContentType.ctAPPLICATION_JSON);
    RESTRequest.Execute;

    Result := RESTResponse.StatusCode = 200;
  finally
    RESTClient.Free;
    RESTRequest.Free;
    RESTResponse.Free;
  end;
end;

function TRESTTaskService.GetPendingTasksAveragePriority: Double;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  JSONObj: TJSONObject;
  JSONValue: TJSONValue;
begin
  RESTClient := CreateRESTClient;
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  try
    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Resource := 'tasks/average-priority';
    RESTRequest.Method := TRESTRequestMethod.rmGET;

    RESTRequest.Execute;

    if RESTResponse.StatusCode = 200 then
    begin
      JSONObj := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONObject;
      JSONValue := JSONObj.GetValue('average_priority');

      if Assigned(JSONValue) and not (JSONValue is TJSONNull) then
        Result := StrToFloatDef(StringReplace(JSONValue.Value, ',', '.', [rfReplaceAll]), 0.0)
      else
        Result := 0;
    end
    else
      Result := 0;
  finally
    RESTClient.Free;
    RESTRequest.Free;
    RESTResponse.Free;
  end;
end;

function TRESTTaskService.GetTasksCompletedLast7Days: Integer;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  JSONObj: TJSONObject;
begin
  RESTClient := CreateRESTClient;
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  try
    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Resource := 'tasks/completed-last-7-days';
    RESTRequest.Method := TRESTRequestMethod.rmGET;

    RESTRequest.Execute;

    if RESTResponse.StatusCode = 200 then
    begin
      JSONObj := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONObject;
      if Assigned(JSONObj) then
        Result := JSONObj.GetValue<Integer>('completed_last_7_days')
      else
        Result := 0;
    end
    else
      Result := 0;
  finally
    RESTClient.Free;
    RESTRequest.Free;
    RESTResponse.Free;
  end;
end;

{ TTaskServiceFactory }

class function TTaskServiceFactory.CreateService: ITaskService;
begin
  Result := TRESTTaskService.Create;
end;

end.
