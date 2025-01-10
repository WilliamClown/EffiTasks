unit View.Principal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Data.DB,
  Vcl.Grids,
  Vcl.DBGrids,
  Controller.Task,
  Datasnap.DBClient,
  System.JSON,
  Midaslib;

type
  TFormPrincipal = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    pnBotaoAtualizar: TPanel;
    pnBotaoNovaTarefa: TPanel;
    pnBotaoAtualizarTarefa: TPanel;
    pnBotaoExcluirTarefa: TPanel;
    pnBotaoMoverStatus: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    lblTotalTask: TLabel;
    lblMediaTask: TLabel;
    lblConcluidaTask: TLabel;
    DBGrid1: TDBGrid;
    dsTask: TDataSource;
    Timer1: TTimer;
    cdsTask: TClientDataSet;
    procedure pnBotaoAtualizarClick(Sender: TObject);
    procedure pnBotaoAtualizarTarefaClick(Sender: TObject);
    procedure pnBotaoExcluirTarefaClick(Sender: TObject);
    procedure pnBotaoMoverStatusClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pnBotaoNovaTarefaClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
    FControllerTask: TControllerTask;
    procedure LoadTasks;
    procedure AtualizaLabelsStatusTarefas;
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

uses
  View.Login, View.Cadastro.Tarefa, System.DateUtils;

{$R *.dfm}

procedure TFormPrincipal.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  DisplayText: string;
begin
  if Column.FieldName = 'STATUS' then
  begin
    case Column.Field.AsInteger of
      0:
        DisplayText := 'Pendente';
      1:
        DisplayText := 'Andamento';
      2:
        DisplayText := 'Finalizado';
    else
      DisplayText := 'Desconhecido';
    end;
  end
  else if Column.FieldName = 'PRIORITY' then
  begin
    case Column.Field.AsInteger of
      0:
        DisplayText := 'Baixa';
      1:
        DisplayText := 'Normal';
      2:
        DisplayText := 'Alta';
    else
      DisplayText := 'Desconhecida';
    end;
  end
  else
    DisplayText := Column.Field.AsString; // Deixe o valor padrão para as outras colunas.

  if DisplayText = 'Finalizado' then
    DBGrid1.Canvas.Brush.Color := clGreen
  else if DisplayText = 'Andamento' then
    DBGrid1.Canvas.Brush.Color := clYellow
  else if DisplayText = 'Pendente' then
    DBGrid1.Canvas.Brush.Color := clRed;

  // Exibe o texto formatado
  DBGrid1.Canvas.FillRect(Rect); // Preencher fundo da célula
  DBGrid1.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, DisplayText);
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  Timer1.Enabled := True;

  FControllerTask := TControllerTask.Create;

  if not cdsTask.Active then
  begin
    // Define a estrutura da ClientDataSet para exibir as tarefas
    cdsTask.FieldDefs.Add('ID', ftInteger);
    cdsTask.FieldDefs.Add('DESCRIPTION', ftString, 100);
    cdsTask.FieldDefs.Add('PRIORITY', ftSmallint);
    cdsTask.FieldDefs.Add('STATUS', ftSmallint);
    cdsTask.FieldDefs.Add('CREATED', ftDateTime);
    cdsTask.FieldDefs.Add('FINISHED', ftDateTime);
    cdsTask.CreateDataSet;
  end;
end;

procedure TFormPrincipal.FormDestroy(Sender: TObject);
begin
  FControllerTask.Free;
end;

procedure TFormPrincipal.LoadTasks;
var
  TaskList: TJSONArray;
  JSONObject: TJSONObject;
  I: Integer;
  x: String;
begin
  TaskList := FControllerTask.GetAllTasks;
  if Assigned(TaskList) then
  begin
    cdsTask.EmptyDataSet;

    for I := 0 to TaskList.Count - 1 do
    begin
      JSONObject := TaskList.Items[I] as TJSONObject;
      cdsTask.Append;
      cdsTask.FieldByName('ID').AsInteger := JSONObject.GetValue<Integer>('id');
      cdsTask.FieldByName('DESCRIPTION').AsString := JSONObject.GetValue<string>('description');
      cdsTask.FieldByName('PRIORITY').AsInteger := JSONObject.GetValue<Integer>('priority');
      cdsTask.FieldByName('STATUS').AsString := JSONObject.GetValue<string>('status');
      cdsTask.FieldByName('CREATED').AsDateTime := ISO8601ToDate(JSONObject.GetValue<string>('created'));

      x := JSONObject.GetValue<string>('finished');

      if x.IsEmpty then
        cdsTask.FieldByName('FINISHED').Clear
      else
        cdsTask.FieldByName('FINISHED').AsDateTime := ISO8601ToDate(x);
      cdsTask.Post;
    end;
    AtualizaLabelsStatusTarefas;
  end
  else
    ShowMessage('Erro ao carregar tarefas.');
end;

procedure TFormPrincipal.AtualizaLabelsStatusTarefas;
var
  TotalTask: Integer;
  MediaTask: Currency;
  ConcluidaTask: Integer;
begin
  TotalTask := FControllerTask.GetTotalTasks;
  MediaTask := FControllerTask.GetPendingTasksAveragePriority;
  ConcluidaTask := FControllerTask.GetTasksCompletedLast7Days;

  lblTotalTask.Caption := 'Total de tarefas: ' + IntToStr(TotalTask);
  lblMediaTask.Caption := 'Média de Tarefas pendentes: ' + FloatToStr(MediaTask);
  lblConcluidaTask.Caption := 'Tarefas Concluídas nos ultimos 7 dias: ' + IntToStr(ConcluidaTask);
end;

procedure TFormPrincipal.pnBotaoAtualizarClick(Sender: TObject);
begin
  LoadTasks;
end;

procedure TFormPrincipal.pnBotaoAtualizarTarefaClick(Sender: TObject);
var
  TaskViewForm: TFormCadastroTask;
  TaskID: Integer;
  Description: string;
  Priority: Integer;
  Status: string;
  CreatedAt: TDateTime;
begin
  if cdsTask.IsEmpty then
  begin
    ShowMessage('Selecione uma tarefa para editar.');
    Exit;
  end;

  TaskID := cdsTask.FieldByName('ID').AsInteger;
  Description := cdsTask.FieldByName('DESCRIPTION').AsString;
  Priority := cdsTask.FieldByName('PRIORITY').AsInteger;
  Status := cdsTask.FieldByName('STATUS').AsString;
  CreatedAt := cdsTask.FieldByName('CREATED').AsDateTime;

  TaskViewForm := TFormCadastroTask.Create(Self);
  try
    TaskViewForm.EditTask(TaskID, Description, Priority, Status, CreatedAt);
    if TaskViewForm.ShowModal = mrOk then
      LoadTasks;
  finally
    TaskViewForm.Free;
  end;
end;

procedure TFormPrincipal.pnBotaoExcluirTarefaClick(Sender: TObject);
var
  TaskID: Integer;
begin
  if cdsTask.IsEmpty then
  begin
    ShowMessage('Selecione uma tarefa para excluir.');
    Exit;
  end;

  if MessageDlg('Deseja realmente excluir esta tarefa?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    TaskID := cdsTask.FieldByName('ID').AsInteger;
    if FControllerTask.DeleteTask(TaskID) then
    begin
      ShowMessage('Tarefa excluída com sucesso.');
      LoadTasks;
    end
    else
      ShowMessage('Erro ao excluir a tarefa.');
  end;
end;

procedure TFormPrincipal.pnBotaoMoverStatusClick(Sender: TObject);
var
  TaskID, Status: Integer;
begin
  if cdsTask.IsEmpty then
  begin
    ShowMessage('Selecione uma tarefa para mover o status.');
    Exit;
  end;

  TaskID := cdsTask.FieldByName('ID').AsInteger;
  Status := cdsTask.FieldByName('STATUS').AsInteger;

  if FControllerTask.MoveTaskStatus(TaskID, Status) then
  begin
    ShowMessage('Status da tarefa movido com sucesso.');
    LoadTasks;
  end
  else
    ShowMessage('Não foi possível mover o status da tarefa. Verifique se já está concluída.');
end;

procedure TFormPrincipal.pnBotaoNovaTarefaClick(Sender: TObject);
var
  TaskViewForm: TFormCadastroTask;
begin
  TaskViewForm := TFormCadastroTask.Create(Self);
  try
    if TaskViewForm.ShowModal = mrOk then
      LoadTasks;
  finally
    TaskViewForm.Free;
  end;
end;

procedure TFormPrincipal.Timer1Timer(Sender: TObject);
var
  FrmLogin: TFormLogin;
begin
  Timer1.Enabled := False;
  Self.Visible := False;

  FrmLogin := TFormLogin.Create(Self);

  try
    if FrmLogin.ShowModal = mrOk then
    begin
      Self.Visible := True;
      LoadTasks;
    end
    else
      Close;
  finally
    FrmLogin.Free;
  end;
end;

end.
