inherited FrmDLIT802: TFrmDLIT802
  Caption = 'FrmDLIT802'
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel [0]
    Left = 30
    Top = 80
    Width = 65
    Height = 13
    Caption = #36865#36008#21934#34399#30908
  end
  object Label4: TLabel [1]
    Left = 280
    Top = 80
    Width = 26
    Height = 13
    Caption = #20786#20301
  end
  object Label5: TLabel [2]
    Left = 542
    Top = 80
    Width = 38
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label5'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = #26032#32048#26126#39636
    Font.Style = [fsBold]
    ParentFont = False
  end
  inherited ToolBar: TToolBar
    object btn_conf: TToolButton
      Left = 182
      Top = 0
      AutoSize = True
      Caption = #30906#35469
      ImageIndex = 60
      OnClick = btn_confClick
    end
  end
  object Edit3: TEdit [5]
    Left = 30
    Top = 100
    Width = 200
    Height = 21
    TabOrder = 2
  end
  object PnlBottom: TPanel [6]
    Left = 0
    Top = 491
    Width = 954
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 3
    object lblrecored: TLabel
      Tag = 1
      Left = 43
      Top = 8
      Width = 26
      Height = 13
      Caption = #31558#25976
    end
    object Bevel1: TBevel
      Left = 8
      Top = 14
      Width = 30
      Height = 10
      Shape = bsTopLine
    end
    object Bevel2: TBevel
      Left = 213
      Top = 14
      Width = 30
      Height = 10
      Shape = bsTopLine
    end
    object lblsp: TLabel
      Tag = 1
      Left = 138
      Top = 8
      Width = 3
      Height = 13
      Caption = '/'
    end
    object Edit1: TEdit
      Left = 73
      Top = 4
      Width = 60
      Height = 21
      TabStop = False
      ParentColor = True
      TabOrder = 0
      Text = '0'
    end
    object Edit2: TEdit
      Left = 148
      Top = 4
      Width = 60
      Height = 21
      TabStop = False
      ParentColor = True
      TabOrder = 1
      Text = '0'
    end
  end
  object Memo1: TMemo [7]
    Left = 280
    Top = 100
    Width = 300
    Height = 300
    Lines.Strings = (
      #20786#20301#30456#21516
      #21487#20197#21482#36664#20837#19968#20491
      ''
      #20786#20301#19981#21516
      #36865#36008#21934#27599#38917#37117#24517#38656#36664#20837
      ''
      #19968#38917#25286#20998#22810#20491#20786#20301#26178','#26684#24335':'
      #20786#20301','#25976#37327','#20786#20301','#25976#37327',......')
    TabOrder = 4
    OnChange = Memo1Change
  end
end
