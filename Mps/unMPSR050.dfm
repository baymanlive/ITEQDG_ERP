inherited FrmMPSR050: TFrmMPSR050
  Caption = 'FrmMPSR050'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlBottom: TPanel
    object Label3: TLabel [4]
      Left = 255
      Top = 6
      Width = 107
      Height = 16
      Caption = #29983#29986#26085#26399'/'#37707#27425
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = #26032#32048#26126#39636
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Edit3: TEdit
      Left = 365
      Top = 3
      Width = 90
      Height = 24
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = #26032#32048#26126#39636
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      TabOrder = 2
    end
    object Edit4: TEdit
      Left = 460
      Top = 3
      Width = 30
      Height = 24
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = #26032#32048#26126#39636
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      TabOrder = 3
      Text = '0'
    end
  end
  inherited DBGridEh1: TDBGridEh
    OnDrawColumnCell = DBGridEh1DrawColumnCell
    OnGetCellParams = DBGridEh1GetCellParams
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'select'
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
        FieldName = 'wono'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderitem'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'materialno'
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
        FieldName = 'custno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'stealno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'materialno1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pnlsize1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pnlsize2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Premark'
        Footers = <>
      end>
  end
end
