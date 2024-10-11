inherited FrmDLII431: TFrmDLII431
  Caption = 'FrmDLII431'
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel [0]
    Left = 86
    Top = 93
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label3'
  end
  inherited ToolBar: TToolBar
    inherited btn_print: TToolButton
      OnClick = btn_printClick
    end
  end
  object PnlBottom: TPanel [3]
    Left = 0
    Top = 491
    Width = 954
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 2
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
  object Edit3: TEdit [4]
    Left = 122
    Top = 90
    Width = 100
    Height = 21
    TabOrder = 3
  end
  object rgp: TRadioGroup [5]
    Left = 58
    Top = 125
    Width = 180
    Height = 40
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      'DG'
      'GZ'
      'HJ')
    TabOrder = 4
  end
end
