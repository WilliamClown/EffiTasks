object FormCadastroTask: TFormCadastroTask
  Left = 0
  Top = 0
  Caption = 'Tarefa'
  ClientHeight = 266
  ClientWidth = 591
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnMain: TPanel
    Left = 0
    Top = 0
    Width = 591
    Height = 266
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    Padding.Left = 20
    Padding.Top = 20
    Padding.Right = 20
    Padding.Bottom = 20
    ParentBackground = False
    TabOrder = 0
    object Panel1: TPanel
      Left = 20
      Top = 20
      Width = 551
      Height = 185
      Align = alClient
      BevelOuter = bvNone
      Color = clInactiveBorder
      Padding.Right = 20
      ParentBackground = False
      TabOrder = 0
      object lblPortaBase: TLabel
        Left = 10
        Top = 4
        Width = 15
        Height = 17
        Caption = 'ID:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label1: TLabel
        Left = 182
        Top = 4
        Width = 60
        Height = 17
        Caption = 'Descri'#231#227'o:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 10
        Top = 51
        Width = 38
        Height = 17
        Caption = 'Status:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 182
        Top = 51
        Width = 64
        Height = 17
        Caption = 'Criado em:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 359
        Top = 51
        Width = 83
        Height = 17
        Caption = 'Finalizado em:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 10
        Top = 98
        Width = 64
        Height = 17
        Caption = 'Prioridade:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object edtPortaBase: TEdit
        Left = 10
        Top = 24
        Width = 166
        Height = 21
        Enabled = False
        TabOrder = 0
      end
      object edtDescricao: TEdit
        Left = 182
        Top = 24
        Width = 355
        Height = 21
        TabOrder = 1
      end
      object DBLCBStatus: TDBLookupComboBox
        Left = 10
        Top = 71
        Width = 166
        Height = 21
        DataField = 'STATUS'
        KeyField = 'ID'
        ListField = 'desk'
        ListSource = dsStatus
        TabOrder = 2
      end
      object DBLCBPrioridade: TDBLookupComboBox
        Left = 10
        Top = 118
        Width = 166
        Height = 21
        DataField = 'PRIORITY'
        KeyField = 'ID'
        ListField = 'desk'
        ListSource = dsPrioridade
        TabOrder = 3
      end
      object DTPCriado: TDateTimePicker
        Left = 182
        Top = 71
        Width = 171
        Height = 21
        Date = 45667.000000000000000000
        Time = 0.582255243054532900
        Enabled = False
        TabOrder = 4
      end
      object DTPFinalizado: TDateTimePicker
        Left = 359
        Top = 71
        Width = 171
        Height = 21
        Date = 45667.000000000000000000
        Time = 0.582255243054532900
        Enabled = False
        TabOrder = 5
      end
    end
    object Panel2: TPanel
      Left = 20
      Top = 205
      Width = 551
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object pnBotaoSalvarTarefa: TPanel
        Left = 305
        Top = 9
        Width = 115
        Height = 32
        Caption = 'Salvar'
        Color = clMoneyGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        OnClick = pnBotaoSalvarTarefaClick
      end
      object pnBotaoCancelarTarefa: TPanel
        Left = 426
        Top = 9
        Width = 115
        Height = 32
        Caption = 'Cancelar'
        Color = 5592575
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
        OnClick = pnBotaoCancelarTarefaClick
      end
    end
  end
  object MDStatus: TdxMemData
    Active = True
    Indexes = <>
    Persistent.Data = {
      5665728FC2F5285C8FFE3F020000000400000003000300494400140000000100
      05006465736B000100000000010800000050656E64656E746501010000000109
      000000416E64616D656E746F0102000000010A00000046696E616C697A61646F}
    SortOptions = []
    Left = 312
    Top = 160
    object MDStatusID: TIntegerField
      FieldName = 'ID'
    end
    object MDStatusdesk: TStringField
      FieldName = 'desk'
    end
  end
  object dsStatus: TDataSource
    DataSet = MDStatus
    Left = 380
    Top = 160
  end
  object MDPrioridade: TdxMemData
    Active = True
    Indexes = <>
    Persistent.Data = {
      5665728FC2F5285C8FFE3F020000000400000003000300494400140000000100
      05006465736B0001000000000105000000426169786101010000000106000000
      4E6F726D616C01020000000104000000416C7461}
    SortOptions = []
    Left = 452
    Top = 152
    object IntegerField1: TIntegerField
      FieldName = 'ID'
    end
    object StringField1: TStringField
      FieldName = 'desk'
    end
  end
  object dsPrioridade: TDataSource
    DataSet = MDPrioridade
    Left = 520
    Top = 156
  end
end
