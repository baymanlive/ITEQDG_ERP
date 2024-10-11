inherited FrmMPST070_GetCore: TFrmMPST070_GetCore
  Left = 514
  Top = 246
  Width = 900
  Height = 500
  Caption = #20839#29992'core'#25490#31243
  FormStyle = fsStayOnTop
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 774
    Height = 462
    inherited btn_ok: TBitBtn
      Left = 5
      Top = 130
      Width = 100
      TabOrder = 3
    end
    inherited btn_quit: TBitBtn
      Left = 5
      Top = 160
      Width = 100
      TabOrder = 4
    end
    object BitBtn3: TBitBtn
      Left = 5
      Top = 10
      Width = 100
      Height = 25
      Caption = 'CCL'#25490#31243#36039#26009
      TabOrder = 0
      OnClick = BitBtn3Click
      NumGlyphs = 2
    end
    object BitBtn4: TBitBtn
      Left = 5
      Top = 40
      Width = 100
      Height = 25
      Caption = #21103#25490#31243#36039#26009
      TabOrder = 1
      OnClick = BitBtn4Click
      NumGlyphs = 2
    end
    object BitBtn5: TBitBtn
      Left = 5
      Top = 70
      Width = 100
      Height = 25
      Caption = #24235#23384#33287#26410#20132#29376#27841
      TabOrder = 2
      OnClick = BitBtn5Click
      NumGlyphs = 2
    end
    object BitBtn6: TBitBtn
      Left = 5
      Top = 100
      Width = 100
      Height = 25
      Caption = #21295#20986'Excel'
      TabOrder = 5
      OnClick = BitBtn6Click
      NumGlyphs = 2
    end
  end
  inherited PCL: TPageControl
    Width = 774
    Height = 462
    inherited TabSheet1: TTabSheet
      Caption = #20839#29992'core'#36039#26009
      object DBGridEh1: TDBGridEh
        Left = 0
        Top = 50
        Width = 766
        Height = 294
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
        OnCellClick = DBGridEh1CellClick
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
          Left = 55
          Top = 18
          Width = 32
          Height = 13
          Alignment = taRightJustify
          Caption = 'Label1'
        end
        object Label2: TLabel
          Left = 165
          Top = 18
          Width = 32
          Height = 13
          Alignment = taRightJustify
          Caption = 'Label2'
        end
        object Label8: TLabel
          Left = 575
          Top = 18
          Width = 32
          Height = 13
          Alignment = taRightJustify
          Caption = 'Label1'
        end
        object rgp: TRadioGroup
          Left = 300
          Top = 8
          Width = 250
          Height = 32
          Columns = 4
          ItemIndex = 0
          Items.Strings = (
            'L1~L5'
            'L6'
            #21103#25490#31243
            #20840#37096)
          TabOrder = 2
        end
        object dtp1: TDateTimePicker
          Left = 90
          Top = 15
          Width = 80
          Height = 21
          Date = 42640.000000000000000000
          Time = 42640.000000000000000000
          TabOrder = 0
        end
        object dtp2: TDateTimePicker
          Left = 205
          Top = 15
          Width = 80
          Height = 21
          Date = 42640.000000000000000000
          Time = 42640.000000000000000000
          TabOrder = 1
        end
        object BitBtn1: TBitBtn
          Left = 710
          Top = 13
          Width = 47
          Height = 25
          Hint = #35336#31639#36984#23450#26085#26399#33539#22285#20839'CCL'#25490#31243'PP'#20351#29992#37327
          Caption = #35336#31639
          TabOrder = 4
          OnClick = BitBtn1Click
        end
        object Edit3: TEdit
          Left = 610
          Top = 15
          Width = 100
          Height = 21
          TabOrder = 3
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 344
        Width = 766
        Height = 90
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        DesignSize = (
          766
          90)
        object Label3: TLabel
          Left = 20
          Top = 37
          Width = 32
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Label1'
        end
        object Label4: TLabel
          Left = 155
          Top = 37
          Width = 32
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Label1'
        end
        object Label5: TLabel
          Left = 230
          Top = 37
          Width = 32
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Label1'
        end
        object Label6: TLabel
          Left = 335
          Top = 37
          Width = 32
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Label1'
        end
        object Label9: TLabel
          Left = 154
          Top = 4
          Width = 32
          Height = 13
          Alignment = taRightJustify
          Anchors = [akLeft, akBottom]
          Caption = 'Label1'
        end
        object Label7: TLabel
          Left = 400
          Top = 37
          Width = 32
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Label1'
        end
        object Label10: TLabel
          Left = 520
          Top = 37
          Width = 32
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Label1'
        end
        object Cbb3: TDBComboBoxEh
          Left = 520
          Top = 55
          Width = 80
          Height = 21
          Anchors = [akLeft, akBottom]
          DynProps = <>
          EditButtons = <>
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          Visible = True
        end
        object Edit1: TEdit
          Left = 20
          Top = 55
          Width = 121
          Height = 21
          Anchors = [akLeft, akBottom]
          TabOrder = 0
        end
        object cbb1: TComboBox
          Left = 335
          Top = 55
          Width = 50
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akBottom]
          ItemHeight = 13
          TabOrder = 3
        end
        object dtp3: TDateTimePicker
          Left = 230
          Top = 55
          Width = 90
          Height = 21
          Anchors = [akLeft, akBottom]
          Date = 42640.000000000000000000
          Time = 42640.000000000000000000
          TabOrder = 2
        end
        object BitBtn2: TBitBtn
          Left = 601
          Top = 53
          Width = 47
          Height = 25
          Hint = #30452#25509#25351#23450#25490#29986
          Anchors = [akLeft, akBottom]
          Caption = #25490#29986
          TabOrder = 6
          OnClick = BitBtn2Click
        end
        object Edit2: TEdit
          Left = 155
          Top = 55
          Width = 60
          Height = 21
          Anchors = [akLeft, akBottom]
          TabOrder = 1
        end
        object Cbb2: TDBComboBoxEh
          Left = 400
          Top = 55
          Width = 110
          Height = 21
          Anchors = [akLeft, akBottom]
          DynProps = <>
          EditButtons = <>
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          Visible = True
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'CCL'#25490#31243#36039#26009
      ImageIndex = 1
      object DBGridEh2: TDBGridEh
        Left = 0
        Top = 0
        Width = 774
        Height = 443
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
        Width = 774
        Height = 445
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
            Width = 40
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
    Top = 257
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 140
    Top = 257
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 140
    Top = 285
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 172
    Top = 285
  end
  object CDS3: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 140
    Top = 317
  end
  object DS3: TDataSource
    DataSet = CDS3
    Left = 172
    Top = 317
  end
end
