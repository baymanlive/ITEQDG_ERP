inherited FrmMPSI380: TFrmMPSI380
  Caption = 'FrmMPSI380'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    object btn_mpsi380: TToolButton
      Left = 594
      Top = 0
      AutoSize = True
      Caption = #35079#35069#29986#33021
      ImageIndex = 57
      OnClick = btn_mpsi380Click
    end
  end
  inherited DBGridEh1: TDBGridEh
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Sdate'
        Footers = <>
        Width = 80
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Stealno'
        Footers = <>
        Width = 60
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Thickness'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Qty'
        Footers = <>
        Width = 50
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Not_use'
        Footers = <>
      end>
  end
end
