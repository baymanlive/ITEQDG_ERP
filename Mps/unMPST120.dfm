inherited FrmMPST120: TFrmMPST120
  Left = 370
  Top = 136
  Caption = 'FrmMPST120'
  ClientHeight = 614
  ClientWidth = 1061
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 1061
    ButtonWidth = 72
    object btn_mpst120B: TToolButton
      Left = 364
      Top = 0
      AutoSize = True
      Caption = #20839#37559#21934#21029
      ImageIndex = 36
      OnClick = btn_mpst120BClick
    end
    object btn_mpst120A: TToolButton
      Left = 427
      Top = 0
      AutoSize = True
      Caption = #29986#29983#35531#36092#21934
      ImageIndex = 50
      OnClick = btn_mpst120AClick
    end
  end
  inherited PnlBottom: TPanel
    Top = 584
    Width = 1061
    Enabled = True
    inherited Edit1: TEdit
      Enabled = False
    end
    inherited Edit2: TEdit
      Enabled = False
    end
    object chkAll: TCheckBox
      Left = 328
      Top = 4
      Width = 97
      Height = 17
      Caption = 'chkAll'
      TabOrder = 2
      OnClick = chkAllClick
    end
  end
  inherited Panel1: TPanel
    Width = 1061
  end
  inherited DBGridEh1: TDBGridEh
    Width = 951
    Height = 540
    ReadOnly = False
    OnCellClick = DBGridEh1CellClick
    OnGetCellParams = DBGridEh1GetCellParams
    OnKeyDown = DBGridEh1KeyDown
    OnTitleClick = DBGridEh1TitleClick
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'select'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custno'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custshort'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderdate'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderno'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderitem'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ta_oea08'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pno'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pname'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sizes'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'c_orderno'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'oeb11'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ta_oeb30'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'c_sizes'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'remark'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'longitude'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'latitude'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'struct'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qty1'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qty2'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qty3'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'units'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qty'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'adate'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'p_pno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'p_qty'
        Footers = <>
      end
      item
        Alignment = taCenter
        DynProps = <>
        EditButtons = <>
        FieldName = 'iscreate'
        Footers = <>
        ReadOnly = True
      end
      item
        Alignment = taCenter
        DynProps = <>
        EditButtons = <>
        FieldName = 'isdomestic'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'cno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Purcno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Pursno'
        Footers = <>
      end>
  end
  object PnlRight: TPanel [4]
    Left = 951
    Top = 44
    Width = 110
    Height = 540
    Hint = '  '
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object btn_mpsr120A: TBitBtn
      Left = 5
      Top = 10
      Width = 100
      Height = 25
      Caption = #26356#26032#24235#23384#37327
      TabOrder = 0
      OnClick = btn_mpsr120AClick
      NumGlyphs = 2
    end
    object btn_mpsr120B: TBitBtn
      Left = 5
      Top = 40
      Width = 100
      Height = 25
      Caption = #26356#26032#26410#20132#25976#37327
      TabOrder = 1
      OnClick = btn_mpsr120BClick
      NumGlyphs = 2
    end
    object btn_mpsr120C: TBitBtn
      Left = 5
      Top = 70
      Width = 100
      Height = 25
      Caption = #24235#23384#33287#26410#20132#29376#27841
      TabOrder = 2
      OnClick = btn_mpsr120CClick
      NumGlyphs = 2
    end
    object Memo1: TMemo
      Left = 8
      Top = 392
      Width = 95
      Height = 137
      Lines.Strings = (
        'Memo1')
      TabOrder = 3
      Visible = False
    end
    object btn_mpsr120D: TBitBtn
      Left = 5
      Top = 99
      Width = 100
      Height = 25
      Caption = #26356#26032#35531#36092#25976#37327
      TabOrder = 4
      OnClick = btn_mpsr120DClick
      NumGlyphs = 2
    end
  end
  inherited CDS: TClientDataSet
    BeforeInsert = CDSBeforeInsert
    AfterPost = CDSAfterPost
    BeforeDelete = CDSBeforeDelete
  end
end
