inherited FrmMPST100_setF: TFrmMPST100_setF
  Left = 438
  Top = 229
  Width = 846
  Height = 600
  Caption = 'FrmMPST100_setF'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 838
  end
  inherited PnlBottom: TPanel
    Top = 543
    Width = 838
    object lblMPST100_setFmsg: TLabel [4]
      Tag = 1
      Left = 260
      Top = 8
      Width = 129
      Height = 13
      Caption = #25563#34892#35531#20351#29992'"|"'#31526#34399#38291#38548
    end
  end
  inherited Panel1: TPanel
    Width = 838
  end
  inherited DBGridEh1: TDBGridEh
    Width = 838
    Height = 499
    IncludeImageModules = [iimJpegImageModuleEh]
    DrawGraphicData = True
    DrawMemoText = True
    OptionsEh = [dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    RowHeight = 100
    RowSizingAllowed = True
    TitleParams.MultiTitle = True
    OnEditButtonClick = DBGridEh1EditButtonClick
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custno'
        Footers = <>
        Width = 125
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'parentCustno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'hf'
        Footers = <>
      end
      item
        ButtonStyle = cbsEllipsis
        DynProps = <>
        EditButtons = <>
        FieldName = 'img1'
        Footers = <>
        Width = 126
        OnEditButtonClick = DBGridEh1Columns2EditButtonClick
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'content1'
        Footers = <>
        Width = 126
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
