inherited FrmMPST100_setD: TFrmMPST100_setD
  Left = 548
  Top = 276
  Width = 700
  Height = 600
  Caption = 'FrmMPST100_setD'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 692
  end
  inherited PnlBottom: TPanel
    Top = 543
    Width = 692
    object lblMPST100_setDmsg: TLabel [4]
      Tag = 1
      Left = 260
      Top = 8
      Width = 129
      Height = 13
      Caption = #25563#34892#35531#20351#29992'"|"'#31526#34399#38291#38548
    end
  end
  inherited Panel1: TPanel
    Width = 692
  end
  inherited DBGridEh1: TDBGridEh
    Width = 692
    Height = 499
    IncludeImageModules = [iimJpegImageModuleEh]
    DrawGraphicData = True
    DrawMemoText = True
    OptionsEh = [dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    RowHeight = 100
    RowSizingAllowed = True
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
      end
      item
        ButtonStyle = cbsEllipsis
        DynProps = <>
        EditButtons = <>
        FieldName = 'Img'
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
