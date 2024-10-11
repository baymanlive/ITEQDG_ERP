inherited FrmDLIR201: TFrmDLIR201
  Caption = 'FrmDLIR201'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PCL: TPageControl
    inherited TabSheet1: TTabSheet
      inherited DBGridEh1: TDBGridEh
        ReadOnly = False
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sno'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'indate'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'cno'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'company'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'carno'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'driver'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pathname'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'mileage'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'customcnt'
            Footers = <>
            ReadOnly = True
          end
          item
            Color = clInfoBk
            DynProps = <>
            EditButtons = <>
            FieldName = 'outtime'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ton'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'slot'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'slotcnt'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'slotper'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'kbcnt'
            Footers = <>
            ReadOnly = True
          end
          item
            Color = clInfoBk
            DynProps = <>
            EditButtons = <>
            FieldName = 'totkg'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'maxkg'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'kgper'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ppkbcnt'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'cclkbcnt'
            Footers = <>
            ReadOnly = True
          end
          item
            Color = clInfoBk
            DynProps = <>
            EditButtons = <>
            FieldName = 'remark'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custno'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custshort'
            Footers = <>
            ReadOnly = True
          end
          item
            Color = clInfoBk
            DynProps = <>
            EditButtons = <>
            FieldName = 'remark_jiaokb'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'jiaokbcnt'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'saleno'
            Footers = <>
            ReadOnly = True
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
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        ReadOnly = True
        TabOrder = 0
        OnGetCellParams = DBGridEh2GetCellParams
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'title'
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
            FieldName = 'kg1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'kg2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'kgper'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'kb'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'slot1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'slot2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'slotper'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'cntper'
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
        Width = 955
        Height = 423
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
        OnGetCellParams = DBGridEh3GetCellParams
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'title'
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
            FieldName = 'kg1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'kg2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'kgper'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'kb'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'slot1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'slot2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'slotper'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'customcnt'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'cntper'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'TabSheet4'
      ImageIndex = 3
      object DBGridEh4: TDBGridEh
        Left = 0
        Top = 0
        Width = 955
        Height = 423
        Align = alClient
        DataSource = DS4
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        ReadOnly = True
        TabOrder = 0
        OnGetCellParams = DBGridEh4GetCellParams
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'title'
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
            FieldName = 'kg1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'kg2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'kgper'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ppkb'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ppkbper'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'cclkb'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'cclkbper'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'kb'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'slot1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'slot2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'slotper'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'customcnt'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  inherited CDS: TClientDataSet
    AfterOpen = CDSAfterOpen
    BeforeInsert = CDSBeforeInsert
    AfterPost = CDSAfterPost
    BeforeDelete = CDSBeforeDelete
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 581
    Top = 261
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 609
    Top = 261
  end
  object CDS3: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 581
    Top = 305
  end
  object DS3: TDataSource
    DataSet = CDS3
    Left = 609
    Top = 305
  end
  object CDS4: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 581
    Top = 345
  end
  object DS4: TDataSource
    DataSet = CDS4
    Left = 609
    Top = 345
  end
end
