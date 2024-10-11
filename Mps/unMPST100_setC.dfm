inherited FrmMPST100_setC: TFrmMPST100_setC
  Left = 450
  Top = 111
  Caption = 'FrmMPST100_setC'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlBottom: TPanel
    object lblMPST100_setCmsg: TLabel [4]
      Tag = 1
      Left = 260
      Top = 8
      Width = 129
      Height = 13
      Caption = #25563#34892#35531#20351#29992'"|"'#31526#34399#38291#38548
    end
  end
  inherited DBGridEh1: TDBGridEh
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'oz'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'mil_l'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'mil_h'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'value'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'img1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'img2'
        Footers = <>
      end>
  end
  inherited CDS: TClientDataSet
    BeforePost = CDSBeforePost
  end
end
