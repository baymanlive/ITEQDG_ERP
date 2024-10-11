inherited FrmDLIR140: TFrmDLIR140
  Caption = 'FrmDLIR140'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlBottom: TPanel
    object lt: TLabel [4]
      Left = 276
      Top = 8
      Width = 6
      Height = 13
      Caption = 'lt'
    end
  end
  inherited PCL: TPageControl
    inherited TabSheet1: TTabSheet
      inherited DBGridEh1: TDBGridEh
        OnGetCellParams = DBGridEh1GetCellParams
        OnTitleClick = DBGridEh1TitleClick
        Columns = <
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
            FieldName = 'c_orderno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'remark'
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
            FieldName = 'custdate'
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
            FieldName = 'adate'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'cdate'
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
            FieldName = 'indate'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'outqty'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'outqty2'
            Footers = <>
          end
          item
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            FieldName = 'overday'
            Footers = <>
          end
          item
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            FieldName = 'leadtime'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'reqlt'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ltType'
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
        Left = 380
        Top = 8
        Width = 32
        Height = 13
        Caption = 'Label4'
      end
      object Label5: TLabel
        Left = 695
        Top = 8
        Width = 32
        Height = 13
        Caption = 'Label5'
      end
      object Lv1: TListView
        Left = 4
        Top = 28
        Width = 370
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
        Left = 380
        Top = 28
        Width = 310
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
      object Lv3: TListView
        Left = 695
        Top = 28
        Width = 258
        Height = 380
        Hint = #23458#25142
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <>
        GridLines = True
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 2
        ViewStyle = vsReport
      end
    end
  end
end
