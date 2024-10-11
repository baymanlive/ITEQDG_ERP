inherited FrmDLIR030: TFrmDLIR030
  Caption = 'FrmDLIR030'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PCL: TPageControl
    Height = 231
    inherited TabSheet1: TTabSheet
      inherited DBGridEh1: TDBGridEh
        Height = 203
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Indate'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custshort'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderitem'
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
            FieldName = 'pname'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Sizes'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ordercount'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'notcount'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'delcount'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'jcount_old'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'jcount_new'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'bcount'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Units'
            Footers = <>
          end>
      end
    end
  end
  object PCL2: TPageControl [4]
    Left = 0
    Top = 275
    Width = 963
    Height = 220
    ActivePage = TabSheet_lot
    Align = alBottom
    TabOrder = 4
    object TabSheet_lot: TTabSheet
      Caption = 'TabSheet_lot'
      object DBGridEh2: TDBGridEh
        Left = 0
        Top = 0
        Width = 955
        Height = 192
        Align = alClient
        DataSource = DS2
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        TabOrder = 0
        OnGetCellParams = DBGridEh2GetCellParams
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'stkplace'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'stkarea'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'manfac'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'stkqty'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'qty'
            Footers = <>
            ReadOnly = True
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
    Top = 409
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 806
    Top = 409
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 544
    Top = 8
  end
end
