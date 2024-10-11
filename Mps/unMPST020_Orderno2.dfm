inherited FrmMPST020_Orderno2: TFrmMPST020_Orderno2
  Width = 430
  Height = 400
  Caption = #22238#23531#20841#35282#35330#21934
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 312
    Height = 371
  end
  inherited PCL: TPageControl
    Width = 312
    Height = 371
    inherited TabSheet1: TTabSheet
      object lblorderdate: TLabel
        Left = 78
        Top = 53
        Width = 56
        Height = 13
        Alignment = taRightJustify
        Caption = 'lblorderdate'
      end
      object Dtp1: TDateTimePicker
        Left = 138
        Top = 50
        Width = 100
        Height = 21
        Date = 42138.392057303240000000
        Time = 42138.392057303240000000
        TabOrder = 0
      end
      object RadioGroup1: TRadioGroup
        Left = 80
        Top = 88
        Width = 157
        Height = 49
        Caption = #32218#21029
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'L1~L5'
          'L6')
        TabOrder = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = #20841#35282#35330#21934
      ImageIndex = 1
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 266
        Height = 334
        Align = alClient
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
end
