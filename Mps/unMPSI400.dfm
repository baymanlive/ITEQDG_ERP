inherited FrmMPSI400: TFrmMPSI400
  Caption = 'FrmMPSI400'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    ButtonWidth = 70
    object btn_mpsi400: TToolButton
      Left = 594
      Top = 0
      AutoSize = True
      Caption = 'btn_mpsi400'
      ImageIndex = 61
      OnClick = btn_mpsi400Click
    end
  end
  inherited DBGridEh1: TDBGridEh
    Columns = <
      item
        DynProps = <>
        DropDownRows = 14
        EditButtons = <>
        FieldName = 'pno'
        Footers = <>
        Width = 80
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'lot'
        Footers = <>
        Width = 80
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'remark'
        Footers = <>
      end>
  end
end
