inherited FrmMPSR160: TFrmMPSR160
  Caption = 'FrmMPSR160'
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited PCL: TPageControl
    inherited TabSheet1: TTabSheet
      Caption = #32317#34920
      inherited DBGridEh1: TDBGridEh
        Columns = <
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
            FieldName = 'sno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'cnt'
            Footers = <>
          end>
      end
    end
    object TabSheet2: TTabSheet
      Caption = #26126#32048#34920
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
        OnColWidthsChanged = DBGridEh2ColWidthsChanged
        OnMouseDown = DBGridEh2MouseDown
        Columns = <
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
            FieldName = 'sno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'cnt'
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
            FieldName = 'sqty'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'premark'
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
