inherited FrmDLII020_prnmark: TFrmDLII020_prnmark
  Width = 530
  Height = 370
  Caption = #30064#24120#21015#21360#35498#26126
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 404
    Height = 332
  end
  inherited PCL: TPageControl
    Width = 404
    Height = 332
    inherited TabSheet1: TTabSheet
      Caption = #21015#21360#35498#26126
      DesignSize = (
        396
        304)
      object RichEdit1: TRichEdit
        Left = 155
        Top = 4
        Width = 238
        Height = 296
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = CHINESEBIG5_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #26032#32048#26126#39636
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object RadioGroup1: TRadioGroup
        Left = 4
        Top = 4
        Width = 145
        Height = 205
        Caption = #21407#22240
        ItemIndex = 6
        Items.Strings = (
          #20633#35387#26377#35492#37325#21360
          #25913#21934
          #25214#19981#21040#21934
          #40670#37679
          #21345#32025
          #32025#24373#36305#26684#24335
          #20854#23427)
        TabOrder = 0
        OnClick = RadioGroup1Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = #20840#37096#35498#26126
      ImageIndex = 1
      DesignSize = (
        396
        304)
      object RichEdit2: TRichEdit
        Left = 4
        Top = 4
        Width = 390
        Height = 296
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = CHINESEBIG5_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #26032#32048#26126#39636
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
end
