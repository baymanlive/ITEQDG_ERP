inherited FrmDLII020_AC109: TFrmDLII020_AC109
  Width = 1000
  Height = 528
  Caption = #33775#36890#31805#25910#21934
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 874
    Height = 489
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 874
    Height = 489
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 874
      Height = 40
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 0
      object lblsaleno: TLabel
        Left = 54
        Top = 13
        Width = 42
        Height = 13
        Alignment = taRightJustify
        Caption = 'lblsaleno'
      end
      object Edit1: TEdit
        Left = 100
        Top = 10
        Width = 121
        Height = 21
        TabOrder = 0
      end
      object btn_query: TBitBtn
        Left = 224
        Top = 7
        Width = 55
        Height = 25
        Caption = 'btn_query'
        TabOrder = 1
        OnClick = btn_queryClick
      end
    end
    object DBGridEh1: TDBGridEh
      Left = 0
      Top = 40
      Width = 874
      Height = 200
      Align = alTop
      DataSource = DS
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
          FieldName = 'oga01'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'oga02'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'oga04'
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
          FieldName = 'ogb03'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'ogb04'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'ima02'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'ima021'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'oea10'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'oeb11'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'ta_oeb10'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'ogb12'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'ogb14t'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'ima18'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 240
      Width = 874
      Height = 249
      Align = alClient
      BevelOuter = bvNone
      Enabled = False
      TabOrder = 2
      object oea10: TLabel
        Left = 71
        Top = 18
        Width = 28
        Height = 13
        Alignment = taRightJustify
        Caption = 'oea10'
      end
      object oeb11: TLabel
        Left = 70
        Top = 48
        Width = 29
        Height = 13
        Alignment = taRightJustify
        Caption = 'oeb11'
      end
      object ta_oeb10: TLabel
        Left = 56
        Top = 78
        Width = 43
        Height = 13
        Alignment = taRightJustify
        Caption = 'ta_oeb10'
      end
      object ogb12: TLabel
        Left = 69
        Top = 108
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'ogb12'
      end
      object sfqty: TLabel
        Left = 285
        Top = 138
        Width = 24
        Height = 13
        Alignment = taRightJustify
        Caption = 'sfqty'
      end
      object ogb14t: TLabel
        Left = 66
        Top = 168
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'ogb14t'
      end
      object ima18: TLabel
        Left = 279
        Top = 168
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'ima18'
      end
      object nw: TLabel
        Left = 84
        Top = 198
        Width = 15
        Height = 13
        Alignment = taRightJustify
        Caption = 'nw'
      end
      object gw: TLabel
        Left = 294
        Top = 198
        Width = 15
        Height = 13
        Alignment = taRightJustify
        Caption = 'gw'
      end
      object qty: TLabel
        Left = 84
        Top = 138
        Width = 15
        Height = 13
        Alignment = taRightJustify
        Caption = 'qty'
      end
      object oea10_1: TLabel
        Left = 521
        Top = 18
        Width = 28
        Height = 13
        Alignment = taRightJustify
        Caption = 'oea10'
      end
      object oeb11_1: TLabel
        Left = 520
        Top = 48
        Width = 29
        Height = 13
        Alignment = taRightJustify
        Caption = 'oeb11'
      end
      object ta_oeb10_1: TLabel
        Left = 506
        Top = 78
        Width = 43
        Height = 13
        Alignment = taRightJustify
        Caption = 'ta_oeb10'
      end
      object ogb12_1: TLabel
        Left = 507
        Top = 108
        Width = 42
        Height = 13
        Alignment = taRightJustify
        Caption = 'ogb12_1'
      end
      object sfqty_1: TLabel
        Left = 723
        Top = 138
        Width = 36
        Height = 13
        Alignment = taRightJustify
        Caption = 'sfqty_1'
      end
      object ogb14t_1: TLabel
        Left = 504
        Top = 168
        Width = 45
        Height = 13
        Alignment = taRightJustify
        Caption = 'ogb14t_1'
      end
      object ima18_1: TLabel
        Left = 717
        Top = 168
        Width = 42
        Height = 13
        Alignment = taRightJustify
        Caption = 'ima18_1'
      end
      object nw_1: TLabel
        Left = 522
        Top = 198
        Width = 27
        Height = 13
        Alignment = taRightJustify
        Caption = 'nw_1'
      end
      object gw_1: TLabel
        Left = 732
        Top = 198
        Width = 27
        Height = 13
        Alignment = taRightJustify
        Caption = 'gw_1'
      end
      object qty_1: TLabel
        Left = 522
        Top = 138
        Width = 27
        Height = 13
        Alignment = taRightJustify
        Caption = 'qty_1'
      end
      object Bevel1: TBevel
        Left = 447
        Top = 15
        Width = 8
        Height = 230
        Shape = bsRightLine
      end
      object lblsf1: TLabel
        Tag = 1
        Left = 402
        Top = 140
        Width = 27
        Height = 13
        Caption = 'lblsf1'
      end
      object lblsf2: TLabel
        Tag = 1
        Left = 192
        Top = 138
        Width = 27
        Height = 13
        Caption = 'lblsf2'
      end
      object lblsf3: TLabel
        Tag = 1
        Left = 642
        Top = 138
        Width = 27
        Height = 13
        Caption = 'lblsf3'
      end
      object lblsf4: TLabel
        Tag = 1
        Left = 852
        Top = 140
        Width = 27
        Height = 13
        Caption = 'lblsf4'
      end
      object pnlrate: TLabel
        Left = 727
        Top = 108
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = 'pnlrate'
      end
      object DBEdit1: TDBEdit
        Left = 100
        Top = 15
        Width = 300
        Height = 21
        Color = clInfoBk
        DataField = 'oea10'
        DataSource = DS
        ReadOnly = True
        TabOrder = 0
      end
      object DBEdit2: TDBEdit
        Left = 100
        Top = 45
        Width = 300
        Height = 21
        Color = clInfoBk
        DataField = 'oeb11'
        DataSource = DS
        ReadOnly = True
        TabOrder = 1
      end
      object DBEdit3: TDBEdit
        Left = 100
        Top = 75
        Width = 300
        Height = 21
        Color = clInfoBk
        DataField = 'ta_oeb10'
        DataSource = DS
        ReadOnly = True
        TabOrder = 2
      end
      object DBEdit4: TDBEdit
        Left = 100
        Top = 105
        Width = 90
        Height = 21
        Color = clInfoBk
        DataField = 'ogb12'
        DataSource = DS
        ReadOnly = True
        TabOrder = 3
      end
      object DBEdit5: TDBEdit
        Left = 310
        Top = 135
        Width = 90
        Height = 21
        Color = clInfoBk
        DataField = 'sfqty'
        DataSource = DS
        ReadOnly = True
        TabOrder = 5
      end
      object DBEdit6: TDBEdit
        Left = 100
        Top = 165
        Width = 90
        Height = 21
        Color = clInfoBk
        DataField = 'ogb14t'
        DataSource = DS
        ReadOnly = True
        TabOrder = 6
      end
      object DBEdit7: TDBEdit
        Left = 310
        Top = 165
        Width = 90
        Height = 21
        Color = clInfoBk
        DataField = 'ima18'
        DataSource = DS
        ReadOnly = True
        TabOrder = 7
      end
      object DBEdit8: TDBEdit
        Left = 100
        Top = 195
        Width = 90
        Height = 21
        Color = clInfoBk
        DataField = 'nw'
        DataSource = DS
        ReadOnly = True
        TabOrder = 8
      end
      object DBEdit9: TDBEdit
        Left = 310
        Top = 195
        Width = 90
        Height = 21
        Color = clInfoBk
        DataField = 'gw'
        DataSource = DS
        ReadOnly = True
        TabOrder = 9
      end
      object DBEdit10: TDBEdit
        Left = 100
        Top = 135
        Width = 90
        Height = 21
        Color = clInfoBk
        DataField = 'qty'
        DataSource = DS
        ReadOnly = True
        TabOrder = 4
      end
      object DBEdit11: TDBEdit
        Left = 550
        Top = 15
        Width = 300
        Height = 21
        DataField = 'oea10_1'
        DataSource = DS
        TabOrder = 10
      end
      object DBEdit12: TDBEdit
        Left = 550
        Top = 45
        Width = 300
        Height = 21
        DataField = 'oeb11_1'
        DataSource = DS
        TabOrder = 11
      end
      object DBEdit13: TDBEdit
        Left = 550
        Top = 75
        Width = 300
        Height = 21
        DataField = 'ta_oeb10_1'
        DataSource = DS
        TabOrder = 12
      end
      object DBEdit14: TDBEdit
        Left = 550
        Top = 105
        Width = 90
        Height = 21
        DataField = 'ogb12_1'
        DataSource = DS
        TabOrder = 13
      end
      object DBEdit15: TDBEdit
        Left = 760
        Top = 135
        Width = 90
        Height = 21
        DataField = 'sfqty_1'
        DataSource = DS
        TabOrder = 16
      end
      object DBEdit16: TDBEdit
        Left = 550
        Top = 165
        Width = 90
        Height = 21
        DataField = 'ogb14t_1'
        DataSource = DS
        TabOrder = 17
      end
      object DBEdit17: TDBEdit
        Left = 760
        Top = 165
        Width = 90
        Height = 21
        DataField = 'ima18_1'
        DataSource = DS
        TabOrder = 18
      end
      object DBEdit18: TDBEdit
        Left = 550
        Top = 195
        Width = 90
        Height = 21
        DataField = 'nw_1'
        DataSource = DS
        TabOrder = 19
      end
      object DBEdit19: TDBEdit
        Left = 760
        Top = 195
        Width = 90
        Height = 21
        DataField = 'gw_1'
        DataSource = DS
        TabOrder = 20
      end
      object DBEdit20: TDBEdit
        Left = 550
        Top = 135
        Width = 90
        Height = 21
        DataField = 'qty_1'
        DataSource = DS
        TabOrder = 15
      end
      object DBEdit21: TDBEdit
        Left = 760
        Top = 105
        Width = 90
        Height = 21
        DataField = 'pnlrate'
        DataSource = DS
        TabOrder = 14
      end
    end
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 104
    Top = 116
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterOpen = CDSAfterOpen
    Left = 76
    Top = 116
  end
end
