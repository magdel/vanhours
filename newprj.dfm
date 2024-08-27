object NewProjForm: TNewProjForm
  Left = 441
  Top = 313
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1054#1073#1097#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
  ClientHeight = 62
  ClientWidth = 382
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 12
    Width = 138
    Height = 13
    Caption = #1053#1072#1095#1072#1083#1100#1085#1086#1077' '#1082#1086#1083'-'#1074#1086' '#1074#1072#1075#1086#1085#1086#1074':'
  end
  object Edit1: TEdit
    Left = 160
    Top = 8
    Width = 121
    Height = 21
    MaxLength = 5
    TabOrder = 0
    Text = '300'
  end
  object Button1: TButton
    Left = 296
    Top = 8
    Width = 75
    Height = 25
    Caption = '&'#1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object cbCalcKV: TCheckBox
    Left = 16
    Top = 38
    Width = 129
    Height = 17
    Caption = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1050#1042#1044#1048
    TabOrder = 2
  end
end
