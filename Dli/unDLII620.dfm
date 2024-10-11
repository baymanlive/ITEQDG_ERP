inherited FrmDLII620: TFrmDLII620
  Caption = 'FrmDLII620'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    object btn_dlii620: TToolButton
      Left = 594
      Top = 0
      AutoSize = True
      Caption = 'PDA'#38283#38364
      ImageIndex = 8
      OnClick = btn_dlii620Click
    end
  end
  inherited PCL: TPageControl
    inherited TabSheet1: TTabSheet
      Caption = 'CCL'#31532'2'#30908
      inherited DBGridEh1: TDBGridEh
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Custno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Code'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'LstCode'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'StdValue'
            Footers = <>
          end>
      end
    end
    object dlii620_ts1: TTabSheet
      Caption = 'CCL'#31532'7-8'#30908
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
        PopupMenu = PopupMenu1
        TabOrder = 0
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Custno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Code'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'LstCode'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'StdValue'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object dlii620_ts2: TTabSheet
      Caption = 'CCL'#31532'9-14'#30908
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
        PopupMenu = PopupMenu1
        TabOrder = 0
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Custno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Code'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'LstCode'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'StdValue'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object dlii620_ts3: TTabSheet
      Caption = 'CCL'#31532'16'#30908
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
        PopupMenu = PopupMenu1
        TabOrder = 0
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Custno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Code'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'LstCode'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'StdValue'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'StdValueNo'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'StdValueOne'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object dlii620_ts4: TTabSheet
      Caption = 'PP'#31532'2'#30908
      ImageIndex = 4
      object DBGridEh5: TDBGridEh
        Left = 0
        Top = 0
        Width = 955
        Height = 423
        Align = alClient
        DataSource = DS5
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        PopupMenu = PopupMenu1
        TabOrder = 0
        OnColWidthsChanged = DBGridEh1ColWidthsChanged
        OnMouseDown = DBGridEh1MouseDown
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Custno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Code'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'LstCode'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'StdValue'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object dlii620_ts5: TTabSheet
      Caption = 'PP'#31532'3'#30908
      ImageIndex = 5
      object DBGridEh6: TDBGridEh
        Left = 0
        Top = 0
        Width = 955
        Height = 423
        Align = alClient
        DataSource = DS6
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
            FieldName = 'Custno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Code'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'LstCode'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'StdValue'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'StdValueNo'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'StdValueOne'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object dlii620_ts6: TTabSheet
      Caption = 'PP'#31532'4-7'#30908
      ImageIndex = 6
      object DBGridEh7: TDBGridEh
        Left = 0
        Top = 0
        Width = 955
        Height = 423
        Align = alClient
        DataSource = DS7
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        PopupMenu = PopupMenu1
        TabOrder = 0
        OnColWidthsChanged = DBGridEh1ColWidthsChanged
        OnMouseDown = DBGridEh1MouseDown
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Custno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Code'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'LstCode'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'StdValue'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object dlii620_ts7: TTabSheet
      Caption = 'PP'#31532'8-10'#30908
      ImageIndex = 7
      object DBGridEh8: TDBGridEh
        Left = 0
        Top = 0
        Width = 955
        Height = 423
        Align = alClient
        DataSource = DS8
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        PopupMenu = PopupMenu1
        TabOrder = 0
        OnColWidthsChanged = DBGridEh1ColWidthsChanged
        OnMouseDown = DBGridEh1MouseDown
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Custno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Code'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'LstCode'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'StdValue'
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
    BeforeInsert = CDS2BeforeInsert
    BeforeEdit = CDS2BeforeEdit
    AfterEdit = CDS2AfterEdit
    BeforePost = CDS2BeforePost
    AfterPost = CDS2AfterPost
    OnNewRecord = CDS2NewRecord
    Left = 541
    Top = 173
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 570
    Top = 173
  end
  object CDS3: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = CDS2BeforeInsert
    BeforeEdit = CDS2BeforeEdit
    AfterEdit = CDS2AfterEdit
    BeforePost = CDS3BeforePost
    AfterPost = CDS2AfterPost
    OnNewRecord = CDS2NewRecord
    Left = 541
    Top = 201
  end
  object DS3: TDataSource
    DataSet = CDS3
    Left = 570
    Top = 201
  end
  object CDS4: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = CDS2BeforeInsert
    BeforeEdit = CDS2BeforeEdit
    AfterEdit = CDS2AfterEdit
    BeforePost = CDS4BeforePost
    AfterPost = CDS2AfterPost
    OnNewRecord = CDS2NewRecord
    Left = 541
    Top = 229
  end
  object DS4: TDataSource
    DataSet = CDS4
    Left = 570
    Top = 229
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PopupMenu1Popup
    Left = 598
    Top = 173
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
  object CDS5: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = CDS2BeforeInsert
    BeforeEdit = CDS2BeforeEdit
    AfterEdit = CDS2AfterEdit
    BeforePost = CDS5BeforePost
    AfterPost = CDS2AfterPost
    OnNewRecord = CDS2NewRecord
    Left = 541
    Top = 257
  end
  object DS5: TDataSource
    DataSet = CDS5
    Left = 570
    Top = 257
  end
  object CDS6: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = CDS2BeforeInsert
    BeforeEdit = CDS2BeforeEdit
    AfterEdit = CDS2AfterEdit
    BeforePost = CDS6BeforePost
    AfterPost = CDS2AfterPost
    OnNewRecord = CDS2NewRecord
    Left = 541
    Top = 285
  end
  object DS6: TDataSource
    DataSet = CDS6
    Left = 570
    Top = 285
  end
  object CDS7: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = CDS2BeforeInsert
    BeforeEdit = CDS2BeforeEdit
    AfterEdit = CDS2AfterEdit
    BeforePost = CDS7BeforePost
    AfterPost = CDS2AfterPost
    OnNewRecord = CDS2NewRecord
    Left = 541
    Top = 313
  end
  object DS7: TDataSource
    DataSet = CDS7
    Left = 570
    Top = 313
  end
  object CDS8: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = CDS2BeforeInsert
    BeforeEdit = CDS2BeforeEdit
    AfterEdit = CDS2AfterEdit
    BeforePost = CDS8BeforePost
    AfterPost = CDS2AfterPost
    OnNewRecord = CDS2NewRecord
    Left = 541
    Top = 341
  end
  object DS8: TDataSource
    DataSet = CDS8
    Left = 570
    Top = 341
  end
end
