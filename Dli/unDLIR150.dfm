inherited FrmDLIR150: TFrmDLIR150
  Caption = 'FrmDLIR150'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PCL: TPageControl
    inherited TabSheet1: TTabSheet
      inherited DBGridEh1: TDBGridEh
        OnTitleClick = DBGridEh1TitleClick
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
            FieldName = 'odate'
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
            FieldName = 'custno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custshort'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ad'
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
            FieldName = 'sizes'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'units'
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
            FieldName = 'qty1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'qty2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'outqty1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'outqty2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'remainqty1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'remainqty2'
            Footers = <>
          end>
      end
    end
    object TabSheet2: TTabSheet
      Caption = #36948#25104#29575
      ImageIndex = 1
      DesignSize = (
        955
        423)
      object Label3: TLabel
        Left = 4
        Top = 8
        Width = 32
        Height = 13
        Caption = 'Label3'
      end
      object Label4: TLabel
        Left = 520
        Top = 8
        Width = 32
        Height = 13
        Caption = 'Label4'
      end
      object Lv1: TListView
        Left = 4
        Top = 28
        Width = 500
        Height = 380
        Hint = #23458#25142
        Anchors = [akLeft, akTop, akBottom]
        Columns = <>
        GridLines = True
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
      object Lv2: TListView
        Left = 520
        Top = 28
        Width = 440
        Height = 380
        Hint = #23458#25142
        Anchors = [akLeft, akTop, akBottom]
        Columns = <>
        GridLines = True
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 1
        ViewStyle = vsReport
      end
    end
  end
end
