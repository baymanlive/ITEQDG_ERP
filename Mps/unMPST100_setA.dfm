inherited FrmMPST100_setA: TFrmMPST100_setA
  Left = 492
  Top = 97
  Width = 954
  Height = 600
  Caption = 'FrmMPST100_setA'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 946
  end
  inherited PnlBottom: TPanel
    Top = 543
    Width = 946
    object lblMPST100_setAmsg: TLabel [4]
      Tag = 1
      Left = 260
      Top = 8
      Width = 129
      Height = 13
      Caption = #25563#34892#35531#20351#29992'"|"'#31526#34399#38291#38548
    end
  end
  inherited Panel1: TPanel
    Width = 946
  end
  inherited DBGridEh1: TDBGridEh
    Width = 946
    Height = 499
    IncludeImageModules = [iimJpegImageModuleEh]
    DrawGraphicData = True
    RowHeight = 120
    RowSizingAllowed = True
    TitleParams.MultiTitle = True
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
        FieldName = 'value'
        Footers = <>
        Width = 89
      end
      item
        ButtonStyle = cbsEllipsis
        DynProps = <>
        EditButtons = <>
        FieldName = 'img'
        Footers = <>
        Width = 229
        OnEditButtonClick = DBGridEh1Columns2EditButtonClick
      end
      item
        ButtonStyle = cbsEllipsis
        DynProps = <>
        EditButtons = <>
        FieldName = 'img2'
        Footers = <>
        Width = 209
        OnEditButtonClick = DBGridEh1Columns2EditButtonClick
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'value2'
        Footers = <>
      end
      item
        ButtonStyle = cbsEllipsis
        DynProps = <>
        EditButtons = <>
        FieldName = 'img3'
        Footers = <>
        OnEditButtonClick = DBGridEh1Columns2EditButtonClick
      end
      item
        ButtonStyle = cbsEllipsis
        DynProps = <>
        EditButtons = <>
        FieldName = 'img4'
        Footers = <>
        OnEditButtonClick = DBGridEh1Columns2EditButtonClick
      end>
  end
  inherited CDS: TClientDataSet
    BeforePost = CDSBeforePost
  end
  object OpenDialog1: TOpenDialog
    Filter = #22294#29255'(*.jpg)|*.jpg'
    Left = 404
    Top = 148
  end
end
