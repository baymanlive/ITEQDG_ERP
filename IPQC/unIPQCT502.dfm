inherited FrmIPQCT502: TFrmIPQCT502
  Left = 336
  Top = 109
  Caption = 'FrmIPQCT502'
  ClientHeight = 744
  ClientWidth = 1706
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 1706
    ButtonWidth = 60
    object btn_import: TToolButton
      Left = 594
      Top = 0
      Caption = 'btn_import'
      ImageIndex = 53
      OnClick = btn_importClick
    end
  end
  inherited PnlBottom: TPanel
    Top = 714
    Width = 1706
  end
  inherited Panel1: TPanel
    Width = 1706
  end
  inherited DBGridEh1: TDBGridEh
    Width = 1706
    Height = 670
    Options = [dgEditing, dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize]
    OnDblClick = DBGridEh1DblClick
    OnGetCellParams = DBGridEh1GetCellParams
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'fdate'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ad'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sizes'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rc'
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
        FieldName = 'lvalue1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'mvalue1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rvalue1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'lvalue2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'mvalue2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rvalue2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'lvalue3'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'mvalue3'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rvalue3'
        Footers = <>
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'vc'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'std'
        Footers = <>
        ReadOnly = True
      end
      item
        Alignment = taCenter
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'ret'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'iuser'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'iname'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'idate'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'muser'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'mname'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'mdate'
        Footers = <>
        ReadOnly = True
      end>
  end
  inherited CDS: TClientDataSet
    AfterOpen = CDSAfterOpen
  end
end
