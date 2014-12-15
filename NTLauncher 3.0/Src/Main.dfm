object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'NTLauncher 3.0'
  ClientHeight = 463
  ClientWidth = 592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MainPageControl: TPageControl
    Left = -4
    Top = -3
    Width = 602
    Height = 466
    ActivePage = AuthSheet
    MultiLine = True
    TabOrder = 0
    TabPosition = tpBottom
    object AuthSheet: TTabSheet
      Caption = #1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Calibri'
      Font.Style = []
      ParentFont = False
      object Label1: TLabel
        Left = 152
        Top = 159
        Width = 33
        Height = 14
        Caption = #1051#1086#1075#1080#1085':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Calibri'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 152
        Top = 198
        Width = 43
        Height = 14
        Caption = #1055#1072#1088#1086#1083#1100':'
      end
      object Label3: TLabel
        Left = 152
        Top = 236
        Width = 35
        Height = 14
        Caption = #1055#1086#1095#1090#1072':'
        Visible = False
      end
      object RegLabel: TLabel
        Left = 151
        Top = 301
        Width = 66
        Height = 14
        Caption = #1056#1077#1075#1080#1089#1090#1088#1072#1094#1080#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHotLight
        Font.Height = -12
        Font.Name = 'Calibri'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = RegLabelClick
        OnMouseDown = RegLabelMouseDown
        OnMouseUp = RegLabelMouseUp
        OnMouseEnter = RegLabelMouseEnter
        OnMouseLeave = RegLabelMouseLeave
      end
      object LauncherTitle: TLabel
        Left = 144
        Top = 57
        Width = 304
        Height = 53
        Caption = 'NTLauncher 3.0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -45
        Font.Name = 'HeliosThin'
        Font.Style = []
        ParentFont = False
      end
      object AuthButton: TButton
        Left = 150
        Top = 320
        Width = 294
        Height = 44
        Caption = #1040#1074#1090#1086#1088#1080#1079#1086#1074#1072#1090#1100#1089#1103
        TabOrder = 0
        OnClick = AuthButtonClick
      end
      object AutoLoginCheckbox: TCheckBox
        Left = 334
        Top = 299
        Width = 106
        Height = 17
        Caption = #1047#1072#1087#1086#1084#1085#1080#1090#1100' '#1083#1086#1075#1080#1085
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Calibri'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object LoginEdit: TEdit
        Left = 208
        Top = 153
        Width = 235
        Height = 27
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Calibri'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object MailEdit: TEdit
        Left = 208
        Top = 229
        Width = 235
        Height = 27
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Calibri'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Visible = False
      end
      object PasswordEdit: TEdit
        Left = 208
        Top = 191
        Width = 235
        Height = 27
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Calibri'
        Font.Style = []
        ParentFont = False
        PasswordChar = #8226
        TabOrder = 4
      end
    end
    object GameSheet: TTabSheet
      Caption = #1042#1093#1086#1076' '#1074' '#1080#1075#1088#1091
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Calibri'
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      object CloakImage: TImage
        Left = 198
        Top = 200
        Width = 56
        Height = 78
        Stretch = True
      end
      object SkinImage: TImage
        Left = 64
        Top = 138
        Width = 70
        Height = 140
      end
      object Label4: TLabel
        Left = 38
        Top = 72
        Width = 26
        Height = 14
        Caption = 'Java:'
      end
      object Label5: TLabel
        Left = 39
        Top = 101
        Width = 27
        Height = 14
        Caption = 'RAM:'
      end
      object Label6: TLabel
        Left = 141
        Top = 104
        Width = 55
        Height = 14
        Caption = #1057#1074#1086#1073#1086#1076#1085#1086':'
      end
      object FreeRAMLabel: TLabel
        Left = 211
        Top = 104
        Width = 25
        Height = 14
        Caption = '0 '#1052#1073
        OnClick = FreeRAMLabelClick
      end
      object AssetsSpeedLabel: TLabel
        Left = 374
        Top = 296
        Width = 87
        Height = 14
        Caption = #1057#1082#1086#1088#1086#1089#1090#1100': 0 '#1050#1073'/c'
      end
      object MainSpeedLabel: TLabel
        Left = 374
        Top = 148
        Width = 100
        Height = 14
        Caption = #1057#1082#1086#1088#1086#1089#1090#1100': 0 '#1050#1073'/'#1089#1077#1082
      end
      object MainSizeOfFileLabel: TLabel
        Left = 374
        Top = 104
        Width = 107
        Height = 14
        Caption = #1056#1072#1079#1084#1077#1088' '#1092#1072#1081#1083#1072': 0 '#1052#1073
      end
      object MainLabel: TLabel
        Left = 356
        Top = 72
        Width = 31
        Height = 14
        Caption = 'Main:'
      end
      object MainDownloadedLabel: TLabel
        Left = 374
        Top = 126
        Width = 88
        Height = 14
        Caption = #1047#1072#1075#1088#1091#1078#1077#1085#1086': 0 '#1052#1073
      end
      object MainRemainingTimeLabel: TLabel
        Left = 374
        Top = 170
        Width = 82
        Height = 14
        Caption = #1054#1089#1090#1072#1083#1086#1089#1100': 0 '#1089#1077#1082
      end
      object AssetsSizeOfFileLabel: TLabel
        Left = 374
        Top = 252
        Width = 107
        Height = 14
        Caption = #1056#1072#1079#1084#1077#1088' '#1092#1072#1081#1083#1072': 0 '#1052#1073
      end
      object AssetsRemainingTimeLabel: TLabel
        Left = 374
        Top = 318
        Width = 82
        Height = 14
        Caption = #1054#1089#1090#1072#1083#1086#1089#1100': 0 '#1089#1077#1082
      end
      object AssetsLabel: TLabel
        Left = 356
        Top = 220
        Width = 39
        Height = 14
        Caption = 'Assets:'
      end
      object AssetsDownloadedLabel: TLabel
        Left = 374
        Top = 274
        Width = 88
        Height = 14
        Caption = #1047#1072#1075#1088#1091#1078#1077#1085#1086': 0 '#1052#1073
      end
      object DeauthLabel: TLabel
        Left = 471
        Top = 14
        Width = 85
        Height = 14
        Caption = #1042#1099#1081#1090#1080' '#1080#1079' '#1083#1086#1075#1080#1085#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHotLight
        Font.Height = -12
        Font.Name = 'Calibri'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = DeauthLabelClick
        OnMouseDown = DeauthLabelMouseDown
        OnMouseUp = DeauthLabelMouseUp
        OnMouseEnter = DeauthLabelMouseEnter
        OnMouseLeave = DeauthLabelMouseLeave
      end
      object MonitoringLabel: TLabel
        Left = 152
        Top = 359
        Width = 75
        Height = 14
        Caption = #1048#1075#1088#1072#1102#1090': 0 '#1080#1079' 0'
        Visible = False
      end
      object ChooseCloakButton: TButton
        Left = 171
        Top = 286
        Width = 108
        Height = 25
        Caption = #1042#1099#1073#1088#1072#1090#1100' '#1087#1083#1072#1097
        TabOrder = 0
        OnClick = ChooseCloakButtonClick
      end
      object ChooseSkinButton: TButton
        Left = 47
        Top = 286
        Width = 108
        Height = 25
        Caption = #1042#1099#1073#1088#1072#1090#1100' '#1089#1082#1080#1085
        TabOrder = 1
        OnClick = ChooseSkinButtonClick
      end
      object GameButton: TButton
        Left = 152
        Top = 379
        Width = 309
        Height = 40
        Caption = #1048#1075#1088#1072#1090#1100
        TabOrder = 2
        OnClick = GameButtonClick
      end
      object JavaEdit: TEdit
        Left = 79
        Top = 69
        Width = 191
        Height = 22
        TabOrder = 3
        Text = 'E:\Program Files\Java\jre8\bin'
      end
      object OpenClientFolder: TButton
        Left = 170
        Top = 19
        Width = 147
        Height = 34
        Caption = #1055#1072#1087#1082#1072' '#1089' '#1080#1075#1088#1086#1081
        TabOrder = 4
        OnClick = OpenClientFolderClick
      end
      object OpenLauncherFolder: TButton
        Left = 16
        Top = 19
        Width = 147
        Height = 34
        Caption = #1055#1072#1087#1082#1072' '#1089' '#1083#1072#1091#1085#1095#1077#1088#1086#1084
        TabOrder = 5
        OnClick = OpenLauncherFolderClick
      end
      object RAMEdit: TEdit
        Left = 79
        Top = 100
        Width = 45
        Height = 22
        TabOrder = 6
        Text = '1024'
      end
      object ServerListComboBox: TComboBox
        Left = 278
        Top = 355
        Width = 182
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 7
        Visible = False
        OnSelect = ServerListComboBoxSelect
      end
      object UploadCloakButton: TButton
        Left = 171
        Top = 312
        Width = 108
        Height = 25
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1083#1072#1097
        TabOrder = 8
        OnClick = UploadCloakButtonClick
      end
      object UploadSkinButton: TButton
        Left = 47
        Top = 312
        Width = 108
        Height = 25
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1082#1080#1085
        TabOrder = 9
        OnClick = UploadSkinButtonClick
      end
      object DownloadMainButton: TButton
        Left = 400
        Top = 68
        Width = 75
        Height = 25
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
        TabOrder = 10
        OnClick = DownloadMainButtonClick
      end
      object DownloadAssetsButton: TButton
        Left = 400
        Top = 215
        Width = 75
        Height = 25
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
        TabOrder = 11
        OnClick = DownloadAssetsButtonClick
      end
    end
    object TabSheet1: TTabSheet
      Caption = #1054#1090#1083#1072#1076#1082#1072' '#1082#1083#1080#1077#1085#1090#1072
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object DebugPageControl: TPageControl
        Left = 3
        Top = 3
        Width = 588
        Height = 434
        ActivePage = TabSheet2
        TabOrder = 0
        object TabSheet2: TTabSheet
          Caption = #1050#1086#1084#1072#1085#1076#1085#1072#1103' '#1089#1090#1088#1086#1082#1072
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object CommandLineConsole: TMemo
            Left = 0
            Top = 0
            Width = 578
            Height = 405
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
        object TabSheet3: TTabSheet
          Caption = #1050#1086#1085#1089#1086#1083#1100' '#1082#1083#1080#1077#1085#1090#1072
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object ClientConsole: TMemo
            Left = 0
            Top = 0
            Width = 578
            Height = 405
            ScrollBars = ssVertical
            TabOrder = 0
            OnChange = ClientConsoleChange
          end
        end
      end
    end
  end
  object ClientSocket: TClientSocket
    Active = False
    ClientType = ctBlocking
    Port = 0
    OnConnect = ClientSocketConnect
    Left = 11
    Top = 399
  end
end
