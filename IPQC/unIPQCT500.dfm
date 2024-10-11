inherited FrmIPQCT500: TFrmIPQCT500
  Caption = 'FrmIPQCT500'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnl: TPanel
    Width = 853
    inherited PCL2: TPageControl
      Width = 853
      inherited TabSheet2: TTabSheet
        inherited DBGridEh2: TDBGridEh
          Width = 845
          Columns = <
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'pno'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'stkplace'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'stkarea'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'lot'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'qty'
              Footers = <>
            end>
        end
      end
    end
    inherited PCL: TPageControl
      Width = 853
      inherited TabSheet1: TTabSheet
        inherited DBGridEh1: TDBGridEh
          Width = 845
          OnEditButtonClick = DBGridEh1EditButtonClick
          Columns = <
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'sdate'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'fiber'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'breadth'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'vendor'
              Footers = <>
            end
            item
              ButtonStyle = cbsEllipsis
              DynProps = <>
              EditButtons = <>
              FieldName = 'pno'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'qty'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'cno'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'conf'
              Footers = <>
            end>
        end
      end
    end
  end
  object PnlRight: TPanel [4]
    Left = 853
    Top = 44
    Width = 110
    Height = 451
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object btn_ipqc500A: TBitBtn
      Tag = 2
      Left = 10
      Top = 10
      Width = 90
      Height = 25
      Hint = #35336#31639#25351#23450#26576#22825'PP'#25490#31243#30340#29627#24067#38656#27714#37327','#32080#26524#36820#22238#21040#20316#26989#20013
      Caption = #20633#26009#35336#31639
      TabOrder = 2
      OnClick = btn_ipqc500AClick
      NumGlyphs = 2
    end
    object btn_ipqc500B: TBitBtn
      Left = 10
      Top = 40
      Width = 90
      Height = 25
      Hint = #32113#35336#26085#26399#33539#22285#20839'PP'#25490#31243#30340#29627#24067#38656#27714#37327
      Caption = #20633#26009#20998#26512
      TabOrder = 0
      OnClick = btn_ipqc500BClick
      NumGlyphs = 2
    end
    object btn_ipqc500C: TBitBtn
      Left = 10
      Top = 70
      Width = 90
      Height = 25
      Hint = #39023#31034#32233#27798#22666#23565#25033#30340#25490#31243#36039#26009
      Caption = #25490#31243#36039#26009
      TabOrder = 1
      OnClick = btn_ipqc500CClick
      NumGlyphs = 2
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 744
    Top = 8
  end
end
