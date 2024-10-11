inherited FrmIPQCT500_mps: TFrmIPQCT500_mps
  Width = 980
  Height = 587
  Caption = #25490#31243#36039#26009
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 854
    Height = 548
    inherited btn_ok: TBitBtn
      Left = 6
      Top = 218
      TabOrder = 4
      Visible = False
    end
    inherited btn_quit: TBitBtn
      Top = 100
      TabOrder = 3
    end
    object BitBtn1: TBitBtn
      Tag = 2
      Left = 10
      Top = 10
      Width = 90
      Height = 25
      Hint = #25490#31243#26597#35426
      Caption = #25490#31243#26597#35426
      TabOrder = 0
      OnClick = BitBtn1Click
      NumGlyphs = 2
    end
    object BitBtn2: TBitBtn
      Tag = 2
      Left = 10
      Top = 40
      Width = 90
      Height = 25
      Hint = #35336#31639#25152#36984#25799#30340#25490#31243#38656#27714#37327
      Caption = #20633#26009#35336#31639
      TabOrder = 1
      OnClick = BitBtn2Click
      NumGlyphs = 2
    end
    object BitBtn3: TBitBtn
      Tag = 2
      Left = 10
      Top = 70
      Width = 90
      Height = 25
      Hint = #23565#36984#20013#30340#36039#26009#28155#21152#21040#20316#26989#20013
      Caption = #24314#31435#21934#25818
      TabOrder = 2
      OnClick = BitBtn3Click
      NumGlyphs = 2
    end
  end
  inherited PCL: TPageControl
    Width = 854
    Height = 548
    inherited TabSheet1: TTabSheet
      Caption = #25490#31243#36039#26009
      object DBGridEh1: TDBGridEh
        Left = 0
        Top = 50
        Width = 846
        Height = 470
        Align = alClient
        DataSource = DS
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        ReadOnly = True
        TabOrder = 1
        OnCellClick = DBGridEh1CellClick
        OnGetCellParams = DBGridEh1GetCellParams
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'lock'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'machine'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sdate'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'wono'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderitem'
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
            FieldName = 'sqty'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'adate_new'
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
            FieldName = 'breadth'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'fiber'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'premark'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'wostation_qtystr'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderqty'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderno2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderitem2'
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
            FieldName = 'pnlsize1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pnlsize2'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 846
        Height = 50
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Label1: TLabel
          Left = 35
          Top = 16
          Width = 65
          Height = 13
          Alignment = taRightJustify
          Caption = #29983#29986#26085#26399#65306
        end
        object Label2: TLabel
          Left = 192
          Top = 16
          Width = 13
          Height = 13
          Alignment = taRightJustify
          Caption = #33267
        end
        object Label3: TLabel
          Left = 535
          Top = 32
          Width = 6
          Height = 13
          Caption = '0'
        end
        object RG: TRadioGroup
          Left = 340
          Top = 2
          Width = 160
          Height = 36
          TabOrder = 2
          OnClick = RGClick
        end
        object Dtp1: TDateTimePicker
          Left = 100
          Top = 12
          Width = 90
          Height = 21
          Date = 42677.000000000000000000
          Time = 42677.000000000000000000
          TabOrder = 0
        end
        object Dtp2: TDateTimePicker
          Left = 210
          Top = 12
          Width = 90
          Height = 21
          Date = 42677.000000000000000000
          Time = 42677.000000000000000000
          TabOrder = 1
        end
        object BitBtn4: TBitBtn
          Left = 535
          Top = 0
          Width = 75
          Height = 25
          Caption = 'BitBtn4'
          TabOrder = 3
          OnClick = BitBtn4Click
        end
        object BitBtn5: TBitBtn
          Tag = 1
          Left = 610
          Top = 0
          Width = 75
          Height = 25
          Caption = 'BitBtn5'
          TabOrder = 4
          OnClick = BitBtn4Click
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #38656#27714#36039#26009
      ImageIndex = 1
      object DBGridEh2: TDBGridEh
        Left = 0
        Top = 0
        Width = 846
        Height = 521
        Align = alClient
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
            FieldName = 'checkbox'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'fiber'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'breadth'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'vendor'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pno'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'qty'
            Footers = <>
            ReadOnly = True
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object CDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'CDSIndex1'
        DescFields = 'RC'
        Fields = 'Machine;Sdate;Jitem;AD;FISno;RC;Fiber;Simuver;Citem'
        Options = [ixDescending]
      end>
    IndexName = 'CDSIndex1'
    Params = <>
    StoreDefs = True
    AfterPost = CDSAfterPost
    Left = 57
    Top = 217
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 86
    Top = 217
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    BeforeInsert = CDS2BeforeInsert
    Left = 117
    Top = 217
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 146
    Top = 217
  end
end
