inherited FrmDLII430: TFrmDLII430
  Caption = 'FrmDLII430'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnl: TPanel
    Width = 853
    inherited PCL2: TPageControl
      Width = 853
      inherited TabSheet2: TTabSheet
        Caption = #26410#23436#25104#21934#25818
        inherited DBGridEh2: TDBGridEh
          Width = 845
          Hint = #26410#23436#25104#21934#25818
          Columns = <
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Sno'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Custno'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Custshort'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Orderno'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Orderitem'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Pno'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Notcount1'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Units'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Remark'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Delcount1'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Coccount1'
              Footers = <>
            end>
        end
      end
    end
    inherited PCL: TPageControl
      Width = 853
      inherited TabSheet1: TTabSheet
        Caption = #27966#36554#36039#26009
        inherited DBGridEh1: TDBGridEh
          Width = 845
          Hint = #27966#36554#36039#26009','#40643#33394#27396#20301#19981#21487#26356#25913
          OnEditButtonClick = DBGridEh1EditButtonClick
          Columns = <
            item
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'Id'
              Footers = <>
              ReadOnly = True
            end
            item
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'Cno'
              Footers = <>
              ReadOnly = True
            end
            item
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'Indate'
              Footers = <>
              ReadOnly = True
            end
            item
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'Stime'
              Footers = <>
              ReadOnly = True
            end
            item
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'Pathname'
              Footers = <>
              ReadOnly = True
            end
            item
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'Custno'
              Footers = <>
              ReadOnly = True
            end
            item
              ButtonStyle = cbsEllipsis
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'Custshort'
              Footers = <>
              ReadOnly = True
            end
            item
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'TotCnt'
              Footers = <>
              ReadOnly = True
            end
            item
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'FinCnt'
              Footers = <>
              ReadOnly = True
            end
            item
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'CCLSH1'
              Footers = <>
              ReadOnly = True
            end
            item
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'CCLSH2'
              Footers = <>
              ReadOnly = True
            end
            item
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'CCLPNL1'
              Footers = <>
              ReadOnly = True
            end
            item
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'CCLPNL2'
              Footers = <>
              ReadOnly = True
            end
            item
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'PPRL1'
              Footers = <>
              ReadOnly = True
            end
            item
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'PPRL2'
              Footers = <>
              ReadOnly = True
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'CCLKBCnt'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'PPKBCnt'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'JiaoKBCnt'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'SlotCnt'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Transport'
              Footers = <>
              PickList.Strings = (
                #29289#27969#23560#36554
                #29289#27969#24182#36554
                #25955#36008#25340#36554
                #25955#36008#38520#36939
                #25955#36008#31354#36939
                #24288#31199#30382#21345)
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'PriceType'
              Footers = <>
              PickList.Strings = (
                '0.5'#22136#23560#36554
                '1.5'#22136#23560#36554
                '1.5'#22136#24182#36554
                '3'#22136#23560#36554
                '3'#22136#24182#36554
                '5'#22136#23560#36554
                '5'#22136#24182#36554
                '8'#22136#23560#36554
                '8'#22136#24182#36554
                '10'#22136#23560#36554
                '10'#22136#24182#36554
                #25955#36008#38520#36939
                #25955#36939#31354#36939
                #24288#36554)
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'HighSpeed'
              Footers = <>
            end
            item
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'State'
              Footers = <>
              ReadOnly = True
            end
            item
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'Carno'
              Footers = <>
              ReadOnly = True
            end
            item
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'StdSlotCnt'
              Footers = <>
              ReadOnly = True
            end>
        end
      end
    end
  end
  object PnlRight: TPanel [4]
    Left = 853
    Top = 44
    Width = 110
    Height = 451
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object btn_dlii430A: TBitBtn
      Tag = 2
      Left = 10
      Top = 10
      Width = 90
      Height = 25
      Hint = #26681#25818#20986#36554#35336#21010#34920#29986#29983#36554#27425
      Caption = #29986#29983#36554#27425
      TabOrder = 1
      OnClick = btn_dlii430AClick
      NumGlyphs = 2
    end
    object btn_dlii430B: TBitBtn
      Tag = 2
      Left = 10
      Top = 40
      Width = 90
      Height = 25
      Hint = #36984#25799#27966#36554#26085#26399#26356#26032#25171#21934#25976
      Caption = #26356#26032#25171#21934#25976
      TabOrder = 3
      OnClick = btn_dlii430BClick
      NumGlyphs = 2
    end
    object btn_dlii430C: TBitBtn
      Tag = 2
      Left = 10
      Top = 70
      Width = 90
      Height = 25
      Hint = #25490#31243#26126#32048
      Caption = #25490#31243#26126#32048
      TabOrder = 0
      OnClick = btn_dlii430CClick
      NumGlyphs = 2
    end
    object btn_dlii430D: TBitBtn
      Tag = 2
      Left = 10
      Top = 100
      Width = 90
      Height = 25
      Hint = #29376#24907#26356#25913#28858#24050#20986#36554#25110#20633#36008#20013
      Caption = #24050#20986#36554'/'#20633#36008#20013
      TabOrder = 2
      OnClick = btn_dlii430DClick
      NumGlyphs = 2
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 756
    Top = 8
  end
end