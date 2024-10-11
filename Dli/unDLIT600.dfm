inherited FrmDLIT600: TFrmDLIT600
  Left = 339
  Top = 186
  Caption = 'FrmDLIT600'
  ClientHeight = 586
  ClientWidth = 1075
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 1075
    inherited btn_print: TToolButton
      Visible = False
    end
    inherited btn_query: TToolButton
      Visible = False
    end
  end
  inherited PnlBottom: TPanel
    Top = 556
    Width = 1075
  end
  inherited Panel1: TPanel
    Width = 1075
  end
  object PCL: TPageControl [3]
    Left = 0
    Top = 44
    Width = 965
    Height = 512
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = #35330#21934#36039#26009
      object DBGridEh1: TDBGridEh
        Left = 0
        Top = 0
        Width = 957
        Height = 484
        Align = alClient
        DataSource = DS
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
            FieldName = 'custno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'c_pno'
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
            FieldName = 'qty'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'price'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oao04'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oao05'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oao06'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #23458#25142#21697#21517#27298#26680
      ImageIndex = 2
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 845
        Height = 423
        Align = alClient
        TabOrder = 0
      end
    end
  end
  object PnlRight: TPanel [4]
    Left = 965
    Top = 44
    Width = 110
    Height = 512
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object btn_dlit600B: TBitBtn
      Tag = 2
      Left = 10
      Top = 10
      Width = 90
      Height = 25
      Hint = #21295#20837#35330#21934#36039#26009
      Caption = #21295#20837#35330#21934#36039#26009
      TabOrder = 0
      OnClick = btn_dlit600BClick
      NumGlyphs = 2
    end
    object btn_dlit600C: TBitBtn
      Tag = 3
      Left = 10
      Top = 40
      Width = 90
      Height = 25
      Hint = #27298#26597#35330#21934#23458#25142#21697#21517#27491#30906#24615
      Caption = #27298#26597#35330#21934#21697#21517
      TabOrder = 1
      OnClick = btn_dlit600CClick
      NumGlyphs = 2
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'xls'
    Filter = #25152#26377'Excel'#27284#26696'(*.xls;*.xlsx)|*.xls;*.xlsx'
    Left = 922
    Top = 377
  end
end
