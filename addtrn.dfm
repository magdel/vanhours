object AddTForm: TAddTForm
  Left = 275
  Top = 281
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086#1077#1079#1076'...'
  ClientHeight = 185
  ClientWidth = 278
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 169
    Height = 169
    Caption = ' '#1055#1086#1077#1079#1076' '
    TabOrder = 0
    object Label1: TLabel
      Left = 40
      Top = 24
      Width = 37
      Height = 13
      Caption = #1053#1086#1084#1077#1088':'
    end
    object Label2: TLabel
      Left = 14
      Top = 52
      Width = 81
      Height = 13
      Caption = #1050#1086#1083'-'#1074#1086' '#1074#1072#1075#1086#1085#1086#1074':'
    end
    object Label3: TLabel
      Left = 16
      Top = 80
      Width = 36
      Height = 13
      Caption = #1042#1088#1077#1084#1103':'
    end
    object Label4: TLabel
      Left = 72
      Top = 104
      Width = 20
      Height = 13
      Caption = #1095#1072#1089'.'
    end
    object Label5: TLabel
      Left = 72
      Top = 136
      Width = 23
      Height = 13
      Caption = #1084#1080#1085'.'
    end
    object NumberSE: TSpinEdit
      Left = 80
      Top = 20
      Width = 73
      Height = 22
      MaxLength = 4
      MaxValue = 4000
      MinValue = 2000
      TabOrder = 0
      Value = 2001
      OnKeyDown = NumberSEKeyDown
    end
    object VanCountSE: TSpinEdit
      Left = 97
      Top = 48
      Width = 56
      Height = 22
      MaxValue = 500
      MinValue = 1
      TabOrder = 1
      Value = 50
      OnKeyDown = NumberSEKeyDown
    end
    object HourSE: TSpinEdit
      Left = 16
      Top = 96
      Width = 49
      Height = 22
      MaxValue = 23
      MinValue = 0
      TabOrder = 2
      Value = 18
      OnKeyDown = NumberSEKeyDown
    end
    object MinuteSE: TSpinEdit
      Left = 16
      Top = 128
      Width = 49
      Height = 22
      MaxValue = 59
      MinValue = 0
      TabOrder = 3
      Value = 0
      OnKeyDown = NumberSEKeyDown
    end
  end
  object Button1: TButton
    Left = 192
    Top = 16
    Width = 75
    Height = 25
    Caption = '&'#1054#1050
    Default = True
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 192
    Top = 48
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&'#1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
end
