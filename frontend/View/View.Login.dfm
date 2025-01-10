object FormLogin: TFormLogin
  Left = 0
  Top = 0
  Caption = 'Autentica'#231#227'o'
  ClientHeight = 312
  ClientWidth = 362
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 17
  object pnMain: TPanel
    Left = 0
    Top = 0
    Width = 362
    Height = 312
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    ExplicitLeft = 236
    ExplicitTop = 88
    ExplicitWidth = 185
    ExplicitHeight = 41
    object lblLoginTitulo: TLabel
      Left = 68
      Top = 32
      Width = 221
      Height = 37
      Caption = 'Login do Sistema'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clActiveCaption
      Font.Height = -27
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 40
      Top = 108
      Width = 32
      Height = 17
      Caption = 'Login'
    end
    object Label2: TLabel
      Left = 40
      Top = 160
      Width = 35
      Height = 17
      Caption = 'Senha'
    end
    object edtUserName: TEdit
      Left = 40
      Top = 128
      Width = 241
      Height = 25
      TabOrder = 0
    end
    object edtPassword: TEdit
      Left = 40
      Top = 180
      Width = 241
      Height = 25
      TabOrder = 1
    end
    object pnBotaoLogin: TPanel
      Left = 16
      Top = 260
      Width = 133
      Height = 41
      BevelOuter = bvNone
      Caption = 'Login'
      Color = clMoneyGreen
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 2
      OnClick = pnBotaoLoginClick
    end
    object pnBotaoSair: TPanel
      Left = 204
      Top = 260
      Width = 133
      Height = 41
      Caption = 'Sair'
      Color = 5329407
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 3
      OnClick = pnBotaoSairClick
    end
  end
end
