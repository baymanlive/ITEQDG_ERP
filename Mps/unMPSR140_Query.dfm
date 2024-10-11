inherited FrmMPSR140_Query: TFrmMPSR140_Query
  Width = 480
  Height = 290
  Caption = #26597#35426
  PixelsPerInch = 96
  TextHeight = 13
  object lblorderdate: TLabel [0]
    Left = 32
    Top = 28
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblorderdate'
  end
  object lblto: TLabel [1]
    Tag = 1
    Left = 174
    Top = 30
    Width = 21
    Height = 13
    Alignment = taCenter
    Caption = 'lblto'
  end
  object Label1: TLabel [2]
    Left = 56
    Top = 58
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object Label2: TLabel [3]
    Left = 56
    Top = 88
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object btn_sp: TSpeedButton [4]
    Left = 288
    Top = 54
    Width = 23
    Height = 22
    Caption = '...'
    OnClick = btn_spClick
  end
  object btn_sp1: TSpeedButton [5]
    Left = 288
    Top = 84
    Width = 23
    Height = 22
    Caption = '...'
    OnClick = btn_sp1Click
  end
  inherited PnlRight: TPanel
    Left = 354
    Height = 252
    TabOrder = 6
  end
  object dtp1: TDateTimePicker [7]
    Left = 92
    Top = 25
    Width = 80
    Height = 21
    Date = 43160.000000000000000000
    Time = 43160.000000000000000000
    TabOrder = 0
  end
  object dtp2: TDateTimePicker [8]
    Left = 210
    Top = 27
    Width = 80
    Height = 21
    Date = 43160.000000000000000000
    Time = 43160.000000000000000000
    TabOrder = 1
  end
  object rgp1: TRadioGroup [9]
    Left = 60
    Top = 120
    Width = 225
    Height = 42
    Columns = 3
    ItemIndex = 2
    Items.Strings = (
      'CCL'
      'PP'
      'ALL')
    TabOrder = 4
  end
  object Edit1: TEdit [10]
    Left = 92
    Top = 55
    Width = 195
    Height = 21
    TabOrder = 2
  end
  object Edit2: TEdit [11]
    Left = 92
    Top = 85
    Width = 195
    Height = 21
    TabOrder = 3
  end
  object rgp2: TRadioGroup [12]
    Left = 60
    Top = 168
    Width = 225
    Height = 42
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'ITEQDG'
      'ITEQGZ')
    TabOrder = 5
  end
end
