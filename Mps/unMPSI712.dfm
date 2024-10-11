inherited FrmMPSI712: TFrmMPSI712
  Left = 366
  Top = 156
  Caption = 'FrmMPSI712'
  ClientHeight = 575
  ClientWidth = 934
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 934
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
    Top = 545
    Width = 934
  end
  inherited Panel1: TPanel
    Width = 934
  end
  inherited DBGridEh1: TDBGridEh
    Width = 934
    Height = 501
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'wono'
        Footers = <>
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custname'
        Footers = <>
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qtime'
        Footers = <>
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qty1'
        Footers = <>
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qty2'
        Footers = <>
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pno1'
        Footers = <>
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pno2'
        Footers = <>
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'notice'
        Footers = <>
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'lable'
        Footers = <>
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custpo'
        Footers = <>
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'remark'
        Footers = <>
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ddate'
        Footers = <>
      end>
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = CDSBeforeInsert
    AfterInsert = CDSAfterInsert
    BeforeEdit = CDSBeforeEdit
    AfterEdit = CDSAfterEdit
    BeforePost = CDSBeforePost
    AfterPost = CDSAfterPost
    AfterCancel = CDSAfterCancel
    BeforeDelete = CDSBeforeDelete
    AfterDelete = CDSAfterDelete
    AfterScroll = CDSAfterScroll
    OnNewRecord = CDSNewRecord
    Left = 637
    Top = 181
    object StringField1: TStringField
      FieldName = 'bu'
      Size = 50
    end
    object StringField2: TStringField
      DisplayLabel = #24037#21934
      FieldName = 'wono'
      Size = 50
    end
    object StringField3: TStringField
      DisplayLabel = #23458#25142
      FieldName = 'custname'
      Size = 50
    end
    object StringField4: TStringField
      DisplayLabel = #20999#36008#26178#38291
      FieldName = 'qtime'
      Size = 50
    end
    object FloatField1: TFloatField
      DisplayLabel = #30332#26009#25976#37327'(RL)'
      FieldName = 'qty1'
    end
    object FloatField2: TFloatField
      DisplayLabel = #20986#36008#25976#37327'(RL)'
      FieldName = 'qty2'
    end
    object StringField5: TStringField
      DisplayLabel = #37325#24037#21069#26009#34399
      FieldName = 'pno1'
      Size = 50
    end
    object StringField6: TStringField
      DisplayLabel = #37325#24037#24460#26009#34399
      FieldName = 'pno2'
      Size = 50
    end
    object StringField7: TStringField
      DisplayLabel = #27880#24847#20107#38917
      FieldName = 'notice'
      Size = 500
    end
    object StringField8: TStringField
      DisplayLabel = #27161#31844#25171#27861
      FieldName = 'lable'
      Size = 500
    end
    object StringField9: TStringField
      DisplayLabel = #23458#25142#35330#21934#21934#34399
      FieldName = 'custpo'
      Size = 100
    end
    object StringField10: TStringField
      DisplayLabel = #20633#35387
      FieldName = 'remark'
      Size = 2000
    end
  end
end
