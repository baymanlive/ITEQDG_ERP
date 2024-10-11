inherited FrmMPSI130: TFrmMPSI130
  Caption = 'FrmMPSI130'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    ButtonWidth = 70
    object btn_mpsi130: TToolButton
      Left = 594
      Top = 0
      AutoSize = True
      Caption = 'btn_mpsi130'
      ImageIndex = 58
      OnClick = btn_mpsi130Click
    end
  end
  inherited DBGridEh1: TDBGridEh
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'code'
        Footers = <>
        Title.Caption = #20195#30908
        Width = 80
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Machine'
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
        FieldName = 'Strip_lower'
        Footers = <>
        Title.Caption = #26781#25976'('#19979')'
        Width = 80
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Strip_upper'
        Footers = <>
        Title.Caption = #26781#25976'('#19978')'
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Adhesive'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Remark'
        Footers = <>
      end>
  end
end
