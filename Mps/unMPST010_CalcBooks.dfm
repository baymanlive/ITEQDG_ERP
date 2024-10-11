inherited FrmClacBooks: TFrmClacBooks
  Left = 454
  Top = 275
  Width = 846
  Height = 509
  Caption = #35336#31639#25351#23450#26085#26399#21508#37707#26412#25976
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 728
    Height = 478
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 241
    Height = 478
    Align = alLeft
    TabOrder = 1
    object Label1: TLabel
      Left = 47
      Top = 25
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = #27231#21488#65306
    end
    object Label2: TLabel
      Left = 21
      Top = 53
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = #29983#29986#26085#26399#65306
    end
    object Cbb: TComboBox
      Left = 90
      Top = 20
      Width = 120
      Height = 21
      Hint = #35531#36984#25799#27231#21488
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object Dtp1: TDateTimePicker
      Left = 90
      Top = 50
      Width = 120
      Height = 21
      Hint = #35531#36984#25799#26085#26399
      Date = 42108.000000000000000000
      Time = 42108.000000000000000000
      TabOrder = 1
    end
  end
  object Panel2: TPanel [2]
    Left = 241
    Top = 0
    Width = 487
    Height = 478
    Align = alClient
    BorderWidth = 4
    TabOrder = 2
    object PageControl1: TPageControl
      Left = 5
      Top = 5
      Width = 477
      Height = 468
      Align = alClient
      TabOrder = 0
    end
  end
end
