inherited FrmMPST080: TFrmMPST080
  Caption = 'FrmMPST080'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    object btn_mpst080A: TToolButton
      Left = 594
      Top = 0
      AutoSize = True
      Caption = #26356#26032#35336#25976
      ImageIndex = 58
      OnClick = btn_mpst080AClick
    end
    object btn_mpst080B: TToolButton
      Left = 657
      Top = 0
      AutoSize = True
      Caption = #25490#31243#36039#26009
      ImageIndex = 32
      OnClick = btn_mpst080bClick
    end
  end
  inherited pnl: TPanel
    inherited PCL2: TPageControl
      inherited TabSheet2: TTabSheet
        inherited DBGridEh2: TDBGridEh
          Columns = <
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Lot1'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Lot2'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Num'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'State'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Remark'
              Footers = <>
            end>
        end
      end
    end
    inherited PCL: TPageControl
      inherited TabSheet1: TTabSheet
        inherited DBGridEh1: TDBGridEh
          Columns = <
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Lot'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Machine'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'FmSdate'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'FmBoiler'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Stealno'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'MaxNum'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'ToSdate'
              Footers = <>
              ReadOnly = True
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'ToBoiler'
              Footers = <>
              ReadOnly = True
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Num'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Not_use'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Remark'
              Footers = <>
            end>
        end
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 776
    Top = 12
  end
end
