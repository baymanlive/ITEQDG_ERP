inherited FrmMPST040: TFrmMPST040
  Caption = 'FrmMPST040'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    object btn_garbage: TToolButton
      Left = 594
      Top = 0
      AutoSize = True
      Caption = #20316#30280
      ImageIndex = 7
      OnClick = btn_garbageClick
    end
    object btn_color: TToolButton
      Left = 631
      Top = 0
      AutoSize = True
      Caption = #38991#33394
      DropdownMenu = btnmenu
      ImageIndex = 62
      Style = tbsDropDown
    end
    object ToolButton200: TToolButton
      Left = 681
      Top = 0
      Width = 20
      Caption = 'ToolButton200'
      ImageIndex = 63
      Style = tbsSeparator
    end
  end
  inherited PnlBottom: TPanel
    Top = 422
    Height = 32
    object LblTot: TLabel [4]
      Left = 290
      Top = 5
      Width = 44
      Height = 17
      Caption = 'LblTot'
      Font.Charset = CHINESEBIG5_CHARSET
      Font.Color = clBlue
      Font.Height = -17
      Font.Name = #26032#32048#26126#39636
      Font.Style = []
      ParentFont = False
    end
    object Image1: TImage [5]
      Tag = 2
      Left = 250
      Top = 0
      Width = 32
      Height = 32
      AutoSize = True
      Picture.Data = {
        055449636F6E0000010001002020100000000000E80200001600000028000000
        2000000040000000010004000000000080020000000000000000000000000000
        0000000000000000000080000080000000808000800000008000800080800000
        80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
        FFFFFF0000000000000999999999000000000000000000009999999999999999
        0000000000000009999900000000099990000000000009999000000000000009
        9990000000009999000000000000000099990000000099000000000000000000
        0099000000099000000000000000000000099000009990000000000000000000
        0009990000990000000000009900000000009900099000000000000099999999
        9000099009900000009909909900999900000990990000000099999099009900
        0000009999000000009909909999999900000099990000000099099099009900
        0000009999000000009909909999999900000099990000000999099999009900
        0000009999000000009999999999999990000099990000000099000099009999
        0000009999000000009900990999900000000099990000000009900990990099
        0000009999000000000990099999999990000099099000000999999990990099
        0000099009900000000099000099900000000990009900000000000000000000
        0000990000999000000000000000000000099900000990000000000000000000
        0009900000009900000000000000000000990000000099990000000000000000
        9999000000000999900000000000000999900000000000099999000000000999
        9000000000000000999999999999999900000000000000000009999999990000
        00000000FFE00FFFFF0000FFFE0FF87FF87FFE1FF0FFFF0FF3FFFFCFE7FFFFE7
        C7FFFFE3CFFF3FF39FFF00799FC930F93FC133FC3FC900FC3FC933FC3FC900FC
        3F8833FC3FC0007C3FCF30FC3FCC87FC3FE64CFC3FE6007C9F804CF99FF3C7F9
        CFFFFFF3C7FFFFE3E7FFFFE7F3FFFFCFF0FFFF0FF87FFE1FFE0FF87FFF0000FF
        FFE00FFF}
      Visible = False
    end
  end
  inherited pnl: TPanel
    Width = 526
    Height = 378
    inherited PCL: TPageControl [0]
      Width = 526
      Height = 101
      inherited TabSheet1: TTabSheet
        Caption = #35330#21934#36039#26009
        inherited DBGridEh1: TDBGridEh
          Width = 518
          Height = 73
          OnDblClick = DBGridEh1DblClick
          OnGetCellParams = DBGridEh1GetCellParams
          OnKeyDown = DBGridEh1KeyDown
          OnTitleClick = DBGridEh1TitleClick
          Columns = <
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Indate'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Sno'
              Footers = <>
              ReadOnly = True
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Adate'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Odate'
              Footers = <>
            end
            item
              DisplayFormat = 'HH:NN'
              DynProps = <>
              EditButtons = <>
              FieldName = 'Stime'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Custno'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Custshort'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Orderno'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Orderitem'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Pno'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Pname'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Sizes'
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
              FieldName = 'Notcount1'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Delcount1'
              Footers = <>
              ReadOnly = True
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Coccount1'
              Footers = <>
              ReadOnly = True
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Chkcount'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Remain_ordqty'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'W_pno'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'W_qty'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Remark1'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Remark2'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Remark3'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Remark4'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Remark5'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Remark6'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'SaleRemark'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'StkRemark'
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
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Custname'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Remark'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'SendAddr'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'CtrlRemark'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'ErrorCause'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'ErrorDept'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'StorageTime'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'StorageNo'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'WIP'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Kg'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'GarbageFlag'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'custno2'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'custname2'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'custpo2'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'custpno2'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'custpname2'
              Footers = <>
            end>
        end
      end
    end
    inherited PCL2: TPageControl [1]
      Top = 178
      Width = 526
      ActivePage = TabSheet5
      inherited TabSheet2: TTabSheet
        Caption = #22312#35069#29376#27841
        inherited DBGridEh2: TDBGridEh
          Width = 518
          ReadOnly = True
          OnDrawColumnCell = DBGridEh2DrawColumnCell
          Columns = <
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'wono'
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
              FieldName = 'machine'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'currentboiler'
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
              FieldName = 's1'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 's2'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 's3'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 's4'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'sy_date'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'xy_date'
              Footers = <>
            end
            item
              DisplayFormat = 'YYYY-M-D HH:NN'
              DynProps = <>
              EditButtons = <>
              FieldName = 'cx_date'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 's5'
              Footers = <>
            end
            item
              DisplayFormat = 'YYYY-M-D HH:NN'
              DynProps = <>
              EditButtons = <>
              FieldName = 's5_date'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 's6'
              Footers = <>
            end
            item
              DisplayFormat = 'YYYY-M-D HH:NN'
              DynProps = <>
              EditButtons = <>
              FieldName = 's6_date'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 's7'
              Footers = <>
            end
            item
              DisplayFormat = 'YYYY-M-D HH:NN'
              DynProps = <>
              EditButtons = <>
              FieldName = 'bz_date'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'remark'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'remark2'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'sj'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'zc'
              Footers = <>
            end>
        end
      end
      object TabSheet4: TTabSheet
        Caption = #36031#26131#29376#27841
        ImageIndex = 2
        object DBGridEh4: TDBGridEh
          Left = 0
          Top = 0
          Width = 1218
          Height = 172
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
              FieldName = 'srcid'
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
              FieldName = 'purqty'
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
              FieldName = 'date4'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'date6'
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
              FieldName = 'adate_new'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Orderno'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Orderitem'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Orderno2'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Orderitem2'
              Footers = <>
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
      object TabSheet3: TTabSheet
        Caption = #20132#26399#25286#20998#29376#27841
        ImageIndex = 2
        object DBGridEh3: TDBGridEh
          Left = 0
          Top = 0
          Width = 1218
          Height = 172
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
              FieldName = 'ditem'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Materialno'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Adate'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'CDate'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Qty'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'GarbageFlag'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Flag'
              Footers = <>
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
      object TabSheet5: TTabSheet
        Caption = #20633#26009#36039#26009
        ImageIndex = 3
        object DBGridEh6: TDBGridEh
          Left = 305
          Top = 0
          Width = 213
          Height = 172
          Align = alClient
          DataSource = DS6
          DynProps = <>
          FooterParams.Color = clWindow
          GridLineParams.VertEmptySpaceStyle = dessNonEh
          IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
          ReadOnly = True
          TabOrder = 0
          OnDblClick = DBGridEh6DblClick
          Columns = <
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'sfa03'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'sfa05'
              Footers = <>
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
        object DBGridEh5: TDBGridEh
          Left = 0
          Top = 0
          Width = 305
          Height = 172
          Align = alLeft
          DataSource = DS5
          DynProps = <>
          FooterParams.Color = clWindow
          GridLineParams.VertEmptySpaceStyle = dessNonEh
          IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
          ReadOnly = True
          TabOrder = 1
          Columns = <
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'sfb01'
              Footers = <>
              Width = 92
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'sfb08'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'sfb09'
              Footers = <>
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 101
      Width = 526
      Height = 77
      Align = alBottom
      TabOrder = 2
      Visible = False
      object StringGrid1: TStringGrid
        Left = 1
        Top = 1
        Width = 524
        Height = 75
        Align = alClient
        BorderStyle = bsNone
        ColCount = 7
        Ctl3D = False
        DefaultColWidth = 100
        RowCount = 3
        ParentCtl3D = False
        ScrollBars = ssNone
        TabOrder = 0
        OnDblClick = StringGrid1DblClick
      end
    end
  end
  object PnlRight: TPanel [4]
    Left = 526
    Top = 44
    Width = 110
    Height = 378
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object btn_mpst040A: TBitBtn
      Tag = 2
      Left = 5
      Top = 10
      Width = 100
      Height = 25
      Hint = #26681#25818#25286#20998#30340#36948#20132#26085#26399#25110'Call'#26085#26399#25209#37327#26032#22686#20986#36008#25490#31243#36039#26009
      Caption = #26032#22686#20986#36008#34920
      TabOrder = 0
      OnClick = btn_mpst040AClick
      NumGlyphs = 2
    end
    object btn_mpst040B: TBitBtn
      Tag = 2
      Left = 5
      Top = 40
      Width = 100
      Height = 25
      Hint = #25351#23450#35330#21934#34399#30908#26032#22686#20986#36008#25490#31243
      Caption = #21934#31558#26032#22686#20986#36008#34920
      TabOrder = 1
      OnClick = btn_mpst040BClick
      NumGlyphs = 2
    end
    object btn_mpst040N: TBitBtn
      Tag = 2
      Left = 5
      Top = 70
      Width = 100
      Height = 25
      Hint = #24291#24030#24288#21487#29992
      Caption = #24291#24030#20986#36008#34920
      TabOrder = 2
      OnClick = btn_mpst040NClick
      NumGlyphs = 2
    end
    object btn_mpst040C: TBitBtn
      Tag = 2
      Left = 5
      Top = 100
      Width = 100
      Height = 25
      Hint = #26410#20986#36008#30340#25490#31243#36039#26009#25209#37327#26356#25913#20986#36008#26085#26399
      Caption = #26356#25913#20986#36008#26085#26399
      TabOrder = 3
      OnClick = btn_mpst040CClick
      NumGlyphs = 2
    end
    object btn_mpst040D: TBitBtn
      Tag = 3
      Left = 5
      Top = 130
      Width = 100
      Height = 25
      Hint = #35336#31639#24235#23384
      Caption = #24235#23384#33287#26410#20132#29376#27841
      TabOrder = 4
      OnClick = btn_mpst040DClick
      NumGlyphs = 2
    end
    object btn_mpst040E: TBitBtn
      Tag = 3
      Left = 5
      Top = 160
      Width = 100
      Height = 25
      Hint = #26597#35426'DG'#25152#26377#26410#20132#26126#32048
      Caption = 'DG'#26410#20132#26126#32048
      TabOrder = 5
      OnClick = btn_mpst040EClick
      NumGlyphs = 2
    end
    object btn_mpst040F: TBitBtn
      Tag = 3
      Left = 5
      Top = 190
      Width = 100
      Height = 25
      Hint = #26597#35426'GZ'#25152#26377#26410#20132#26126#32048
      Caption = 'GZ'#26410#20132#26126#32048
      TabOrder = 6
      OnClick = btn_mpst040EClick
      NumGlyphs = 2
    end
    object btn_mpst040G: TBitBtn
      Tag = 3
      Left = 5
      Top = 220
      Width = 100
      Height = 25
      Hint = #22312#35069#29376#27841#26597#35426
      Caption = #22312#35069#29376#27841#26597#35426
      TabOrder = 7
      OnClick = btn_mpst040GClick
      NumGlyphs = 2
    end
    object btn_mpst040H: TBitBtn
      Tag = 3
      Left = 5
      Top = 250
      Width = 100
      Height = 25
      Hint = #26597#35426#25351#23450#20986#36008#26085#26399#25152#26377#23567#26495#24037#21934#34399#30908
      Caption = #23567#26495#24037#21934#26597#35426
      TabOrder = 8
      OnClick = btn_mpst040HClick
      NumGlyphs = 2
    end
    object btn_mpst040I: TBitBtn
      Left = 5
      Top = 280
      Width = 100
      Height = 25
      Hint = #40670#25802#26356#26032#29983#29986#36914#24230
      Caption = #26356#26032#29983#29986#36914#24230
      TabOrder = 9
      OnClick = btn_mpst040IClick
      NumGlyphs = 2
    end
    object btn_mpst040J: TBitBtn
      Tag = 2
      Left = 5
      Top = 310
      Width = 100
      Height = 25
      Hint = #40670#25802#26356#26032#22312#35069#29376#27841#21040#29983#31649#20633#35387
      Caption = #26356#26032#29983#31649#20633#35387
      TabOrder = 10
      OnClick = btn_mpst040JClick
      NumGlyphs = 2
    end
    object btn_mpst040K: TBitBtn
      Tag = 2
      Left = 5
      Top = 340
      Width = 100
      Height = 25
      Hint = #26356#26032#21363#26178#24235#23384
      Caption = #26356#26032#24235#23384
      TabOrder = 11
      OnClick = btn_mpst040KClick
      NumGlyphs = 2
    end
    object btn_mpst040M: TBitBtn
      Tag = 2
      Left = 5
      Top = 370
      Width = 100
      Height = 25
      Caption = #26356#26032#23458#25142'PO'
      TabOrder = 12
      OnClick = btn_mpst040MClick
      NumGlyphs = 2
    end
    object btn_mpst040O: TBitBtn
      Tag = 2
      Left = 5
      Top = 400
      Width = 100
      Height = 25
      Caption = #26356#26032#26410#20132#25976#37327
      TabOrder = 13
      OnClick = btn_mpst040OClick
      NumGlyphs = 2
    end
    object btn_mpst040L: TBitBtn
      Tag = 2
      Left = 5
      Top = 426
      Width = 100
      Height = 25
      Hint = #23565#26576#19968#22825#30340#20986#36008#34920#36914#34892#30906#35469#25110#21462#28040#30906#35469
      Caption = #30906#35469#25110#21462#28040#30906#35469
      TabOrder = 14
      OnClick = btn_mpst040LClick
      NumGlyphs = 2
    end
    object btn_mpst040_total: TButton
      Left = 5
      Top = 453
      Width = 100
      Height = 25
      Caption = #32218#36335#24409#32317#23566#20986
      TabOrder = 15
      OnClick = btn_mpst040_totalClick
    end
    object btn_mpst040Q: TBitBtn
      Tag = 2
      Left = 5
      Top = 480
      Width = 100
      Height = 25
      Hint = #23565#26576#19968#22825#30340#20986#36008#34920#36914#34892#30906#35469#25110#21462#28040#30906#35469
      Caption = #20986#36008#25976#37327#32113#35336#34920
      TabOrder = 16
      OnClick = btn_mpst040QClick
      NumGlyphs = 2
    end
  end
  inherited CDS: TClientDataSet
    AfterOpen = CDSAfterOpen
  end
  object CDS3: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 637
    Top = 193
  end
  object DS3: TDataSource
    DataSet = CDS3
    Left = 666
    Top = 193
  end
  object ImageList2: TImageList
    Left = 608
    Top = 192
    Bitmap = {
      494C010107000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080FFFF0080FFFF0080FFFF0080FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FF
      FF00000000000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0000000000000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0000000000000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF00000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF00000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF00000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF00000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF00000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0000000000000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DEDEDE00DEDEDE00DEDEDE00DEDEDE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084FF000084FF000084FF000084FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400848484008484840084848400000000000000
      000000000000000000000000000000000000000000000000000000000000DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE000000000000000000000000000000000000000000000000000000000084FF
      000084FF000084FF000084FF000084FF000084FF000084FF000084FF000084FF
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400000000000000000000000000000000000000000000000000DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE000000000000000000000000000000000084FF000084FF
      000084FF000084FF000084FF000084FF000084FF000084FF000084FF000084FF
      000084FF000084FF0000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400000000000000000000000000DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE0000000000000000000000000084FF000084FF000084FF
      000084FF000084FF000084FF000084FF000084FF000084FF000084FF000084FF
      000084FF000084FF00000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400000000000000000000000000DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00000000000000000084FF000084FF000084FF
      000084FF000084FF000084FF000084FF000084FF000084FF000084FF000084FF
      000084FF000084FF000084FF000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400848484008484840000000000DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE000000000084FF000084FF000084FF000084FF
      000084FF000084FF000084FF000084FF000084FF000084FF000084FF000084FF
      000084FF000084FF000084FF0000000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400848484008484840000000000DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE0084FF000084FF000084FF000084FF
      000084FF000084FF000084FF000084FF000084FF000084FF000084FF000084FF
      000084FF000084FF000084FF000084FF00000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400848484008484840084848400DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE0084FF000084FF000084FF000084FF
      000084FF000084FF000084FF000084FF000084FF000084FF000084FF000084FF
      000084FF000084FF000084FF000084FF00000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400848484008484840084848400DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE0084FF000084FF000084FF000084FF
      000084FF000084FF000084FF000084FF000084FF000084FF000084FF000084FF
      000084FF000084FF000084FF000084FF00000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400848484008484840084848400DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE0084FF000084FF000084FF000084FF
      000084FF000084FF000084FF000084FF000084FF000084FF000084FF000084FF
      000084FF000084FF000084FF000084FF00000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400848484008484840084848400DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE000000000084FF000084FF000084FF000084FF
      000084FF000084FF000084FF000084FF000084FF000084FF000084FF000084FF
      000084FF000084FF000084FF0000000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400848484000000000000000000DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00000000000000000084FF000084FF000084FF
      000084FF000084FF000084FF000084FF000084FF000084FF000084FF000084FF
      000084FF000084FF000084FF000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400848484000000000000000000DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00000000000000000084FF000084FF000084FF
      000084FF000084FF000084FF000084FF000084FF000084FF000084FF000084FF
      000084FF000084FF000084FF000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE000000000000000000000000000000000084FF000084FF
      000084FF000084FF000084FF000084FF000084FF000084FF000084FF000084FF
      000084FF000084FF0000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400848484000000000000000000000000000000000000000000DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE0000000000000000000000000000000000000000000000000084FF
      000084FF000084FF000084FF000084FF000084FF000084FF000084FF000084FF
      000084FF00000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484000000000000000000000000000000000000000000000000000000
      000000000000DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084FF000084FF000084FF000084FF000084FF000084FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840084848400848484008484840084848400848484000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FC3FFFFFFFFF0000E00F000100010000
      C003000100010000800300010001000080010001000100000001000100010000
      0000000100010000000000010001000000000001000100000000000100010000
      000100010001000080010001000100008001000100010000C003000100010000
      E007000100010000F81F000100010000FC3FFC3FFC3FFC3FE00FE00FE00FE00F
      C003C003C003C003800380038003800380018001800180010001000100010001
      0000000000000000000000000000000000000000000000000000000000000000
      000100010001000180018001800180018001800180018001C003C003C003C003
      E007E007E007E007F81FF81FF81FF81F00000000000000000000000000000000
      000000000000}
  end
  object btnmenu: TPopupMenu
    AutoHotkeys = maManual
    Left = 700
    Top = 192
    object bm1: TMenuItem
      AutoHotkeys = maAutomatic
      Caption = #32160#33394
      OnClick = bm1Click
    end
    object bm2: TMenuItem
      Caption = #40643#33394
      OnClick = bm2Click
    end
    object bm3: TMenuItem
      Caption = #32043#32005#33394
      OnClick = bm3Click
    end
    object bm4: TMenuItem
      Caption = #38738#33394
      OnClick = bm4Click
    end
    object bm5: TMenuItem
      Caption = #27225#33394
      OnClick = bm5Click
    end
  end
  object DS4: TDataSource
    DataSet = CDS4
    Left = 666
    Top = 229
  end
  object CDS4: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 637
    Top = 229
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 720
    Top = 8
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer2Timer
    Left = 748
    Top = 8
  end
  object Timer3: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer3Timer
    Left = 776
    Top = 8
  end
  object CDS5: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterScroll = CDS5AfterScroll
    Left = 637
    Top = 277
  end
  object DS5: TDataSource
    DataSet = CDS5
    Left = 666
    Top = 277
  end
  object CDS6: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 637
    Top = 309
  end
  object DS6: TDataSource
    DataSet = CDS6
    Left = 666
    Top = 309
  end
  object SaveDialog1: TSaveDialog
    Left = 468
    Top = 260
  end
end
