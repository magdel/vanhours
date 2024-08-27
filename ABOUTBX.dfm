object AboutBox: TAboutBox
  Left = 441
  Top = 223
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
  ClientHeight = 246
  ClientWidth = 333
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 320
    Height = 201
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 1
    object ProgramIco_: TImage
      Left = 8
      Top = 8
      Width = 121
      Height = 89
      Center = True
      Picture.Data = {
        055449636F6E0000010001002020100000000000E80200001600000028000000
        2000000040000000010004000000000080020000000000000000000000000000
        0000000000000000000080000080000000808000800000008000800080800000
        C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
        FFFFFF0000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000CCCCCCCCCCCCCCC
        CCC00000000000000C444C444CC444C444C00000000000000C444C444CC444C4
        44C00000000000000C444C444CC444C444C00000000000000C444C444CC444C4
        44C00000000000000C444C444CC444C444C00000000000000C444C444CC444C4
        44C000000000000000000C444CC444C444C00000000000777770CCCCCCCCCCCC
        CCC0000000000077777000000000000000000000000000077700000000000000
        0000000000000007770000000000000000000000000000007000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000700000000000000000000000000000077700000000000000
        0000000000000007770000000000000000000000000000777770000000000000
        0000000000000077777000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFFF3FFF87FE1FFF87FE1F
        FFCFFF3FFE000007FF80001FFF80001FFF80001FFF80001FFF80001FFF80001F
        FF80001FF000001FF800001FF80FFFFFFC1FFFFFFC1FFFFFFE3FFFFFFF7FFFFF
        FF7FFFFFFE3FFFFFFC1FFFFFFC1FFFFFF80FFFFFF80FFFFFF007FFFFFFFFFFFF
        FFFFFFFF}
      Transparent = True
      IsControl = True
    end
    object ProductName: TLabel
      Left = 129
      Top = 8
      Width = 185
      Height = 57
      Alignment = taCenter
      AutoSize = False
      Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1076#1083#1103' '#1088#1072#1089#1095#1077#1090#1072' '#1074#1072#1075#1086#1085#1086'-'#1095#1072#1089#1086#1074
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
      IsControl = True
    end
    object Version: TLabel
      Left = 136
      Top = 68
      Width = 169
      Height = 29
      Alignment = taCenter
      AutoSize = False
      Caption = #1042#1077#1088#1089#1080#1103'  2.0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      IsControl = True
    end
    object Copyright: TLabel
      Left = 8
      Top = 98
      Width = 305
      Height = 31
      Alignment = taCenter
      AutoSize = False
      Caption = 
        #1050#1072#1092#1077#1076#1088#1072' "'#1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1101#1082#1089#1087#1083#1091#1072#1090#1072#1094#1080#1086#1085#1085#1086#1081' '#1088#1072#1073#1086#1090#1086#1081'" '#1055#1077#1090#1077#1088#1073#1091#1088#1075#1089#1082#1086#1075#1086' '#1043#1086#1089 +
        #1091#1076#1072#1088#1089#1090#1074#1077#1085#1085#1086#1075#1086' '#1059#1085#1080#1074#1077#1088#1089#1080#1090#1077#1090#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Transparent = True
      WordWrap = True
      IsControl = True
    end
    object Comments: TLabel
      Left = 4
      Top = 138
      Width = 313
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = #1057#1072#1085#1082#1090'-'#1055#1077#1090#1077#1088#1073#1091#1088#1075',  '#1052#1086#1089#1082#1086#1074#1089#1082#1080#1081' '#1087#1088'. 9, '#1090#1077#1083'.'#1092#1072#1082#1089' 768-85-25'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      IsControl = True
    end
    object Label1: TLabel
      Left = 88
      Top = 156
      Width = 145
      Height = 13
      Cursor = crHandPoint
      Hint = #1055#1086#1089#1077#1090#1080#1090#1077' '#1085#1072#1096' '#1089#1072#1081#1090
      Alignment = taCenter
      Caption = 'http://www.wplus.net/pp/kgr/'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Visible = False
      OnClick = Label1Click
      OnMouseMove = Label1MouseMove
    end
    object Label2: TLabel
      Left = 8
      Top = 176
      Width = 203
      Height = 13
      Alignment = taCenter
      Caption = #1042#1086#1087#1088#1086#1089#1099' '#1080' '#1087#1088#1077#1076#1083#1086#1078#1077#1085#1080#1103' '#1088#1072#1079#1088#1072#1073#1086#1090#1095#1080#1082#1091': '
    end
    object Label3: TLabel
      Left = 216
      Top = 176
      Width = 98
      Height = 13
      Cursor = crHandPoint
      Hint = #1053#1072#1087#1080#1089#1072#1090#1100' '#1087#1080#1089#1100#1084#1086' '#1087#1088#1103#1084#1086' '#1089#1077#1081#1095#1072#1089'!'
      Caption = 'pavelrv@fromru.com'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = Label3Click
      OnMouseMove = Label3MouseMove
    end
    object Label4: TLabel
      Left = 16
      Top = 124
      Width = 289
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = #1055#1091#1090#1077#1081' '#1057#1086#1086#1073#1097#1077#1085#1080#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
  end
  object OKButton: TButton
    Left = 136
    Top = 216
    Width = 75
    Height = 25
    Caption = #1054#1050
    Default = True
    TabOrder = 0
    OnClick = OKButtonClick
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 8
    Top = 216
  end
  object AniTimer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = AniTimerTimer
    Left = 296
    Top = 216
  end
end
