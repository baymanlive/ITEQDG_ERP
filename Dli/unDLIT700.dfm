inherited FrmDLIT700: TFrmDLIT700
  Caption = 'FrmDLIT700'
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel [0]
    Left = 134
    Top = 73
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label3'
  end
  object Label5: TLabel [1]
    Left = 134
    Top = 113
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label3'
  end
  object Label6: TLabel [2]
    Left = 134
    Top = 154
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label3'
  end
  object Label7: TLabel [3]
    Left = 134
    Top = 194
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
  object Edit3: TEdit [6]
    Left = 170
    Top = 70
    Width = 100
    Height = 21
    TabOrder = 2
  end
  object Edit6: TEdit [7]
    Left = 170
    Top = 150
    Width = 100
    Height = 21
    TabOrder = 3
    Text = '1'
  end
  object Edit7: TEdit [8]
    Left = 170
    Top = 190
    Width = 100
    Height = 21
    TabOrder = 4
    Text = '200'
  end
  object Edit5: TEdit [9]
    Left = 170
    Top = 110
    Width = 100
    Height = 21
    TabOrder = 5
  end
  object PnlBottom: TPanel [10]
    Left = 0
    Top = 492
    Width = 954
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 6
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
end
