inherited FrmDLII020_AC172: TFrmDLII020_AC172
  Left = 3
  Top = 0
  Width = 598
  Height = 957
  Caption = #27427#24375#27161#31805
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 472
    Height = 919
    inherited btn_ok: TBitBtn
      Top = 158
      TabOrder = 5
      Visible = False
    end
    inherited btn_quit: TBitBtn
      Top = 130
      TabOrder = 4
    end
    object BitBtn1: TBitBtn
      Left = 10
      Top = 10
      Width = 90
      Height = 25
      Caption = 'BitBtn1'
      TabOrder = 0
      OnClick = BitBtn1Click
      NumGlyphs = 2
    end
    object BitBtn2: TBitBtn
      Left = 10
      Top = 70
      Width = 90
      Height = 25
      Caption = 'BitBtn2'
      TabOrder = 2
      OnClick = BitBtn2Click
      NumGlyphs = 2
    end
    object BitBtn3: TBitBtn
      Left = 10
      Top = 100
      Width = 90
      Height = 25
      Caption = 'BitBtn3'
      TabOrder = 3
      OnClick = BitBtn3Click
      NumGlyphs = 2
    end
    object BitBtn4: TBitBtn
      Left = 10
      Top = 40
      Width = 90
      Height = 25
      Caption = 'BitBtn4'
      TabOrder = 1
      OnClick = BitBtn4Click
      NumGlyphs = 2
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 472
    Height = 919
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object DBGridEh2: TDBGridEh
      Left = 0
      Top = 210
      Width = 472
      Height = 684
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
      OnCellClick = DBGridEh2CellClick
      Columns = <
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'checkbox'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'manfac1'
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
          FieldName = 'sflagx'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'jflagx'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'jremark'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'lotsn'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'boxsn'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 472
      Height = 50
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 1
      object Label1: TLabel
        Left = 64
        Top = 18
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = 'Label1'
      end
      object Edit1: TEdit
        Left = 100
        Top = 15
        Width = 121
        Height = 21
        TabOrder = 0
      end
      object btn_query: TBitBtn
        Left = 224
        Top = 12
        Width = 55
        Height = 25
        Caption = 'btn_query'
        TabOrder = 1
        OnClick = btn_queryClick
      end
    end
    object DBGridEh1: TDBGridEh
      Left = 0
      Top = 50
      Width = 472
      Height = 160
      Align = alTop
      DataSource = DS1
      DynProps = <>
      FooterParams.Color = clWindow
      GridLineParams.VertEmptySpaceStyle = dessNonEh
      IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
      ReadOnly = True
      TabOrder = 2
      Columns = <
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'indate'
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
          FieldName = 'saleno'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'saleitem'
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
          FieldName = 'sizes'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'Longitude'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'Latitude'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'Notcount'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'Delcount'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'Units'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'Custorderno'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'Custprono'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 894
      Width = 472
      Height = 25
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 3
      object Label2: TLabel
        Left = 196
        Top = 6
        Width = 32
        Height = 13
        Caption = 'Label2'
      end
      object CheckBox1: TCheckBox
        Left = 36
        Top = 4
        Width = 97
        Height = 17
        Caption = 'CheckBox1'
        TabOrder = 0
        OnClick = CheckBox1Click
      end
    end
  end
  object CDS1: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterScroll = CDS1AfterScroll
    Left = 124
    Top = 124
  end
  object DS1: TDataSource
    DataSet = CDS1
    Left = 152
    Top = 124
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 148
    Top = 260
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 120
    Top = 260
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 148
    Top = 320
  end
end
