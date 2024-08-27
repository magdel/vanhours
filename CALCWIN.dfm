object CalcForm: TCalcForm
  Left = 380
  Top = 170
  Width = 580
  Height = 368
  ActiveControl = ATListView
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefaultPosOnly
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 263
    Width = 572
    Height = 78
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 0
    object Label3: TLabel
      Left = 16
      Top = 8
      Width = 163
      Height = 13
      Caption = #1053#1072#1095#1072#1083#1100#1085#1086#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1074#1072#1075#1086#1085#1086#1074':'
    end
    object Label4: TLabel
      Left = 184
      Top = 8
      Width = 32
      Height = 13
      Cursor = crIBeam
      Caption = 'Label4'
      OnClick = Label4Click
      OnMouseMove = Label4MouseMove
    end
    object Label7: TLabel
      Left = 16
      Top = 24
      Width = 90
      Height = 13
      Caption = #1055#1088#1086#1089#1090#1086#1081' '#1074#1072#1075#1086#1085#1086#1074':'
    end
    object Label8: TLabel
      Left = 16
      Top = 40
      Width = 166
      Height = 13
      Caption = #1057#1088#1077#1076#1085#1080#1081' '#1087#1088#1086#1089#1090#1086#1081' '#1086#1076#1085#1086#1075#1086' '#1074#1072#1075#1086#1085#1072':'
    end
    object Label9: TLabel
      Left = 112
      Top = 24
      Width = 32
      Height = 13
      Caption = 'Label9'
    end
    object Label10: TLabel
      Left = 184
      Top = 40
      Width = 38
      Height = 13
      Caption = 'Label10'
    end
    object Label11: TLabel
      Left = 16
      Top = 56
      Width = 97
      Height = 13
      Caption = #1055#1088#1086#1094#1077#1089#1089' '#1094#1080#1082#1083#1080#1095#1077#1085':'
    end
    object Label12: TLabel
      Left = 120
      Top = 56
      Width = 38
      Height = 13
      Caption = 'Label12'
    end
    object lbKVDI: TLabel
      Left = 296
      Top = 8
      Width = 106
      Height = 13
      Cursor = crHandPoint
      Caption = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1050#1042#1044#1048
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = Label4Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 572
    Height = 263
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 281
      Top = 0
      Height = 263
    end
    object Panel3: TPanel
      Left = 284
      Top = 0
      Width = 288
      Height = 263
      Align = alClient
      Caption = 'Panel2'
      TabOrder = 0
      DesignSize = (
        288
        263)
      object Label2: TLabel
        Left = 8
        Top = 8
        Width = 158
        Height = 13
        Caption = #1055#1086#1077#1079#1076#1072' '#1089#1074#1086#1077#1075#1086' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1103':'
      end
      object DTListView: TListView
        Left = 8
        Top = 24
        Width = 272
        Height = 232
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            AutoSize = True
            Caption = #1053#1086#1084#1077#1088
            MaxWidth = 70
            MinWidth = 30
          end
          item
            Alignment = taRightJustify
            AutoSize = True
            Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085#1080#1077
            MaxWidth = 120
            MinWidth = 50
          end
          item
            Alignment = taCenter
            AutoSize = True
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1072#1075#1086#1085#1086#1074
            MaxWidth = 200
            MinWidth = 60
          end>
        HotTrack = True
        ReadOnly = True
        RowSelect = True
        SmallImages = MainForm.ImageList1
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = ATListViewColumnClick
        OnCompare = LVTimeCompare
        OnDblClick = DTListViewDblClick
        OnKeyDown = DTListViewKeyDown
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 281
      Height = 263
      Align = alLeft
      Caption = 'Panel1'
      TabOrder = 1
      DesignSize = (
        281
        263)
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 226
        Height = 13
        Caption = #1055#1086#1077#1079#1076#1072', '#1087#1088#1080#1073#1099#1074#1072#1102#1097#1080#1077' '#1074' '#1088#1072#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077':'
      end
      object ATListView: TListView
        Left = 8
        Top = 24
        Width = 265
        Height = 232
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            AutoSize = True
            Caption = #1053#1086#1084#1077#1088
            MaxWidth = 70
            MinWidth = 30
          end
          item
            Alignment = taRightJustify
            AutoSize = True
            Caption = #1055#1088#1080#1073#1099#1090#1080#1077
            MaxWidth = 120
            MinWidth = 50
          end
          item
            Alignment = taCenter
            AutoSize = True
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1072#1075#1086#1085#1086#1074
            MaxWidth = 200
            MinWidth = 65
          end>
        HotTrack = True
        IconOptions.Arrangement = iaLeft
        ReadOnly = True
        RowSelect = True
        SmallImages = MainForm.ImageList1
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = ATListViewColumnClick
        OnCompare = LVTimeCompare
        OnDblClick = ATListViewDblClick
        OnKeyDown = ATListViewKeyDown
      end
    end
  end
  object LTimer: TTimer
    Enabled = False
    Interval = 200
    OnTimer = LTimerTimer
    Left = 496
    Top = 264
  end
end
