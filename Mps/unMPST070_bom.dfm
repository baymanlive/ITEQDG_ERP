inherited FrmMPST070_bom: TFrmMPST070_bom
  Left = 190
  Top = 139
  Width = 925
  Height = 547
  Caption = 'BOM'#34920#26597#35426
  FormStyle = fsStayOnTop
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 807
    Top = 50
    Height = 468
    TabOrder = 1
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 50
    Width = 807
    Height = 468
    Align = alClient
    DataSource = DS
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
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'bmb03'
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
        FieldName = 'bmb06'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'bmb10'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'bmb08'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'useqty'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'totqty'
        Footer.ValueType = fvtSum
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 0
    Width = 917
    Height = 50
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object Label2: TLabel
      Left = 300
      Top = 19
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 'Label1'
    end
    object Label1: TLabel
      Left = 40
      Top = 19
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 'Label1'
    end
    object Edit1: TEdit
      Left = 76
      Top = 15
      Width = 177
      Height = 21
      Hint = #29289#21697#26009#34399
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 336
      Top = 15
      Width = 80
      Height = 21
      Hint = #29289#21697#26009#34399
      TabOrder = 1
    end
    object rgp: TRadioGroup
      Left = 468
      Top = 7
      Width = 221
      Height = 34
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'ITEQDG'
        'ITEQGZ')
      TabOrder = 2
    end
  end
  object DS: TDataSource
    Left = 56
    Top = 273
  end
end
