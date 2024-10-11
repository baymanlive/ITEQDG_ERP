inherited FrmMPSR140: TFrmMPSR140
  Caption = 'FrmMPSR140'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PCL: TPageControl
    inherited TabSheet1: TTabSheet
      Caption = #21332#35696#36926#26399#26126#32048
      inherited DBGridEh1: TDBGridEh
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oea02'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oea01'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oeb03'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pgroup'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oea04'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'occ02'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ptype'
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
            FieldName = 'oeb04'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ta_oeb01'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ta_oeb02'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oeb05'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oeb12'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oeb24'
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
            FieldName = 'oeb15'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'adate'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'overday'
            Footers = <>
          end>
      end
    end
    object TabSheet2: TTabSheet
      Caption = #23458#25142#35201#27714#36926#26399#26126#32048
      ImageIndex = 2
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
            FieldName = 'oea02'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oea01'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oeb03'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pgroup'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oea04'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'occ02'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ptype'
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
            FieldName = 'oeb04'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ta_oeb01'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ta_oeb02'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oeb05'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oeb12'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oeb24'
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
            FieldName = 'oeb15'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'adate'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'overday'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'L/T'#35373#23450
      ImageIndex = 1
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
        PopupMenu = PopupMenu1
        TabOrder = 0
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pgroup'
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
            FieldName = 'ad'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'normal'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'qta'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object CDS3: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = CDS3BeforeInsert
    BeforeEdit = CDS3BeforeEdit
    AfterEdit = CDS3AfterEdit
    BeforePost = CDS3BeforePost
    AfterPost = CDS3AfterPost
    OnNewRecord = CDS3NewRecord
    Left = 893
    Top = 377
  end
  object DS3: TDataSource
    DataSet = CDS3
    Left = 922
    Top = 377
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PopupMenu1Popup
    Left = 950
    Top = 377
    object N201: TMenuItem
      Caption = #26032#22686
      OnClick = N201Click
    end
    object N202: TMenuItem
      Caption = #21034#38500
      OnClick = N202Click
    end
    object N203: TMenuItem
      Caption = #20462#25913
      OnClick = N203Click
    end
    object N206: TMenuItem
      Caption = '-'
    end
    object N204: TMenuItem
      Caption = #20786#23384
      OnClick = N204Click
    end
    object N205: TMenuItem
      Caption = #21462#28040
      OnClick = N205Click
    end
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 837
    Top = 377
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 866
    Top = 377
  end
end
