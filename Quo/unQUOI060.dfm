inherited FrmQUOI060: TFrmQUOI060
  Left = 601
  Top = 257
  Caption = 'FrmQUOI060'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    ButtonWidth = 60
    object btn_import: TToolButton
      Left = 594
      Top = 0
      Caption = 'btn_import'
      ImageIndex = 53
      OnClick = btn_importClick
    end
  end
  inherited DBGridEh1: TDBGridEh
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Adhesive'
        Footers = <>
        Title.TitleButton = True
        Width = 114
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'fiber'
        Footers = <>
        Title.TitleButton = True
        Width = 93
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'width'
        Footers = <>
        Title.TitleButton = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'roll'
        Footers = <>
        Title.TitleButton = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'glue'
        Footers = <>
        Title.TitleButton = True
        Visible = False
        Width = 61
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sqft'
        Footers = <>
        Title.TitleButton = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'laborcost'
        Footers = <>
        Title.TitleButton = True
        Width = 83
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'mancost'
        Footers = <>
        Title.TitleButton = True
        Width = 77
      end>
  end
end
