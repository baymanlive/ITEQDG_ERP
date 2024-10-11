inherited FrmMPST010_GetCore: TFrmMPST010_GetCore
  Width = 900
  Height = 600
  Caption = #20839#29992'core'#35336#31639
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 774
    Height = 561
    inherited btn_ok: TBitBtn
      Left = 8
      Top = 190
      Width = 95
      TabOrder = 3
      Visible = False
    end
    inherited btn_quit: TBitBtn
      Left = 8
      Top = 70
      Width = 95
      TabOrder = 2
    end
    object BitBtn2: TBitBtn
      Left = 8
      Top = 10
      Width = 95
      Height = 25
      Caption = 'CCL'#25490#31243#36039#26009
      TabOrder = 0
      OnClick = BitBtn2Click
      NumGlyphs = 2
    end
    object BitBtn3: TBitBtn
      Left = 8
      Top = 40
      Width = 95
      Height = 25
      Caption = #21103#25490#31243#36039#26009
      TabOrder = 1
      OnClick = BitBtn3Click
      NumGlyphs = 2
    end
  end
  inherited PCL: TPageControl
    Width = 774
    Height = 561
    inherited TabSheet1: TTabSheet
      Caption = #20839#29992'core'#36039#26009
      object DBGridEh1: TDBGridEh
        Left = 0
        Top = 50
        Width = 766
        Height = 458
        Align = alClient
        DataSource = DS
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        ReadOnly = True
        TabOrder = 0
        OnTitleClick = DBGridEh1TitleClick
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'materialno'
            Footers = <>
            Width = 140
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sqty'
            Footers = <>
            Width = 80
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'stk_qty'
            Footers = <>
            Width = 80
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'zt_qty'
            Footers = <>
            Width = 80
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'diff_qty'
            Footers = <>
            Width = 80
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 766
        Height = 50
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Label1: TLabel
          Left = 58
          Top = 18
          Width = 32
          Height = 13
          Alignment = taRightJustify
          Caption = 'Label1'
        end
        object Label2: TLabel
          Left = 176
          Top = 18
          Width = 32
          Height = 13
          Alignment = taCenter
          Caption = 'Label2'
        end
        object Label8: TLabel
          Left = 516
          Top = 20
          Width = 32
          Height = 13
          Alignment = taRightJustify
          Caption = 'Label1'
        end
        object rgp: TRadioGroup
          Left = 296
          Top = 4
          Width = 200
          Height = 36
          Columns = 3
          ItemIndex = 0
          Items.Strings = (
            'DG'
            'GZ'
            #21103#25490#31243)
          TabOrder = 2
        end
        object dtp1: TDateTimePicker
          Left = 92
          Top = 15
          Width = 80
          Height = 21
          Date = 42640.000000000000000000
          Time = 42640.000000000000000000
          TabOrder = 0
        end
        object dtp2: TDateTimePicker
          Left = 202
          Top = 15
          Width = 80
          Height = 21
          Date = 42640.000000000000000000
          Time = 42640.000000000000000000
          TabOrder = 1
        end
        object BitBtn1: TBitBtn
          Left = 650
          Top = 13
          Width = 47
          Height = 25
          Hint = #35336#31639#36984#23450#26085#26399#33539#22285#20839'CCL'#25490#31243'PP'#20351#29992#37327
          Caption = #35336#31639
          TabOrder = 4
          OnClick = BitBtn1Click
        end
        object Edit2: TEdit
          Left = 550
          Top = 15
          Width = 100
          Height = 21
          TabOrder = 3
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 508
        Width = 766
        Height = 25
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        object Label9: TLabel
          Left = 120
          Top = 7
          Width = 32
          Height = 13
          Alignment = taRightJustify
          Caption = 'Label1'
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'CCL'#25490#31243#36039#26009
      ImageIndex = 1
      object DBGridEh2: TDBGridEh
        Left = 0
        Top = 0
        Width = 766
        Height = 533
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
            FieldName = 'sdate'
            Footers = <>
            Width = 70
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'machine'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'currentboiler'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'materialno'
            Footers = <>
            Width = 140
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'wono'
            Footers = <>
            Width = 70
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custno'
            Footers = <>
            Width = 100
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sqty'
            Footers = <>
            Width = 50
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'adate_new'
            Footers = <>
            Width = 90
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #21103#25490#31243#36039#26009
      ImageIndex = 2
      object DBGridEh3: TDBGridEh
        Left = 0
        Top = 0
        Width = 766
        Height = 533
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
            FieldName = 'stype'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sdate'
            Footers = <>
            Width = 70
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'materialno'
            Footers = <>
            Width = 140
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custno'
            Footers = <>
            Width = 100
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sqty'
            Footers = <>
            Width = 50
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'adate'
            Footers = <>
            Width = 90
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 172
    Top = 265
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 140
    Top = 265
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 140
    Top = 293
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 172
    Top = 293
  end
  object CDS3: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 140
    Top = 321
  end
  object DS3: TDataSource
    DataSet = CDS3
    Left = 172
    Top = 321
  end
end
