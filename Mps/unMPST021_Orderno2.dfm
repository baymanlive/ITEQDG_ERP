inherited FrmMPST021_Orderno2: TFrmMPST021_Orderno2
  Width = 430
  Height = 400
  Caption = #22238#23531#20841#35282#35330#21934
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 304
    Height = 362
  end
  inherited PCL: TPageControl
    Width = 304
    Height = 362
    inherited TabSheet1: TTabSheet
      object lblorderdate: TLabel
        Left = 54
        Top = 77
        Width = 56
        Height = 13
        Alignment = taRightJustify
        Caption = 'lblorderdate'
      end
      object Dtp1: TDateTimePicker
        Left = 114
        Top = 74
        Width = 100
        Height = 21
        Date = 42138.392057303240000000
        Time = 42138.392057303240000000
        TabOrder = 0
      end
      object RadioGroup1: TRadioGroup
        Left = 56
        Top = 112
        Width = 157
        Height = 49
        Caption = #32218#21029
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'T1~T5'
          'T6~T8')
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
