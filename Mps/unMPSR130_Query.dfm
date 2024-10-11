inherited FrmMPSR130_Query: TFrmMPSR130_Query
  Width = 500
  Height = 320
  Caption = #26597#35426
  PixelsPerInch = 96
  TextHeight = 13
  object lblsdate: TLabel [0]
    Left = 80
    Top = 27
    Width = 36
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblsdate'
  end
  object lblto: TLabel [1]
    Tag = 1
    Left = 214
    Top = 28
    Width = 21
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblto'
  end
  object lblcustno: TLabel [2]
    Left = 73
    Top = 57
    Width = 43
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblcustno'
  end
  object lblorderno: TLabel [3]
    Left = 67
    Top = 87
    Width = 49
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblorderno'
  end
  object lblpno: TLabel [4]
    Left = 86
    Top = 117
    Width = 30
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblpno'
  end
  inherited PnlRight: TPanel
    Left = 374
    Height = 282
    TabOrder = 6
  end
  object Dtp1: TDateTimePicker [6]
    Left = 120
    Top = 24
    Width = 90
    Height = 21
    Date = 42921.000000000000000000
    Time = 42921.000000000000000000
    TabOrder = 0
  end
  object Dtp2: TDateTimePicker [7]
    Left = 240
    Top = 24
    Width = 90
    Height = 21
    Date = 42921.000000000000000000
    Time = 42921.000000000000000000
    TabOrder = 1
  end
  object Edit1: TEdit [8]
    Left = 120
    Top = 54
    Width = 210
    Height = 21
    TabOrder = 2
  end
  object Edit2: TEdit [9]
    Left = 120
    Top = 84
    Width = 210
    Height = 21
    TabOrder = 3
  end
  object Edit3: TEdit [10]
    Left = 120
    Top = 114
    Width = 210
    Height = 21
    TabOrder = 4
  end
  object GroupBox1: TGroupBox [11]
    Left = 120
    Top = 144
    Width = 209
    Height = 97
    TabOrder = 5
    object chk1: TCheckBox
      Left = 30
      Top = 15
      Width = 60
      Height = 17
      Caption = 'L1'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object chk2: TCheckBox
      Left = 120
      Top = 15
      Width = 60
      Height = 17
      Caption = 'L2'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object chk3: TCheckBox
      Left = 30
      Top = 40
      Width = 60
      Height = 17
      Caption = 'L3'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object chk4: TCheckBox
      Left = 120
      Top = 40
      Width = 60
      Height = 17
      Caption = 'L4'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object chk5: TCheckBox
      Left = 30
      Top = 65
      Width = 60
      Height = 17
      Caption = 'L5'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object chk6: TCheckBox
      Left = 120
      Top = 65
      Width = 60
      Height = 17
      Caption = 'L6'
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
  end
end
