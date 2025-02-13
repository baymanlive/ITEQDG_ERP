inherited FrmMPST100_setE: TFrmMPST100_setE
  Left = 434
  Top = 313
  Width = 846
  Height = 600
  Caption = 'FrmMPST100_setE'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 830
  end
  inherited PnlBottom: TPanel
    Top = 532
    Width = 830
    object lblMPST100_setEmsg: TLabel [4]
      Tag = 1
      Left = 260
      Top = 8
      Width = 129
      Height = 13
      Caption = #25563#34892#35531#20351#29992'"|"'#31526#34399#38291#38548
    end
  end
  inherited Panel1: TPanel
    Width = 830
  end
  inherited DBGridEh1: TDBGridEh
    Width = 830
    Height = 488
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
        FieldName = 's2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 's36_min'
        Footers = <>
        Width = 78
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 's36_max'
        Footers = <>
        Width = 78
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 's7'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 's8'
        Footers = <>
        Visible = False
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 's78'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'degree'
        Footers = <>
        Width = 95
      end
      item
        ButtonStyle = cbsEllipsis
        DynProps = <>
        EditButtons = <>
        FieldName = 'img1'
        Footers = <>
        Width = 126
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'content1'
        Footers = <>
        Width = 126
      end
      item
        ButtonStyle = cbsEllipsis
        DynProps = <>
        EditButtons = <>
        FieldName = 'img2'
        Footers = <>
        Width = 126
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'content2'
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
