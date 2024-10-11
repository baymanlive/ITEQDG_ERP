inherited FrmDLIT800: TFrmDLIT800
  Caption = 'FrmDLIT800'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    inherited btn_print: TToolButton
      OnClick = btn_printClick
    end
  end
  object PnlBottom: TPanel [2]
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
  object Tab: TTabControl [3]
    Left = 70
    Top = 80
    Width = 500
    Height = 300
    TabOrder = 3
    Tabs.Strings = (
      '0'
      '1')
    TabIndex = 0
    OnChange = TabChange
    object Label6: TLabel
      Left = 46
      Top = 163
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 'Label6'
    end
    object Label5: TLabel
      Left = 46
      Top = 123
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 'Label5'
    end
    object Label4: TLabel
      Left = 262
      Top = 85
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 'Label4'
    end
    object Label3: TLabel
      Left = 46
      Top = 83
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 'Label3'
    end
    object Edit3: TEdit
      Left = 82
      Top = 80
      Width = 150
      Height = 21
      TabOrder = 0
    end
    object Edit6: TEdit
      Left = 82
      Top = 160
      Width = 150
      Height = 21
      TabOrder = 3
    end
    object Edit5: TEdit
      Left = 82
      Top = 120
      Width = 150
      Height = 21
      TabOrder = 2
    end
    object Edit4: TEdit
      Left = 298
      Top = 82
      Width = 150
      Height = 21
      TabOrder = 1
    end
  end
end
