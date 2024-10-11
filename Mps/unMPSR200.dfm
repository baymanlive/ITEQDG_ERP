inherited FrmMPSR200: TFrmMPSR200
  Caption = 'FrmMPSR200'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PCL: TPageControl
    inherited TabSheet1: TTabSheet
      inherited DBGridEh1: TDBGridEh
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'qdate'
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
            FieldName = 'machine'
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
            FieldName = 'pno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sqty'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ordqty1'
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
            FieldName = 'custom'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'tc_sid110'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'depot'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'area'
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
            FieldName = 'ta_img05'
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
            FieldName = 'ordqty2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'remark'
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
            FieldName = 'qdate'
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
            FieldName = 'machine'
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
            FieldName = 'pno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sqty'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ordqty1'
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
            FieldName = 'custom'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'tc_sid110'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'depot'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'area'
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
            FieldName = 'ta_img05'
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
            FieldName = 'ordqty2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'remark'
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
