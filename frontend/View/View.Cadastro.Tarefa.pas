unit View.Cadastro.Tarefa;

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
  Vcl.DBCtrls,
  Data.DB,
  Datasnap.DBClient,
  dxmdaset,
  Vcl.ComCtrls,
  Controller.Task,
  System.JSON,
  TaskServiceFactory,
  System.DateUtils;

type
  TFormCadastroTask = class(TForm)
    pnMain: TPanel;
    Panel1: TPanel;
    lblPortaBase: TLabel;
    edtPortaBase: TEdit;
    Label1: TLabel;
    edtDescricao: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel2: TPanel;
    pnBotaoSalvarTarefa: TPanel;
    pnBotaoCancelarTarefa: TPanel;
    MDStatus: TdxMemData;
    MDStatusID: TIntegerField;
    MDStatusdesk: TStringField;
    DBLCBStatus: TDBLookupComboBox;
    dsStatus: TDataSource;
    DBLCBPrioridade: TDBLookupComboBox;
    MDPrioridade: TdxMemData;
    IntegerField1: TIntegerField;
    StringField1: TStringField;
    dsPrioridade: TDataSource;
    DTPCriado: TDateTimePicker;
    DTPFinalizado: TDateTimePicker;
    procedure pnBotaoCancelarTarefaClick(Sender: TObject);
    procedure pnBotaoSalvarTarefaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FEditMode: Boolean;
    FTaskID: Integer;
    FTaskController: TControllerTask;
  public
    { Public declarations }
    procedure EditTask(TaskID: Integer; Description: string; Priority: Integer; Status: string; CreatedAt: TDateTime);
  end;

var
  FormCadastroTask: TFormCadastroTask;

implementation

{$R *.dfm}

{ TForm2 }

procedure TFormCadastroTask.EditTask(TaskID: Integer; Description: string; Priority: Integer; Status: string; CreatedAt: TDateTime);
begin
  FEditMode := True;
  FTaskID := TaskID;
  edtDescricao.Text := Description;
  DBLCBPrioridade.KeyValue := Priority;
  DBLCBStatus.KeyValue := Status;
  DTPCriado.Date := CreatedAt;
end;

procedure TFormCadastroTask.FormCreate(Sender: TObject);
begin
  FTaskController := TControllerTask.Create;

  DBLCBStatus.KeyValue := 0;
  DBLCBPrioridade.KeyValue := 0;
  DTPCriado.Date := Now;
end;

procedure TFormCadastroTask.FormDestroy(Sender: TObject);
begin
  FTaskController.Free;
end;

procedure TFormCadastroTask.pnBotaoCancelarTarefaClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormCadastroTask.pnBotaoSalvarTarefaClick(Sender: TObject);
var
  TaskData: TJSONObject;
  Success: Boolean;
begin
  if Trim(edtDescricao.Text).IsEmpty then
  begin
    ShowMessage('A descrição não pode estar vazia.');
    Exit;
  end;

  TaskData := TJSONObject.Create;
  try
    TaskData.AddPair('description', edtDescricao.Text);
    TaskData.AddPair('priority', TJSONNumber.Create(DBLCBPrioridade.KeyValue));
    TaskData.AddPair('status', DBLCBStatus.KeyValue);
    TaskData.AddPair('created', DateToISO8601(DTPCriado.Date));

    if FEditMode then
      Success := FTaskController.UpdateTask(FTaskID, TaskData)
    else
      Success := FTaskController.SaveTask(TaskData);

    if Success then
    begin
      ShowMessage('Tarefa salva com sucesso!');
      ModalResult := mrOk;
    end
    else
      ShowMessage('Erro ao salvar a tarefa.');
  finally
    TaskData.Free;
  end;
end;

end.
