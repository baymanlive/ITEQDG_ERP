inherited FrmSysI060_other: TFrmSysI060_other
  Width = 600
  Height = 600
  Caption = 'FrmSysI060_other'
  ParentFont = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 584
  end
  inherited PnlBottom: TPanel
    Top = 532
    Width = 584
  end
  inherited Panel1: TPanel
    Width = 584
  end
  inherited DBGridEh1: TDBGridEh
    Width = 584
    Height = 488
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ProcId'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ReportName'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'def'
        Footers = <>
      end>
  end
  inherited CDS: TClientDataSet
    BeforePost = CDSBeforePost
  end
end
