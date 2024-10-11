inherited FrmIPQCT001: TFrmIPQCT001
  Left = 324
  Top = 264
  Caption = 'FrmIPQCT001'
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
  object ADOQuery1: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=dgiteq;Persist Security Info=True;U' +
      'ser ID=sa;Initial Catalog=ERP2015;Data Source=192.168.4.14'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from lbl600')
    Left = 248
    Top = 248
    object ADOQuery1id: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object ADOQuery1wono1: TStringField
      FieldName = 'wono1'
      Size = 50
    end
    object ADOQuery1pno1: TStringField
      FieldName = 'pno1'
      Size = 50
    end
    object ADOQuery1lot1: TStringField
      FieldName = 'lot1'
      Size = 50
    end
    object ADOQuery1qty1: TStringField
      FieldName = 'qty1'
      Size = 50
    end
    object ADOQuery1spec1: TStringField
      FieldName = 'spec1'
      Size = 50
    end
    object ADOQuery1wono2: TStringField
      FieldName = 'wono2'
      Size = 50
    end
    object ADOQuery1pno2: TStringField
      FieldName = 'pno2'
      Size = 50
    end
    object ADOQuery1lot2: TStringField
      FieldName = 'lot2'
      Size = 50
    end
    object ADOQuery1qty2: TStringField
      FieldName = 'qty2'
      Size = 50
    end
    object ADOQuery1spec2: TStringField
      FieldName = 'spec2'
      Size = 50
    end
    object ADOQuery1userid: TStringField
      FieldName = 'userid'
      Size = 50
    end
    object ADOQuery1ddate: TDateTimeField
      FieldName = 'ddate'
    end
  end
end
