inherited FrmMPSR060: TFrmMPSR060
  Caption = 'FrmMPSR060'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PCL: TPageControl
    inherited TabSheet1: TTabSheet
      inherited DBGridEh1: TDBGridEh
        FooterRowCount = 1
        SumList.Active = True
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Sdate'
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
            FieldName = 'L1'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'L2'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'L3'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'L4'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'L5'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'L6'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Tot'
            Footer.ValueType = fvtSum
            Footers = <>
          end>
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object DBGridEh2: TDBGridEh
        Left = 0
        Top = 0
        Width = 955
        Height = 423
        Align = alClient
        DataSource = DS2
        DynProps = <>
        FooterRowCount = 1
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        ReadOnly = True
        SumList.Active = True
        TabOrder = 0
        OnColWidthsChanged = DBGridEh1ColWidthsChanged
        OnMouseDown = DBGridEh1MouseDown
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Sdate'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'L1'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'L2'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'L3'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'L4'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'L5'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'L6'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Tot'
            Footer.ValueType = fvtSum
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
    Left = 501
    Top = 205
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 529
    Top = 205
  end
end
