inherited FrmDLIR230: TFrmDLIR230
  Left = 419
  Top = 243
  Caption = 'FrmDLIR230'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PCL: TPageControl
    inherited TabSheet1: TTabSheet
      inherited DBGridEh1: TDBGridEh
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'indate'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'c_lot'
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
            FieldName = 'c_orderno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'c_pno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'c_sizes'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'v0'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'v0_1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'v0_2'
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
            FieldName = 'v1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'v2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'v3'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'v4'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'v5'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'v6'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'v7'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'v8'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'v9'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'wono'
            Footers = <>
          end>
      end
    end
    object TabSheet20: TTabSheet
      Caption = 'TabSheet20'
      ImageIndex = 1
      object DBGridEh2: TDBGridEh
        Left = 0
        Top = 0
        Width = 955
        Height = 423
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
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'c_orderno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'indate'
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
            FieldName = 'c_lot'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'c_pno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'c_sizes'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'rc0'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'rc0_1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'rc0_2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'rc1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'rc2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'rc3'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'rc4'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'rc5'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'rc6'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'wono'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'qty'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 866
    Top = 377
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 837
    Top = 377
  end
end
