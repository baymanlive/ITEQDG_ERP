inherited FrmQUII010: TFrmQUII010
  Left = 3
  Top = 2
  Caption = 'FrmQUII010'
  ClientHeight = 410
  ClientWidth = 622
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 622
    ButtonWidth = 60
    object btn_import: TToolButton
      Left = 594
      Top = 0
      Caption = 'btn_import'
      ImageIndex = 53
      OnClick = btn_importClick
    end
  end
  inherited PnlBottom: TPanel
    Top = 380
    Width = 622
  end
  inherited Panel1: TPanel
    Width = 622
  end
  inherited DBGridEh1: TDBGridEh
    Width = 622
    Height = 336
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Adhesive'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'mil'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'structure'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'stcode'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'laborcost'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'mancost'
        Footers = <>
      end>
  end
end
