inherited FrmMPSR030: TFrmMPSR030
  Left = 566
  Top = 279
  Caption = 'FrmMPSR030'
  ClientHeight = 569
  ClientWidth = 1064
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 1064
  end
  inherited PnlBottom: TPanel
    Top = 539
    Width = 1064
    TabOrder = 3
    object Label3: TLabel [4]
      Left = 255
      Top = 6
      Width = 170
      Height = 16
      AutoSize = False
      Caption = #29983#29986#26085#26399'/'#37707#27425'/'#32317#37707#25976
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = #26032#32048#26126#39636
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel [5]
      Left = 696
      Top = 6
      Width = 34
      Height = 16
      Caption = #25976#37327
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = #26032#32048#26126#39636
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Edit3: TEdit
      Left = 432
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
      Left = 527
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
    object Edit5: TEdit
      Left = 731
      Top = 3
      Width = 50
      Height = 24
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = #26032#32048#26126#39636
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      TabOrder = 4
      Text = '0'
    end
    object Edit6: TEdit
      Left = 786
      Top = 3
      Width = 50
      Height = 24
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = #26032#32048#26126#39636
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      TabOrder = 5
      Text = '0'
    end
    object edtStealSum: TEdit
      Left = 561
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
      TabOrder = 6
      Text = '0'
      Visible = False
    end
  end
  inherited Panel1: TPanel
    Width = 1064
    TabOrder = 1
  end
  inherited DBGridEh1: TDBGridEh
    Left = 52
    Width = 1012
    Height = 495
    TabOrder = 2
    OnGetCellParams = DBGridEh1GetCellParams
    Columns = <
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
        FieldName = 'custom'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custom2'
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
        FieldName = 'premark'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'premark2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'premark3'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderqty'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderno2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderitem2'
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
        FieldName = 'edate'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'adhesive'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'thickness'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'copper'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'supplier'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sizes'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'co_str'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'remain_ordqty'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sfb09'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custno2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custname2'
        Footers = <>
      end>
  end
  object Panel2: TPanel [4]
    Left = 0
    Top = 44
    Width = 52
    Height = 495
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 4
    object RG1: TRadioGroup
      Left = 2
      Top = 0
      Width = 48
      Height = 270
      TabOrder = 0
      OnClick = RG1Click
    end
  end
end
