inherited FrmDLIR130: TFrmDLIR130
  Caption = 'FrmDLIR130'
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited PCL: TPageControl
    inherited TabSheet1: TTabSheet
      inherited DBGridEh1: TDBGridEh
        FooterRowCount = 1
        SumList.Active = True
        TitleParams.MultiTitle = True
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'AD'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'CCLQty1'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'CCLQty2'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'CCLQty3'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'CCLAmt1'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'CCLAmt2'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'CCLAmt3'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'PPQty1'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'PPQty2'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'PPQty3'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'PPAmt1'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'PPAmt2'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'PPAmt3'
            Footer.ValueType = fvtSum
            Footers = <>
          end>
      end
    end
    object TabSheet2: TTabSheet
      Caption = #38928#20272#30446#27161#12289#23492#21806#20489#35373#23450
      ImageIndex = 1
      DesignSize = (
        955
        423)
      object Label3: TLabel
        Left = 81
        Top = 13
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = 'Label3'
      end
      object DBGridEh2: TDBGridEh
        Left = 4
        Top = 36
        Width = 1001
        Height = 371
        Anchors = [akLeft, akTop, akRight, akBottom]
        DataSource = DS2
        DynProps = <>
        FooterRowCount = 1
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        SumList.Active = True
        TabOrder = 0
        TitleParams.MultiTitle = True
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Ad'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'CCLQty'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'CCLAmt'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'PPQty'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'PPAmt'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'JS_CCLQty'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'JS_CCLAmt'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'JS_PPQty'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'JS_PPAmt'
            Footer.ValueType = fvtSum
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Edit3: TEdit
        Left = 115
        Top = 10
        Width = 100
        Height = 21
        TabOrder = 1
        Text = 'Edit3'
      end
      object BitBtn1: TBitBtn
        Left = 216
        Top = 6
        Width = 50
        Height = 25
        Hint = #26597#35426#36039#26009','#33509#19981#23384#22312#23559#33258#21205#29986#29983
        Caption = #26597#35426
        TabOrder = 2
        OnClick = BitBtn1Click
      end
      object btn_copy: TBitBtn
        Left = 268
        Top = 6
        Width = 50
        Height = 25
        Hint = #35079#35069#27492#26376#20221#33267'12'#26376','#24050#23384#22312#30340#23559#34987#26367#25563
        Caption = #35079#35069
        TabOrder = 3
        OnClick = btn_copyClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = #21295#29575#35373#23450
      ImageIndex = 2
      DesignSize = (
        955
        423)
      object Label4: TLabel
        Left = 81
        Top = 13
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = 'Label3'
      end
      object DBGridEh3: TDBGridEh
        Left = 4
        Top = 36
        Width = 1001
        Height = 371
        Anchors = [akLeft, akTop, akRight, akBottom]
        DataSource = DS3
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
            FieldName = 'yyyymm'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'usd_rmb'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Edit4: TEdit
        Left = 115
        Top = 10
        Width = 100
        Height = 21
        TabOrder = 1
        Text = 'Edit4'
      end
      object BitBtn2: TBitBtn
        Left = 216
        Top = 6
        Width = 50
        Height = 25
        Hint = #26597#35426#36039#26009','#33509#19981#23384#22312#23559#33258#21205#29986#29983
        Caption = #26597#35426
        TabOrder = 2
        OnClick = BitBtn2Click
      end
    end
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = CDS2BeforeInsert
    AfterPost = CDS2AfterPost
    Left = 777
    Top = 409
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 806
    Top = 409
  end
  object CDS3: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = CDS3BeforeInsert
    AfterPost = CDS3AfterPost
    Left = 777
    Top = 437
  end
  object DS3: TDataSource
    DataSet = CDS3
    Left = 806
    Top = 437
  end
end
