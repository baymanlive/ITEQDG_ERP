inherited FrmMPST012_adate_qty: TFrmMPST012_adate_qty
  Left = 192
  Top = 142
  Width = 800
  Height = 500
  Caption = #36948#20132#26085#26399#25976#37327#32113#35336#34920
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 674
    Height = 461
  end
  inherited PCL: TPageControl
    Width = 674
    Height = 461
    inherited TabSheet1: TTabSheet
      object DBGridEh1: TDBGridEh
        Left = 0
        Top = 0
        Width = 666
        Height = 433
        Align = alClient
        DataSource = DS
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
            FieldName = 'adate'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sqty'
            Footer.ValueType = fvtSum
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object DBGridEh2: TDBGridEh
        Left = 0
        Top = 0
        Width = 666
        Height = 433
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
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            FieldName = 'm'
            Footers = <>
          end
          item
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            FieldName = 'd'
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
            FieldName = 'sqty'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'maxqty'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
      object DBGridEh3: TDBGridEh
        Left = 0
        Top = 0
        Width = 666
        Height = 433
        Align = alClient
        DataSource = DS3
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
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            FieldName = 'm'
            Footers = <>
          end
          item
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            FieldName = 'd'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'groupid'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sqty'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'maxqty'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 104
    Top = 248
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 132
    Top = 248
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 164
    Top = 248
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 192
    Top = 248
  end
  object CDS3: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 224
    Top = 248
  end
  object DS3: TDataSource
    DataSet = CDS3
    Left = 252
    Top = 248
  end
end
