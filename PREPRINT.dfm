object PrePForm: TPrePForm
  Left = 258
  Top = 135
  Caption = #1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1088#1086#1089#1084#1086#1090#1088
  ClientHeight = 1
  ClientWidth = 124
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000001100011000000000000000000000000111101111000000000000000000
    0000011110111100111111111100000000000011000110011111111111000111
    1000100001000011111111111100011110011111111111111111111111000011
    0011111111111111111111111100001110000000000000000000000000000001
    11000011111111111000011110000001B100001BB1BBB1BB100001B100000000
    1B10001BB1BBB1BB10001B10000000001B10001BB1BBB1BB10001B1000000000
    01B1001BB1BBB1BB1001B1000000000001B10011111111111001B10000000000
    001B100011111110001B100000000000001B100000101000001B100000000000
    0001B1000010100001B10000000000000001B1000010100011B1000000000000
    00001B10001010001B1000000000000000001B11101010111B10000000000000
    0000011000101000110000000000000000000110111111101100000000000000
    000000101BBBBB101000000000000000000000101B111B101000000000000000
    000000101BBBBB10100000000000000000000010111111101000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFFFCE7FFFFF843FFFFF843003FFCE6003877BC00386000003CC00
    0003C7FFFFFFE3C00787E3C0078FF1C0071FF1C0071FF8C0063FF8C0063FFC70
    1C7FFC7D7C7FFE3D78FFFE3D70FFFF1D71FFFF0541FFFF9D73FFFF9013FFFFD0
    17FFFFD017FFFFD017FFFFD017FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
  KeyPreview = True
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 13
  object ControlBar2: TControlBar
    Left = 0
    Top = 0
    Width = 124
    Height = 30
    Align = alTop
    AutoDrag = False
    AutoSize = True
    DockSite = False
    TabOrder = 0
    ExplicitWidth = 120
    object ToolBar1: TToolBar
      Left = 11
      Top = 2
      Width = 103
      Height = 22
      Caption = 'ToolBar1'
      HotImages = MainForm.HotImageList
      Images = MainForm.ImageList1
      TabOrder = 0
      object ToolButton1: TToolButton
        Left = 0
        Top = 0
        Action = APrevPrnSetup
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton2: TToolButton
        Left = 23
        Top = 0
        Action = APrevPrint
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton11: TToolButton
        Left = 46
        Top = 0
        Action = AExp
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton3: TToolButton
        Left = 69
        Top = 0
        Width = 8
        Caption = 'ToolButton3'
        ImageIndex = 2
        Style = tbsSeparator
      end
      object Label1: TLabel
        Left = 77
        Top = 0
        Width = 62
        Height = 22
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1052#1072#1089#1096#1090#1072#1073': '
        Layout = tlCenter
      end
      object ScaleCmbBox: TComboBox
        Left = 139
        Top = 0
        Width = 103
        Height = 21
        Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1093#1086#1076#1103#1097#1080#1081'  '#1084#1072#1089#1096#1090#1072#1073
        Style = csDropDownList
        DropDownCount = 10
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnChange = ScaleCmbBoxChange
        Items.Strings = (
          '10 %'
          '25 %'
          '50 %'
          '75 %'
          '100 %'
          '150 %'
          '200 %'
          '500 %'
          #1055#1086' '#1096#1080#1088#1080#1085#1077' '#1089#1090#1088#1072#1085#1080#1094#1099
          #1057#1090#1088#1072#1085#1080#1094#1072' '#1094#1077#1083#1080#1082#1086#1084)
      end
      object ToolButton4: TToolButton
        Left = 242
        Top = 0
        Width = 8
        Caption = 'ToolButton4'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object SpeedButton1: TSpeedButton
        Left = 250
        Top = 0
        Width = 58
        Height = 22
        Caption = #1047#1072'&'#1082#1088#1099#1090#1100
        Flat = True
        Transparent = False
        OnClick = SpeedButton1Click
      end
    end
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 30
    Width = 124
    Height = 626
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Align = alClient
    Color = clGray
    ParentColor = False
    TabOrder = 1
    OnMouseWheelDown = ScrollBox1MouseWheelDown
    OnMouseWheelUp = ScrollBox1MouseWheelUp
    ExplicitWidth = 120
    object PaintBox1: TPaintBox
      Left = 8
      Top = 8
      Width = 630
      Height = 889
      Color = clWhite
      ParentColor = False
      OnMouseDown = PaintBox1MouseDown
      OnPaint = PaintBox1Paint
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = -18
    Width = 124
    Height = 19
    Panels = <
      item
        Alignment = taRightJustify
        Text = '1 '#1080#1079' 1'
        Width = 160
      end
      item
        Width = 200
      end>
    ExplicitTop = -19
    ExplicitWidth = 120
  end
  object ActionList1: TActionList
    Images = MainForm.ImageList1
    Left = 674
    Top = 56
    object APrevPrnSetup: TAction
      Caption = 'APrevPrnSetup'
      Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1088#1080#1085#1090#1077#1088#1072
      ImageIndex = 3
      OnExecute = APrevPrnSetupExecute
      OnUpdate = APrevPrnSetupUpdate
    end
    object APrevPrint: TAction
      Caption = 'APrevPrint'
      Hint = #1055#1077#1095#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1072
      ImageIndex = 4
      OnExecute = APrevPrintExecute
      OnUpdate = APrevPrintUpdate
    end
    object AExp: TAction
      Hint = #1069#1082#1089#1087#1086#1088#1090' '#1086#1090#1095#1077#1090#1072' '#1074' '#1092#1072#1081#1083' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103
      ImageIndex = 2
      OnExecute = AExpExecute
      OnUpdate = AExpUpdate
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103'|*.emf|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = #1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1072#1087#1082#1091
    Left = 618
    Top = 56
  end
end
