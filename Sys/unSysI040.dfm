inherited FrmSysI040: TFrmSysI040
  Caption = 'FrmSysI040'
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter [0]
    Left = 300
    Top = 44
    Height = 451
  end
  inherited ToolBar: TToolBar
    ButtonWidth = 108
    TabOrder = 1
    object btn_refreshfieldname: TToolButton
      Left = 594
      Top = 0
      AutoSize = True
      Caption = 'btn_refreshfieldname'
      ImageIndex = 58
      OnClick = btn_refreshfieldnameClick
    end
  end
  inherited PnlBottom: TPanel
    TabOrder = 2
  end
  inherited Panel1: TPanel
    TabOrder = 3
  end
  object DBGridEh2: TDBGridEh [4]
    Left = 0
    Top = 44
    Width = 300
    Height = 451
    Align = alLeft
    DataSource = DS2
    DynProps = <>
    FooterParams.Color = clWindow
    GridLineParams.VertEmptySpaceStyle = dessNonEh
    IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    TabOrder = 0
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'TableName'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Remark'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object Panel2: TPanel [5]
    Left = 303
    Top = 44
    Width = 660
    Height = 451
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 4
    object DBGridEh1: TDBGridEh
      Left = 0
      Top = 0
      Width = 660
      Height = 451
      Align = alClient
      DataSource = DS1
      DynProps = <>
      FooterParams.Color = clWindow
      GridLineParams.VertEmptySpaceStyle = dessNonEh
      IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
      TabOrder = 0
      Columns = <
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'fieldname'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'typename'
          Footers = <>
          PickList.Strings = (
            'tinyint'
            'smallint'
            'int'
            'real'
            'money'
            'decimal'
            'numeric'
            'smallmoney'
            'bigint'
            'float'
            'varchar'
            'char'
            'nvarchar'
            'nchar'
            'smalldatetime'
            'datetime'
            'bit')
          Visible = False
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'caption'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'width'
          Footers = <>
        end
        item
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          FieldName = 'ispk'
          Footers = <>
          Title.Alignment = taCenter
        end
        item
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          FieldName = 'isprint'
          Footers = <>
          Title.Alignment = taCenter
        end
        item
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          FieldName = 'isexport'
          Footers = <>
          Title.Alignment = taCenter
        end
        item
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          FieldName = 'isquery'
          Footers = <>
          Title.Alignment = taCenter
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = CDS2BeforeInsert
    AfterPost = CDS2AfterPost
    AfterScroll = CDS2AfterScroll
    Left = 705
    Top = 37
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 733
    Top = 37
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 776
    Top = 36
  end
end
