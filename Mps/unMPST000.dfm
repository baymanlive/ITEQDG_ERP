inherited FrmMPST000: TFrmMPST000
  Left = 342
  Top = 103
  Caption = 'FrmMPST000'
  ClientHeight = 665
  ClientWidth = 1293
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter [0]
    Left = 321
    Top = 84
    Height = 551
  end
  inherited ToolBar: TToolBar
    Width = 1293
    inherited btn_query: TToolButton
      OnClick = btn_queryClick
    end
  end
  inherited Panel1: TPanel
    Top = 78
    Width = 1293
  end
  object PnlBottom: TPanel [3]
    Left = 0
    Top = 635
    Width = 1293
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 2
    object lblrecored: TLabel
      Tag = 1
      Left = 43
      Top = 8
      Width = 26
      Height = 13
      Caption = #31558#25976
    end
    object Bevel1: TBevel
      Left = 8
      Top = 14
      Width = 30
      Height = 10
      Shape = bsTopLine
    end
    object Bevel2: TBevel
      Left = 213
      Top = 14
      Width = 30
      Height = 10
      Shape = bsTopLine
    end
    object lblsp: TLabel
      Tag = 1
      Left = 138
      Top = 8
      Width = 3
      Height = 13
      Caption = '/'
    end
    object Edit1: TEdit
      Left = 73
      Top = 4
      Width = 60
      Height = 21
      TabStop = False
      ParentColor = True
      TabOrder = 0
      Text = '0'
    end
    object Edit2: TEdit
      Left = 148
      Top = 4
      Width = 60
      Height = 21
      TabStop = False
      ParentColor = True
      TabOrder = 1
      Text = '0'
    end
  end
  object Panel2: TPanel [4]
    Left = 324
    Top = 84
    Width = 969
    Height = 551
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    object DBGridEh2: TDBGridEh
      Left = 0
      Top = 0
      Width = 969
      Height = 396
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
      OnTitleClick = DBGridEh2TitleClick
      Columns = <
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'oeb04'
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
          FieldName = 'qty'
          Footer.ValueType = fvtSum
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
          FieldName = 'adate'
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
          FieldName = 'dbtype'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object DBGridEh3: TDBGridEh
      Left = 0
      Top = 396
      Width = 969
      Height = 155
      Align = alBottom
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
      TabOrder = 1
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
          FieldName = 'stype'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'materialno'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'materialno1'
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
          FieldName = 'sqty'
          Footer.ValueType = fvtSum
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  object Panel3: TPanel [5]
    Left = 0
    Top = 38
    Width = 1293
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    object lblpno: TLabel
      Left = 54
      Top = 14
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = 'lblpno'
    end
    object CheckBoxT: TCheckBox
      Left = 310
      Top = 11
      Width = 33
      Height = 17
      Caption = 'T'
      TabOrder = 0
    end
    object Edit3: TEdit
      Left = 88
      Top = 10
      Width = 177
      Height = 21
      Hint = #29289#21697#26009#34399
      TabOrder = 1
    end
    object CheckBoxE: TCheckBox
      Left = 276
      Top = 11
      Width = 33
      Height = 17
      Caption = 'E'
      TabOrder = 2
    end
    object CheckBoxB: TCheckBox
      Left = 344
      Top = 11
      Width = 33
      Height = 17
      Caption = 'B'
      TabOrder = 3
    end
    object CheckBoxR: TCheckBox
      Left = 378
      Top = 11
      Width = 33
      Height = 17
      Caption = 'R'
      TabOrder = 4
    end
    object CheckBoxP: TCheckBox
      Left = 414
      Top = 11
      Width = 33
      Height = 17
      Caption = 'P'
      TabOrder = 5
    end
    object CheckBoxQ: TCheckBox
      Left = 450
      Top = 11
      Width = 33
      Height = 17
      Caption = 'Q'
      TabOrder = 6
    end
    object CheckBoxM: TCheckBox
      Left = 486
      Top = 11
      Width = 33
      Height = 17
      Caption = 'M'
      TabOrder = 7
    end
    object CheckBoxN: TCheckBox
      Left = 522
      Top = 11
      Width = 33
      Height = 17
      Caption = 'N'
      TabOrder = 8
    end
    object CheckBox1: TCheckBox
      Left = 560
      Top = 11
      Width = 33
      Height = 17
      Caption = '1'
      TabOrder = 9
    end
    object chk: TCheckBox
      Left = 650
      Top = 11
      Width = 97
      Height = 17
      Caption = 'chk'
      TabOrder = 10
    end
  end
  object DBGridEh1: TDBGridEh [6]
    Left = 0
    Top = 84
    Width = 321
    Height = 551
    Align = alLeft
    DataSource = DS1
    DynProps = <>
    FooterRowCount = 1
    FooterParams.Color = clWindow
    GridLineParams.VertEmptySpaceStyle = dessNonEh
    IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    ReadOnly = True
    SumList.Active = True
    TabOrder = 5
    OnGetCellParams = DBGridEh1GetCellParams
    OnTitleClick = DBGridEh1TitleClick
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'dbtype'
        Footers = <>
      end
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
        Footer.ValueType = fvtSum
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ta_img01'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ta_img03'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ta_img04'
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
        FieldName = 'cjremark'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object DS3: TDataSource
    Left = 112
    Top = 273
  end
  object DS2: TDataSource
    Left = 84
    Top = 273
  end
  object DS1: TDataSource
    Left = 56
    Top = 273
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 156
    Top = 288
  end
end
