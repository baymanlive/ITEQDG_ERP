inherited FrmORDR020: TFrmORDR020
  Left = 224
  Top = 150
  Width = 1134
  Height = 649
  Caption = 'ORDR020'
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TStatusBar
    Top = 581
    Width = 1126
  end
  inherited ToolBar: TToolBar
    Width = 1126
  end
  inherited PCL: TPageControl
    Top = 48
    Width = 1361
    Height = 632
    inherited TabSheet1: TTabSheet
      inherited DBGridEh1: TDBGridEh
        Width = 1345
        Height = 595
        FooterRowCount = 1
        SumList.Active = True
        TitleParams.MultiTitle = True
        OnGetCellParams = DBGridEh1GetCellParams
        OnMouseDown = DBGridEh1MouseDown
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sfb01'
            Footers = <>
            Width = 101
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sfb05'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oeb06'
            Footers = <>
            Width = 148
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sfb15'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oea04'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sfb22'
            Footers = <>
            Width = 74
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sfb08'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'shb032'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'tc_iee10'
            Footer.ValueType = fvtSum
            Footers = <>
            Width = 68
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'b1'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'b'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'c1'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'c'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'd1'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'd'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'e1'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'e'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'f1'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'f'
            Footer.ValueType = fvtSum
            Footers = <>
            Width = 58
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'g1'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'g'
            Footer.ValueType = fvtSum
            Footers = <>
            Width = 89
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'aa'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'bb'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'cc'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'errlist'
            Footers = <>
            Width = 165
          end>
      end
    end
  end
  inherited PnlBottom: TPanel
    Top = 551
    Width = 1126
  end
  inherited CDS: TClientDataSet
    OnCalcFields = CDSCalcFields
    object CDSsfb01: TStringField
      DisplayLabel = #24037#21934#32232#34399
      FieldName = 'sfb01'
      Size = 10
    end
    object strngfldCDSsfb05: TStringField
      DisplayLabel = #26009#20214#32232#34399
      FieldName = 'sfb05'
    end
    object strngfldCDSoeb06: TStringField
      DisplayLabel = #21697#21517#35215#26684
      FieldName = 'oeb06'
      Size = 30
    end
    object strngfldCDSoea04: TStringField
      DisplayLabel = #23458#25142#32232#34399
      FieldName = 'oea04'
      Size = 10
    end
    object dtmfldCDSsfb15: TDateTimeField
      DisplayLabel = #32080#26463#26085#26399
      FieldName = 'sfb15'
    end
    object bcdfldCDSshb032: TFloatField
      DisplayLabel = #19978#33184'|'#25237#20837#24037#26178
      FieldName = 'shb032'
    end
    object CDStc_iee10: TFloatField
      DisplayLabel = #19978#33184'|'#27161#28310#24037#26178
      FieldName = 'tc_iee10'
    end
    object bcdfldCDSsfb08: TFloatField
      DisplayLabel = #29983#29986#25976#37327
      FieldName = 'sfb08'
    end
    object strngfldCDSsfb22: TStringField
      DisplayLabel = #35330#21934#32232#34399
      FieldName = 'sfb22'
      Size = 10
    end
    object CDSb1: TFloatField
      DisplayLabel = #35009#20999'|'#25237#20837#24037#26178
      FieldName = 'b1'
    end
    object CDSb: TFloatField
      DisplayLabel = #35009#20999'|'#27161#28310#24037#26178
      FieldName = 'b'
    end
    object CDSc1: TFloatField
      DisplayLabel = #22534#30090'|'#25237#20837#24037#26178
      FieldName = 'c1'
    end
    object CDSc: TFloatField
      DisplayLabel = #22534#30090'|'#27161#28310#24037#26178
      FieldName = 'c'
    end
    object CDSd1: TFloatField
      DisplayLabel = #32068#21512'|'#25237#20837#24037#26178
      FieldName = 'd1'
    end
    object CDSd: TFloatField
      DisplayLabel = #32068#21512'|'#27161#28310#24037#26178
      FieldName = 'd'
    end
    object CDSe1: TFloatField
      DisplayLabel = #22739#21512'|'#25237#20837#24037#26178
      FieldName = 'e1'
    end
    object CDSe: TFloatField
      DisplayLabel = #22739#21512'|'#27161#28310#24037#26178
      FieldName = 'e'
    end
    object CDSf1: TFloatField
      DisplayLabel = 'CCL'#35009#37002'|'#25237#20837#24037#26178
      FieldName = 'f1'
    end
    object CDSf: TFloatField
      DisplayLabel = 'CCL'#35009#37002'|'#27161#28310#24037#26178
      FieldName = 'f'
    end
    object CDSg1: TFloatField
      DisplayLabel = 'CCL'#22806#35264#27298#26597'|'#25237#20837#24037#26178
      FieldName = 'g1'
    end
    object CDSg: TFloatField
      DisplayLabel = 'CCL'#22806#35264#27298#26597'|'#27161#28310#24037#26178
      FieldName = 'g'
    end
    object CDSaa: TFloatField
      DisplayLabel = #21512#35336'|'#25237#20837#24037#26178
      FieldKind = fkCalculated
      FieldName = 'aa'
      Calculated = True
    end
    object CDSbb: TFloatField
      DisplayLabel = #21512#35336'|'#27161#28310#24037#26178
      FieldKind = fkCalculated
      FieldName = 'bb'
      Calculated = True
    end
    object CDScc: TFloatField
      DisplayLabel = #21512#35336'|'#24046#30064#24037#26178
      FieldKind = fkCalculated
      FieldName = 'cc'
      Calculated = True
    end
    object strngfldCDSerrlist: TStringField
      DisplayLabel = #20572#27231#30064#24120#20195#30908
      FieldName = 'errlist'
      Size = 100
    end
  end
end
