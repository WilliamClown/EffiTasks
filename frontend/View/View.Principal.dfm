object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  Caption = 'Effi Tasks - Gerenciamento de Tarefas'
  ClientHeight = 647
  ClientWidth = 1109
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1109
    Height = 647
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Panel2: TPanel
      Left = 0
      Top = 598
      Width = 1109
      Height = 49
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object lblTotalTask: TLabel
        Left = 8
        Top = 16
        Width = 94
        Height = 17
        Caption = 'Total de tarefas:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lblMediaTask: TLabel
        Left = 141
        Top = 16
        Width = 170
        Height = 17
        Caption = 'M'#233'dia de Tarefas pendentes:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lblConcluidaTask: TLabel
        Left = 358
        Top = 16
        Width = 222
        Height = 17
        Caption = 'Tarefas Conclu'#237'das nos ultimos 7 dias:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 106
      Width = 1109
      Height = 484
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object DBGrid1: TDBGrid
        Left = 0
        Top = 0
        Width = 1109
        Height = 484
        Align = alClient
        DataSource = dsTask
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDrawColumnCell = DBGrid1DrawColumnCell
        Columns = <
          item
            Expanded = False
            FieldName = 'id'
            Title.Caption = 'ID Tarefa'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DESCRIPTION'
            Title.Caption = 'Descri'#231#227'o'
            Width = 342
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PRIORITY'
            Title.Caption = 'Prioridade'
            Width = 66
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'STATUS'
            Title.Caption = 'Status'
            Width = 110
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CREATED'
            Title.Caption = 'Criado Em'
            Width = 110
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FINISHED'
            Title.Caption = 'Finalidao Em'
            Width = 110
            Visible = True
          end>
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 57
      Width = 1109
      Height = 49
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object pnBotaoNovaTarefa: TPanel
        Left = 8
        Top = 6
        Width = 165
        Height = 32
        Caption = 'Nova Tarefa'
        Color = clMoneyGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        OnClick = pnBotaoNovaTarefaClick
      end
      object pnBotaoAtualizarTarefa: TPanel
        Left = 179
        Top = 6
        Width = 165
        Height = 32
        Caption = 'Atualizar Tarefa'
        Color = 9240575
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
        OnClick = pnBotaoAtualizarTarefaClick
      end
      object pnBotaoExcluirTarefa: TPanel
        Left = 350
        Top = 6
        Width = 165
        Height = 32
        Caption = 'Excluir Tarefa'
        Color = 5592575
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 2
        OnClick = pnBotaoExcluirTarefaClick
      end
      object pnBotaoMoverStatus: TPanel
        Left = 521
        Top = 6
        Width = 165
        Height = 32
        Caption = 'Mover Status'
        Color = clHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 3
        OnClick = pnBotaoMoverStatusClick
      end
    end
    object Panel5: TPanel
      Left = 0
      Top = 0
      Width = 1109
      Height = 49
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
      object pnBotaoAtualizar: TPanel
        Left = 8
        Top = 8
        Width = 165
        Height = 32
        Caption = 'Atualizar'
        Color = clActiveCaption
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        OnClick = pnBotaoAtualizarClick
      end
    end
    object Panel6: TPanel
      Left = 0
      Top = 49
      Width = 1109
      Height = 8
      Align = alTop
      BevelOuter = bvNone
      Color = clGrayText
      ParentBackground = False
      TabOrder = 4
    end
    object Panel7: TPanel
      Left = 0
      Top = 590
      Width = 1109
      Height = 8
      Align = alBottom
      BevelOuter = bvNone
      Color = clGrayText
      ParentBackground = False
      TabOrder = 5
    end
  end
  object dsTask: TDataSource
    AutoEdit = False
    DataSet = cdsTask
    Left = 408
    Top = 284
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 816
    Top = 330
  end
  object cdsTask: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 500
    Top = 306
  end
end
