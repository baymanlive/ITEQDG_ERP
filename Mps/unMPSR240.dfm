inherited FrmMPSR240: TFrmMPSR240
  Left = 379
  Top = 296
  Caption = 'FrmMPSR240'
  ClientHeight = 463
  ClientWidth = 1007
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 1007
  end
  inherited PnlBottom: TPanel
    Top = 433
    Width = 1007
    TabOrder = 3
    object Label3: TLabel [4]
      Left = 271
      Top = 6
      Width = 90
      Height = 16
      Alignment = taRightJustify
      Caption = #29983#29986#26085#26399'/'#31859
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
      TabOrder = 3
      Text = '0'
    end
  end
  inherited Panel1: TPanel
    Width = 1007
    TabOrder = 1
  end
  inherited DBGridEh1: TDBGridEh
    Left = 52
    Width = 955
    Height = 389
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
        FieldName = 'breadth'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'fiber'
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
        FieldName = 'pname'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'bw'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'tw'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rc'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rc_diff'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rf'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rf_diff'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pg1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pg1_diff'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pg2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'a1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'a2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'c'
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
    Height = 389
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 4
    object RG1: TRadioGroup
      Left = 2
      Top = 0
      Width = 48
      Height = 370
      TabOrder = 0
      OnClick = RG1Click
    end
  end
  inherited CDS: TClientDataSet
    IndexDefs = <
      item
        Name = 'CDSIndex1'
        DescFields = 'RCX'
        Fields = 'Machine;Sdate;Jitem;AD;FISno;RCX;Fiber;Simuver;Citem'
        Options = [ixDescending]
      end>
    IndexName = 'CDSIndex1'
    StoreDefs = True
  end
end
