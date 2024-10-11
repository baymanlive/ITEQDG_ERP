inherited FrmMPST090: TFrmMPST090
  Left = 280
  Top = 98
  Caption = 'FrmMPST090'
  ClientHeight = 657
  ClientWidth = 1214
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 1214
    ButtonWidth = 72
    object btn_mpst090: TToolButton
      Left = 364
      Top = 0
      Caption = #29986#29983#35531#36092#21934
      ImageIndex = 50
      OnClick = btn_mpst090Click
    end
    object btn_mpst090_export: TToolButton
      Left = 436
      Top = 0
      Caption = #23566#20986#25490#31243
      ImageIndex = 56
      OnClick = btn_mpst090_exportClick
    end
    object ToolButton1: TToolButton
      Left = 508
      Top = 0
      Caption = 'ToolButton1'
      ImageIndex = 57
    end
  end
  inherited PnlBottom: TPanel
    Top = 627
    Width = 1214
  end
  inherited Panel1: TPanel
    Width = 1214
  end
  inherited PCL: TPageControl
    Width = 1214
    Height = 583
    inherited TabSheet1: TTabSheet
      Caption = 'CCL'#25490#31243#36039#26009
      inherited DBGridEh1: TDBGridEh
        Width = 1206
        Height = 555
        OnCellClick = DBGridEh1CellClick
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'CheckBox'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'machine'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sdate'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Wono'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Orderno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'OrderItem'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Materialno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderqty'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Sqty'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Stealno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Premark'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Custno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Custom'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Materialno1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'PnlSize1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'PnlSize2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Orderno2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'OrderItem2'
            Footers = <>
          end
          item
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            FieldName = 'iscreate'
            Footers = <>
          end
          item
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            FieldName = 'isdomestic'
            Footers = <>
          end
          item
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            FieldName = 'isdg'
            Footers = <>
          end>
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'PP'#25490#31243#36039#26009
      ImageIndex = 1
      object DBGridEh2: TDBGridEh
        Left = 0
        Top = 0
        Width = 1206
        Height = 555
        Align = alClient
        DataSource = DS2
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        ReadOnly = True
        TabOrder = 0
        OnCellClick = DBGridEh2CellClick
        OnColWidthsChanged = DBGridEh2ColWidthsChanged
        OnMouseDown = DBGridEh2MouseDown
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'CheckBox'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'machine'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sdate'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Wono'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Orderno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'OrderItem'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Materialno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderqty'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Sqty'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Breadth'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Fiber'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Premark'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Custno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Custom'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Materialno1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'PnlSize1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'PnlSize2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Orderno2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'OrderItem2'
            Footers = <>
          end
          item
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            FieldName = 'iscreate'
            Footers = <>
          end
          item
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            FieldName = 'isdomestic'
            Footers = <>
          end
          item
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            FieldName = 'isdg'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 777
    Top = 405
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 806
    Top = 405
  end
end
