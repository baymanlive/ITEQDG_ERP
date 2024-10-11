inherited FrmDLIT801: TFrmDLIT801
  Caption = 'FrmDLIT801'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    ButtonWidth = 61
    object btn_dlit801: TToolButton
      Left = 364
      Top = 0
      Caption = 'btn_dlit801'
      ImageIndex = 61
      OnClick = btn_dlit801Click
    end
  end
  inherited PCL: TPageControl
    Height = 231
    inherited TabSheet1: TTabSheet
      inherited DBGridEh1: TDBGridEh
        Height = 203
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'area'
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
            FieldName = 'lot'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'qty'
            Footers = <>
          end
          item
            Color = clCream
            DynProps = <>
            EditButtons = <>
            FieldName = 'img02'
            Footers = <>
          end
          item
            Color = clCream
            DynProps = <>
            EditButtons = <>
            FieldName = 'img03'
            Footers = <>
          end
          item
            Color = clCream
            DynProps = <>
            EditButtons = <>
            FieldName = 'img04'
            Footers = <>
          end
          item
            Color = clCream
            DynProps = <>
            EditButtons = <>
            FieldName = 'img10'
            Footers = <>
          end
          item
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            FieldName = 'result'
            Footers = <>
          end>
      end
    end
    object TabSheet200: TTabSheet
      Caption = 'TabSheet200'
      ImageIndex = 1
      object DBGridEh3: TDBGridEh
        Left = 0
        Top = 0
        Width = 955
        Height = 203
        Align = alClient
        DataSource = DS3
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
            FieldName = 'img01'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'img02'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'img03'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'img04'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'img10'
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
            FieldName = 'qty'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'diffqty'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object PCL2: TPageControl [4]
    Left = 0
    Top = 275
    Width = 963
    Height = 220
    ActivePage = TabSheet100
    Align = alBottom
    TabOrder = 4
    object TabSheet100: TTabSheet
      Caption = 'TabSheet100'
      object DBGridEh2: TDBGridEh
        Left = 0
        Top = 0
        Width = 955
        Height = 192
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
            FieldName = 'area'
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
            FieldName = 'lot'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'qty'
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
    Left = 777
    Top = 409
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 806
    Top = 409
  end
  object DS3: TDataSource
    DataSet = CDS3
    Left = 806
    Top = 441
  end
  object CDS3: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 777
    Top = 441
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 720
    Top = 4
  end
end
