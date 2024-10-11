inherited FrmLBLR270: TFrmLBLR270
  Left = 324
  Top = 264
  Caption = 'FrmLBLR270'
  PixelsPerInch = 96
  TextHeight = 13
  inherited DBGridEh1: TDBGridEh
    TitleParams.MultiTitle = True
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'wono1'
        Footers = <>
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pno1'
        Footers = <>
        Width = 121
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'lot1'
        Footers = <>
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qty1'
        Footers = <>
        Width = 59
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'spec1'
        Footers = <>
        Width = 80
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'wono2'
        Footers = <>
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pno2'
        Footers = <>
        Width = 127
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'lot2'
        Footers = <>
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qty2'
        Footers = <>
        Width = 71
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'spec2'
        Footers = <>
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'userid'
        Footers = <>
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ddate'
        Footers = <>
        Width = 100
      end>
  end
  inherited CDS: TClientDataSet
    object CDSid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object CDSwono1: TStringField
      DisplayLabel = #33290#27161#31844'|'#24037#21934
      FieldName = 'wono1'
      Size = 50
    end
    object CDSpno1: TStringField
      DisplayLabel = #33290#27161#31844'|'#26009#34399
      FieldName = 'pno1'
      Size = 50
    end
    object CDSlot1: TStringField
      DisplayLabel = #33290#27161#31844'|'#25209#34399
      FieldName = 'lot1'
      Size = 50
    end
    object CDSqty1: TStringField
      DisplayLabel = #33290#27161#31844'|'#25976#37327
      FieldName = 'qty1'
      Size = 50
    end
    object CDSspec1: TStringField
      DisplayLabel = #33290#27161#31844'|'#32080#27083
      FieldName = 'spec1'
      Size = 50
    end
    object CDSwono2: TStringField
      DisplayLabel = #26032#27161#31844'|'#24037#21934
      FieldName = 'wono2'
      Size = 50
    end
    object CDSpno2: TStringField
      DisplayLabel = #26032#27161#31844'|'#26009#34399
      FieldName = 'pno2'
      Size = 50
    end
    object CDSlot2: TStringField
      DisplayLabel = #26032#27161#31844'|'#25209#34399
      FieldName = 'lot2'
      Size = 50
    end
    object CDSqty2: TStringField
      DisplayLabel = #26032#27161#31844'|'#25976#37327
      FieldName = 'qty2'
      Size = 50
    end
    object CDSspec2: TStringField
      DisplayLabel = #26032#27161#31844'|'#35215#26684
      FieldName = 'spec2'
      Size = 50
    end
    object CDSuserid: TStringField
      DisplayLabel = #29992#25142
      FieldName = 'userid'
      Size = 50
    end
    object CDSddate: TDateTimeField
      DisplayLabel = #26085#26399
      FieldName = 'ddate'
    end
  end
end
