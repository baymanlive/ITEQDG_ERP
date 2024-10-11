inherited FrmDLII410: TFrmDLII410
  Caption = 'FrmDLII410'
  PixelsPerInch = 96
  TextHeight = 13
  inherited DBGridEh1: TDBGridEh
    Width = 850
    OnEditButtonClick = DBGridEh1EditButtonClick
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'indate'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'stime'
        Footers = <>
        Width = 83
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pathname'
        Footers = <>
        Width = 82
      end
      item
        ButtonStyle = cbsEllipsis
        DynProps = <>
        EditButtons = <>
        FieldName = 'custshort'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'cnt'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'kbcnt'
        Footers = <>
      end>
  end
  object PnlRight: TPanel [4]
    Left = 850
    Top = 44
    Width = 113
    Height = 451
    Align = alRight
    BevelInner = bvSpace
    BevelOuter = bvLowered
    TabOrder = 4
    object btn_dlii410A: TBitBtn
      Tag = 2
      Left = 10
      Top = 10
      Width = 90
      Height = 25
      Hint = #36984#25799#20986#36008#25490#31243#26085#26399#29986#29983#20986#36554#35336#21010#34920
      Caption = #20986#36554#35336#21010#34920
      TabOrder = 0
      OnClick = btn_dlii410AClick
      NumGlyphs = 2
    end
    object btn_dlii410B: TBitBtn
      Tag = 3
      Left = 10
      Top = 40
      Width = 90
      Height = 25
      Hint = #25490#31243#26126#32048
      Caption = #25490#31243#26126#32048
      TabOrder = 1
      OnClick = btn_dlii410BClick
      NumGlyphs = 2
    end
  end
end
