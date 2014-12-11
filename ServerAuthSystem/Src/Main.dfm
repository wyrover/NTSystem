object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1057#1080#1089#1090#1077#1084#1072' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103' '#1089#1077#1088#1074#1077#1088#1086#1084
  ClientHeight = 595
  ClientWidth = 730
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label9: TLabel
    Left = 25
    Top = 571
    Width = 14
    Height = 13
    Caption = 'IP:'
  end
  object IPLabel: TLabel
    Left = 45
    Top = 571
    Width = 51
    Height = 13
    Caption = '127.0.0.1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHotLight
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label10: TLabel
    Left = 163
    Top = 571
    Width = 35
    Height = 13
    Caption = #1057#1086#1082#1077#1090':'
  end
  object SocketStatusLabel: TLabel
    Left = 204
    Top = 571
    Width = 63
    Height = 13
    Caption = #1042#1099#1082#1083#1102#1095#1077#1085
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label12: TLabel
    Left = 343
    Top = 571
    Width = 41
    Height = 13
    Caption = #1057#1077#1088#1074#1077#1088':'
  end
  object ServerStatusLabel: TLabel
    Left = 390
    Top = 571
    Width = 63
    Height = 13
    Caption = #1042#1099#1082#1083#1102#1095#1077#1085
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label14: TLabel
    Left = 513
    Top = 571
    Width = 26
    Height = 13
    Caption = 'RAM:'
  end
  object RAMLabel: TLabel
    Left = 545
    Top = 571
    Width = 27
    Height = 13
    Caption = '0 M'#1073
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label16: TLabel
    Left = 629
    Top = 571
    Width = 24
    Height = 13
    Caption = 'CPU:'
  end
  object CPULabel: TLabel
    Left = 659
    Top = 571
    Width = 20
    Height = 13
    Caption = '0%'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHotLight
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object PageControl: TPageControl
    Left = 8
    Top = 8
    Width = 713
    Height = 557
    ActivePage = MainPage
    Font.Charset = DEFAULT_CHARSET
    Font.Color = -1
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object MainPage: TTabSheet
      Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1086#1073#1074#1103#1079#1082#1086#1081
      object Label8: TLabel
        Left = 22
        Top = 114
        Width = 73
        Height = 13
        Caption = #1055#1086#1088#1090' '#1086#1073#1074#1103#1079#1082#1080':'
      end
      object Label13: TLabel
        Left = 22
        Top = 139
        Width = 83
        Height = 13
        Caption = #1040#1076#1088#1077#1089' NTPlague:'
      end
      object Label20: TLabel
        Left = 22
        Top = 160
        Width = 14
        Height = 13
        Caption = 'IP:'
      end
      object Label21: TLabel
        Left = 134
        Top = 160
        Width = 4
        Height = 13
        Caption = ':'
      end
      object Label22: TLabel
        Left = 31
        Top = 456
        Width = 73
        Height = 13
        Caption = #1044#1077#1089#1082#1088#1080#1087#1090#1086#1088#1099':'
      end
      object Label23: TLabel
        Left = 31
        Top = 475
        Width = 41
        Height = 13
        Caption = #1055#1086#1090#1086#1082#1080':'
      end
      object Label24: TLabel
        Left = 31
        Top = 494
        Width = 56
        Height = 13
        Caption = 'ServerCPU:'
      end
      object HandlesCountLabel: TLabel
        Left = 117
        Top = 456
        Width = 6
        Height = 13
        Caption = '0'
      end
      object ThreadsCountLabel: TLabel
        Left = 117
        Top = 475
        Width = 6
        Height = 13
        Caption = '0'
      end
      object ServerCPULabel: TLabel
        Left = 117
        Top = 494
        Width = 17
        Height = 13
        Caption = '0%'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label15: TLabel
        Left = 22
        Top = 186
        Width = 102
        Height = 13
        Caption = #1058#1072#1081#1084#1072#1091#1090' '#1087#1086#1076#1082#1083'., '#1084#1089':'
      end
      object ServerPathButton: TButton
        Left = 10
        Top = 16
        Width = 175
        Height = 42
        Caption = #1042' '#1087#1072#1087#1082#1091' '#1089' '#1089#1077#1088#1074#1077#1088#1086#1084
        TabOrder = 0
        OnClick = ServerPathButtonClick
      end
      object SelfPathButton: TButton
        Left = 10
        Top = 60
        Width = 175
        Height = 42
        Caption = #1042' '#1087#1072#1087#1082#1091' '#1089' '#1086#1073#1074#1103#1079#1082#1086#1081
        TabOrder = 1
        OnClick = SelfPathButtonClick
      end
      object GroupBox1: TGroupBox
        Left = 197
        Top = 11
        Width = 499
        Height = 509
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1086#1073#1074#1103#1079#1082#1080
        TabOrder = 2
        object Label1: TLabel
          Left = 24
          Top = 29
          Width = 27
          Height = 13
          Caption = 'Java:'
        end
        object Label2: TLabel
          Left = 240
          Top = 29
          Width = 26
          Height = 13
          Caption = 'RAM:'
        end
        object Label3: TLabel
          Left = 24
          Top = 61
          Width = 61
          Height = 13
          Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099':'
        end
        object Label4: TLabel
          Left = 24
          Top = 96
          Width = 41
          Height = 13
          Caption = #1057#1077#1088#1074#1077#1088':'
        end
        object Label5: TLabel
          Left = 240
          Top = 96
          Width = 90
          Height = 13
          Caption = #1042#1077#1088#1089#1080#1103' '#1083#1072#1091#1085#1095#1077#1088#1072':'
        end
        object Label6: TLabel
          Left = 24
          Top = 210
          Width = 24
          Height = 13
          Caption = 'md5:'
        end
        object Label7: TLabel
          Left = 24
          Top = 264
          Width = 29
          Height = 13
          Caption = #1057#1086#1083#1100':'
        end
        object Label18: TLabel
          Left = 310
          Top = 192
          Width = 14
          Height = 13
          Caption = 'IP:'
        end
        object Label19: TLabel
          Left = 416
          Top = 192
          Width = 4
          Height = 13
          Caption = ':'
        end
        object Label11: TLabel
          Left = 253
          Top = 314
          Width = 25
          Height = 13
          Caption = #1089#1077#1082'.)'
        end
        object Label17: TLabel
          Left = 15
          Top = 374
          Width = 369
          Height = 13
          Caption = 
            'MySQL-'#1079#1072#1087#1088#1086#1089' '#1085#1072' '#1074#1099#1073#1086#1088#1082#1091' '#1083#1086#1075#1080#1085#1072' '#1080' '#1087#1072#1088#1086#1083#1103' [ SELECT COUNT(*) AS NUM' +
            ' ]:'
        end
        object Label25: TLabel
          Left = 15
          Top = 419
          Width = 365
          Height = 13
          Caption = 
            'MySQL-'#1079#1072#1087#1088#1086#1089' '#1085#1072' '#1074#1099#1073#1086#1088#1082#1091' '#1083#1086#1075#1080#1085#1072' '#1080' '#1087#1086#1095#1090#1099' [ SELECT COUNT(*) AS NUM ' +
            ']:'
        end
        object Label26: TLabel
          Left = 15
          Top = 461
          Width = 162
          Height = 13
          Caption = 'MySQL-'#1079#1072#1087#1088#1086#1089' '#1085#1072' '#1079#1072#1087#1080#1089#1100' '#1074' '#1073#1072#1079#1091':'
        end
        object Label27: TLabel
          Left = 302
          Top = 270
          Width = 24
          Height = 13
          Caption = 'Host:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -11
          Font.Name = 'Calibri Light'
          Font.Style = []
          ParentFont = False
        end
        object Label28: TLabel
          Left = 432
          Top = 270
          Width = 4
          Height = 13
          Caption = ':'
        end
        object Label29: TLabel
          Left = 302
          Top = 295
          Width = 27
          Height = 13
          Caption = 'Login:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -11
          Font.Name = 'Calibri Light'
          Font.Style = []
          ParentFont = False
        end
        object Label30: TLabel
          Left = 302
          Top = 320
          Width = 46
          Height = 13
          Caption = 'Password:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -11
          Font.Name = 'Calibri Light'
          Font.Style = []
          ParentFont = False
        end
        object Label31: TLabel
          Left = 302
          Top = 345
          Width = 49
          Height = 13
          Caption = 'BaseName:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -11
          Font.Name = 'Calibri Light'
          Font.Style = []
          ParentFont = False
        end
        object JavaPathEdit: TEdit
          Left = 57
          Top = 26
          Width = 170
          Height = 21
          TabOrder = 0
          Text = 'C:\Program Files\Java\jre8\bin'
        end
        object RAMEdit: TEdit
          Left = 273
          Top = 26
          Width = 45
          Height = 21
          TabOrder = 1
          Text = '3072'
        end
        object JVMParamsEdit: TEdit
          Left = 91
          Top = 58
          Width = 387
          Height = 21
          TabOrder = 2
          Text = 
            '-server -D64 -XX:MaxPermSize=512m -XX:+UnlockCommercialFeatures ' +
            '-XX:+UseLargePages -XX:+AggressiveOpts -XX:+UseAdaptiveSizePolic' +
            'y -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:UseSSE=4 -XX' +
            ':+DisableExplicitGC -XX:MaxGCPauseMillis=100 -XX:ParallelGCThrea' +
            'ds=8 -DJINTEGRA_NATIVE_MODE -DJINTEGRA_COINIT_VALUE=0 -Dsun.io.u' +
            'seCanonCaches=false -Djline.terminal=jline.UnsupportedTerminal -' +
            'XX:ThreadPriorityPolicy=42 -XX:CompileThreshold=1500 -XX:+Tiered' +
            'Compilation -XX:TargetSurvivorRatio=90 -XX:MaxTenuringThreshold=' +
            '15 -XX:+UnlockExperimentalVMOptions -XX:+UseAdaptiveGCBoundary -' +
            'XX:PermSize=1024M -XX:+UseGCOverheadLimit -XX:+UseBiasedLocking ' +
            '-Xnoclassgc -Xverify:none -XX:+UseThreadPriorities -Djava.net.pr' +
            'eferIPv4Stack=true -XX:+UseStringCache -XX:+OptimizeStringConcat' +
            ' -XX:+UseFastAccessorMethods -Xrs -XX:+UseCompressedOops'
        end
        object ServerPathEdit: TEdit
          Left = 71
          Top = 93
          Width = 156
          Height = 21
          TabOrder = 3
          Text = 'D:\Minecraft\Spigot\Spigot.jar'
        end
        object LauncherVersionEdit: TEdit
          Left = 335
          Top = 93
          Width = 41
          Height = 21
          TabOrder = 4
          Text = '0'
        end
        object CheckMD5: TCheckBox
          Left = 24
          Top = 184
          Width = 97
          Height = 17
          Caption = #1055#1088#1086#1074#1077#1088#1103#1090#1100' MD5'
          TabOrder = 5
        end
        object SaltedHash: TCheckBox
          Left = 127
          Top = 184
          Width = 97
          Height = 17
          Caption = #1057#1086#1083#1105#1085#1099#1077' '#1093#1101#1096#1080
          TabOrder = 6
        end
        object ChecksumEdit: TEdit
          Left = 59
          Top = 207
          Width = 212
          Height = 21
          TabOrder = 7
          Text = 'e9960995974979445b03bc644b9e9853'
        end
        object SaltWatchDog: TCheckBox
          Left = 24
          Top = 237
          Width = 209
          Height = 17
          Caption = #1055#1088#1086#1074#1077#1088#1103#1090#1100' '#1089#1086#1083#1100' WatchDog'#39'a'
          TabOrder = 8
        end
        object GlobalSaltEdit: TEdit
          Left = 60
          Top = 262
          Width = 211
          Height = 21
          TabOrder = 9
          Text = #1057#1086#1083#1100
        end
        object CheckHWIDOnLogin: TCheckBox
          Left = 24
          Top = 130
          Width = 176
          Height = 17
          Caption = #1055#1088#1086#1074#1077#1088#1103#1090#1100' HWID '#1087#1088#1080' '#1083#1086#1075#1080#1085#1077
          TabOrder = 10
        end
        object CheckHWIDOnReg: TCheckBox
          Left = 24
          Top = 150
          Width = 192
          Height = 17
          Caption = #1055#1088#1086#1074#1077#1088#1103#1090#1100' HWID '#1087#1088#1080' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
          TabOrder = 11
        end
        object WorkAsDistributor: TCheckBox
          Left = 302
          Top = 222
          Width = 196
          Height = 17
          Caption = #1056#1072#1073#1086#1090#1072#1090#1100' '#1082#1072#1082' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1080#1090#1077#1083#1100
          TabOrder = 12
        end
        object AllGranted: TRadioButton
          Left = 302
          Top = 124
          Width = 113
          Height = 17
          Caption = #1055#1091#1089#1082#1072#1090#1100' '#1074#1089#1077#1093
          Checked = True
          TabOrder = 13
          TabStop = True
        end
        object LocalBase: TRadioButton
          Left = 302
          Top = 144
          Width = 113
          Height = 17
          Caption = #1051#1086#1082#1072#1083#1100#1085#1072#1103' '#1073#1072#1079#1072
          TabOrder = 14
        end
        object UseDistributor: TRadioButton
          Left = 302
          Top = 164
          Width = 184
          Height = 17
          Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1080#1090#1077#1083#1100':'
          TabOrder = 15
        end
        object DistributorIPEdit: TEdit
          Left = 328
          Top = 189
          Width = 84
          Height = 21
          TabOrder = 16
          Text = '127.0.0.1'
        end
        object DistributorPortEdit: TEdit
          Left = 423
          Top = 189
          Width = 48
          Height = 21
          TabOrder = 17
          Text = '65533'
        end
        object DeletePlayersOnEnter: TCheckBox
          Left = 24
          Top = 292
          Width = 129
          Height = 17
          Caption = #1056#1072#1079#1083#1086#1075#1080#1085' '#1087#1088#1080' '#1074#1093#1086#1076#1077
          TabOrder = 18
        end
        object TimeoutEdit: TEdit
          Left = 211
          Top = 311
          Width = 37
          Height = 21
          TabOrder = 19
          Text = '10'
        end
        object DeletePlayersOnTimer: TCheckBox
          Left = 24
          Top = 312
          Width = 185
          Height = 17
          Caption = #1056#1072#1079#1083#1086#1075#1080#1085' '#1087#1086' '#1090#1072#1081#1084#1077#1088#1091' ('#1090#1072#1081#1084#1072#1091#1090' = '
          TabOrder = 20
        end
        object Panel1: TPanel
          Left = 290
          Top = 123
          Width = 1
          Height = 238
          TabOrder = 21
        end
        object UseMySQL: TCheckBox
          Left = 302
          Top = 242
          Width = 130
          Height = 17
          Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' MySQL'
          TabOrder = 22
        end
        object LoginPassRequest: TEdit
          Left = 15
          Top = 390
          Width = 474
          Height = 19
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -9
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 23
          Text = 
            'FROM `TableName` WHERE `login`='#39'$login'#39' AND `password`='#39'$passwor' +
            'd'#39
        end
        object LoginMailRequest: TEdit
          Left = 15
          Top = 434
          Width = 474
          Height = 19
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -9
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 24
          Text = 'FROM `TableName` WHERE `login`='#39'$login'#39' AND `mail`='#39'$mail'#39
        end
        object InsertRequest: TEdit
          Left = 15
          Top = 477
          Width = 474
          Height = 19
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -9
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 25
          Text = 'INSERT INTO `TableName` VALUES ('#39'$login'#39','#39'$password'#39','#39'$mail'#39')'
        end
        object dbHostEdit: TEdit
          Left = 336
          Top = 268
          Width = 93
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Calibri Light'
          Font.Style = []
          ParentFont = False
          TabOrder = 26
          Text = '127.0.0.1'
        end
        object dbPortEdit: TEdit
          Left = 439
          Top = 268
          Width = 45
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Calibri Light'
          Font.Style = []
          ParentFont = False
          TabOrder = 27
          Text = '3306'
        end
        object dbLoginEdit: TEdit
          Left = 336
          Top = 293
          Width = 148
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Calibri Light'
          Font.Style = []
          ParentFont = False
          TabOrder = 28
          Text = 'User'
        end
        object dbPasswordEdit: TEdit
          Left = 357
          Top = 318
          Width = 127
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Calibri Light'
          Font.Style = []
          ParentFont = False
          TabOrder = 29
          Text = 'Password'
        end
        object dbBaseEdit: TEdit
          Left = 357
          Top = 343
          Width = 127
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Calibri Light'
          Font.Style = []
          ParentFont = False
          TabOrder = 30
          Text = 'BaseName'
        end
      end
      object SaveSettingsButton: TButton
        Left = 10
        Top = 213
        Width = 175
        Height = 40
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1074' '#1088#1077#1077#1089#1090#1088
        TabOrder = 3
        WordWrap = True
        OnClick = SaveSettingsButtonClick
      end
      object SocketPortEdit: TEdit
        Left = 99
        Top = 112
        Width = 58
        Height = 21
        TabOrder = 4
        Text = '65533'
      end
      object StartSocketButton: TButton
        Left = 10
        Top = 310
        Width = 175
        Height = 43
        Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1086#1073#1074#1103#1079#1082#1091
        TabOrder = 5
        OnClick = StartSocketButtonClick
      end
      object StartServerButton: TButton
        Left = 10
        Top = 356
        Width = 175
        Height = 43
        Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1089#1077#1088#1074#1077#1088
        TabOrder = 6
        OnClick = StartServerButtonClick
      end
      object AutorestartCheckbox: TCheckBox
        Left = 11
        Top = 423
        Width = 161
        Height = 17
        Caption = #1040#1074#1090#1086#1088#1077#1089#1090#1072#1088#1090' '#1087#1088#1080' '#1086#1096#1080#1073#1082#1072#1093
        TabOrder = 7
      end
      object PluginIPEdit: TEdit
        Left = 39
        Top = 158
        Width = 92
        Height = 21
        TabOrder = 8
        Text = '127.0.0.1'
      end
      object PluginPortEdit: TEdit
        Left = 140
        Top = 158
        Width = 44
        Height = 21
        TabOrder = 9
        Text = '35533'
      end
      object FlushServerMemory: TCheckBox
        Left = 11
        Top = 404
        Width = 170
        Height = 17
        Caption = #1054#1095#1080#1089#1090#1082#1072' '#1087#1072#1084#1103#1090#1080' '#1089#1077#1088#1074#1077#1088#1072
        TabOrder = 10
      end
      object PluginTimeoutEdit: TEdit
        Left = 140
        Top = 182
        Width = 44
        Height = 21
        TabOrder = 11
        Text = '150'
      end
      object SaveSettingsToFileButton: TButton
        Left = 10
        Top = 256
        Width = 175
        Height = 40
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1074' '#1092#1072#1081#1083
        TabOrder = 12
        OnClick = SaveSettingsToFileButtonClick
      end
    end
    object TabSheet1: TTabSheet
      Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1080#1075#1088#1086#1082#1072#1084#1080
      ImageIndex = 3
      object PlayersGrid: TStringGrid
        Left = 3
        Top = 2
        Width = 481
        Height = 522
        Color = clWhite
        ColCount = 1
        DefaultColWidth = 693
        DefaultRowHeight = 20
        FixedCols = 0
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = -1
        Font.Height = -16
        Font.Name = 'Museo Slab 500'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        OnDrawCell = PlayersGridDrawCell
        OnMouseDown = PlayersGridMouseDown
      end
      object PlayersList: TStringGrid
        Left = 482
        Top = 2
        Width = 216
        Height = 522
        ColCount = 2
        DefaultRowHeight = 20
        FixedCols = 0
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = -1
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 1
        ColWidths = (
          151
          60)
      end
    end
    object SocketConsolePage: TTabSheet
      Caption = #1050#1086#1085#1089#1086#1083#1100' '#1086#1073#1074#1103#1079#1082#1080
      ImageIndex = 1
      object SocketConsole: TMemo
        Left = 0
        Top = 1
        Width = 703
        Height = 502
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        OnChange = SocketConsoleChange
      end
      object ShowDeauthMessages: TCheckBox
        Left = 6
        Top = 508
        Width = 232
        Height = 17
        Caption = #1042#1099#1074#1086#1076#1080#1090#1100' '#1089#1086#1086#1073#1097#1077#1085#1080#1103' '#1086' '#1076#1077#1072#1074#1090#1086#1088#1080#1079#1072#1094#1080#1080
        TabOrder = 1
      end
      object ShowBeaconMessages: TCheckBox
        Left = 248
        Top = 508
        Width = 171
        Height = 17
        Caption = #1042#1099#1074#1086#1076#1080#1090#1100' '#1089#1086#1086#1073#1097#1077#1085#1080#1103' '#1084#1072#1103#1095#1082#1072
        TabOrder = 2
      end
      object ShowPluginMessages: TCheckBox
        Left = 444
        Top = 508
        Width = 217
        Height = 17
        Caption = #1042#1099#1074#1086#1076#1080#1090#1100' '#1089#1086#1086#1073#1097#1077#1085#1080#1103' '#1087#1083#1072#1075#1080#1085#1072
        TabOrder = 3
      end
    end
    object ServerConsolePage: TTabSheet
      Caption = #1050#1086#1085#1089#1086#1083#1100' '#1089#1077#1088#1074#1077#1088#1072
      ImageIndex = 2
      object ServerConsole: TMemo
        Left = 0
        Top = 1
        Width = 703
        Height = 505
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 4276545
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        OnChange = ServerConsoleChange
      end
      object CommandEdit: TEdit
        Left = 0
        Top = 504
        Width = 601
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = -1
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnKeyDown = CommandEditKeyDown
      end
      object SendCommandButton: TButton
        Left = 600
        Top = 503
        Width = 104
        Height = 26
        Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
        TabOrder = 2
        OnClick = SendCommandButtonClick
      end
    end
  end
  object ServerSocket: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnClientRead = ServerSocketClientRead
    OnClientError = ServerSocketClientError
    Left = 701
  end
  object PopupMenu: TPopupMenu
    Left = 665
    object Kick: TMenuItem
      Caption = #1042#1099#1082#1080#1085#1091#1090#1100' '#1089' '#1089#1077#1088#1074#1077#1088#1072
      OnClick = KickClick
    end
    object Ban: TMenuItem
      Caption = #1047#1072#1073#1072#1085#1080#1090#1100
      OnClick = BanClick
    end
    object Unban: TMenuItem
      Caption = #1056#1072#1079#1073#1072#1085#1080#1090#1100
      OnClick = UnbanClick
    end
    object BanIP: TMenuItem
      Caption = #1047#1072#1073#1072#1085#1080#1090#1100' '#1087#1086' IP'
      OnClick = BanIPClick
    end
    object UnbanIP: TMenuItem
      Caption = #1056#1072#1079#1073#1072#1085#1080#1090#1100' '#1087#1086' IP'
      OnClick = UnbanIPClick
    end
    object HWIDBan: TMenuItem
      Caption = #1047#1072#1073#1072#1085#1080#1090#1100' '#1087#1086' HWID'
      OnClick = HWIDBanClick
    end
    object AddWhitelist: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1073#1077#1083#1099#1081' '#1089#1087#1080#1089#1086#1082
      OnClick = AddWhitelistClick
    end
    object RemoveWhitelist: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1080#1079' '#1073#1077#1083#1086#1075#1086' '#1089#1087#1080#1089#1082#1072
      OnClick = RemoveWhitelistClick
    end
    object AddAuthList: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1086#1095#1077#1088#1077#1076#1100' '#1085#1072' '#1072#1074#1090#1086#1088#1080#1079#1072#1094#1080#1102
      OnClick = AddAuthListClick
    end
    object AddAuthListWithoutTimer: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1086#1095#1077#1088#1077#1076#1100' '#1085#1072' '#1072#1074#1090#1086#1088#1080#1079#1072#1094#1080#1102' '#1073#1077#1089#1089#1088#1086#1095#1085#1086
      OnClick = AddAuthListWithoutTimerClick
    end
    object RemoveAuthList: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1080#1079' '#1086#1095#1077#1088#1077#1076#1080' '#1085#1072' '#1072#1074#1090#1086#1088#1080#1079#1072#1094#1080#1102
      OnClick = RemoveAuthListClick
    end
    object AddOperator: TMenuItem
      Caption = #1057#1076#1077#1083#1072#1090#1100' '#1086#1087#1077#1088#1072#1090#1086#1088#1086#1084
      OnClick = AddOperatorClick
    end
    object RemoveOperator: TMenuItem
      Caption = #1057#1085#1103#1090#1100' '#1087#1086#1083#1085#1086#1084#1086#1095#1080#1103' '#1086#1087#1077#1088#1072#1090#1086#1088#1072
      OnClick = RemoveOperatorClick
    end
  end
end
