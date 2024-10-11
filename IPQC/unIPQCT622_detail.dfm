inherited FrmIPQCT622_detail: TFrmIPQCT622_detail
  Width = 1100
  Height = 600
  Caption = #35519#33184#35352#37636
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 974
    Height = 561
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 974
    Height = 561
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object DBGridEh1: TDBGridEh
      Left = 0
      Top = 41
      Width = 974
      Height = 520
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
      Columns = <
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'ad'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'ver'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'lot'
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
          FieldName = 'sg1'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'sg1_std'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'sg2'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'sg2_std'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'sg3'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'sg3_std'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'niandu'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'ludaiqty'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 't1'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 't1_time'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 't2'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 't2_time'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 't3'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 't3_time'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 't4'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 't4_time'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'waste_pno'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 974
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object lbllot: TLabel
        Left = 52
        Top = 16
        Width = 24
        Height = 13
        Alignment = taRightJustify
        Caption = 'lbllot'
      end
      object lblerr: TLabel
        Tag = 1
        Left = 244
        Top = 16
        Width = 25
        Height = 13
        Caption = 'lblerr'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = #26032#32048#26126#39636
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object Edit1: TEdit
        Left = 80
        Top = 12
        Width = 150
        Height = 21
        TabOrder = 0
        OnChange = Edit1Change
      end
    end
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 108
    Top = 272
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 136
    Top = 272
  end
end
