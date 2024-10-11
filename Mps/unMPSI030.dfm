inherited FrmMPSI030: TFrmMPSI030
  Caption = 'FrmMPSI030'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    ButtonWidth = 70
    object btn_mpsi030: TToolButton
      Left = 594
      Top = 0
      AutoSize = True
      Caption = 'btn_mpsi030'
      ImageIndex = 57
      OnClick = btn_mpsi030Click
    end
  end
  inherited DBGridEh1: TDBGridEh
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'machine'
        Footers = <>
        Title.Caption = #27231#21488#20195#30908
        Width = 80
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'wdate'
        Footers = <>
        Title.Caption = #24037#20316#26085#26399
        Width = 80
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Boiler_qty'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'nu_capacity'
        Footers = <>
        Title.Caption = #27491#24120#29986#33021'('#25976#37327')'
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'mu_capacity'
        Footers = <>
        Title.Caption = #20445#39178#29986#33021'('#25976#37327')'
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'eu_capacity'
        Footers = <>
        Title.Caption = #25563#33184#29986#33021'('#25976#37327')'
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'fu_capacity'
        Footers = <>
        Title.Caption = #32173#20462#29986#33021'('#25976#37327')'
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'nh_capacity'
        Footers = <>
        Title.Caption = #27491#24120#29986#33021'('#23567#26178')'
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'mh_capacity'
        Footers = <>
        Title.Caption = #20445#39178#29986#33021'('#23567#26178')'
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'eh_capacity'
        Footers = <>
        Title.Caption = #25563#33184#29986#33021'('#23567#26178')'
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'fh_capacity'
        Footers = <>
        Title.Caption = #32173#20462#29986#33021'('#23567#26178')'
        Width = 100
      end>
  end
end
