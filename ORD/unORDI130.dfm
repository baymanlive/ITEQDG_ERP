inherited FrmORDI130: TFrmORDI130
  Left = 164
  Top = 114
  Width = 1273
  Height = 667
  Caption = 'FrmORDI130'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TStatusBar
    Top = 599
    Width = 1265
  end
  inherited ToolBar: TToolBar
    Width = 1265
  end
  inherited PCL: TPageControl
    Width = 1124
    Height = 511
    inherited TabSheet1: TTabSheet
      inherited DBGridEh1: TDBGridEh
        Width = 1108
        Height = 474
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
        OnGetCellParams = DBGridEh1GetCellParams
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custno'
            Footers = <>
            Width = 70
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sno'
            Footers = <>
            Width = 109
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'cust_pno'
            Footers = <>
            Width = 135
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'cust_pname'
            Footers = <>
            Width = 285
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'CustSpec'
            Footers = <>
            Width = 172
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'CustSpec2'
            Footers = <>
            Width = 181
          end>
      end
    end
  end
  inherited PnlBottom: TPanel
    Top = 569
    Width = 1265
    object ProgressBar1: TProgressBar
      Left = 872
      Top = 8
      Width = 150
      Height = 17
      TabOrder = 2
      Visible = False
    end
  end
  inherited PnlRight: TPanel
    Left = 1140
    Height = 491
    object BitBtn1: TBitBtn
      Left = 10
      Top = 72
      Width = 90
      Height = 25
      Hint = #25918#26820
      Caption = '  '#21295#20837
      TabOrder = 2
      OnClick = BitBtn1Click
      NumGlyphs = 2
    end
    object BitBtn2: TBitBtn
      Left = 10
      Top = 104
      Width = 90
      Height = 25
      Hint = #25918#26820
      Caption = #25209#37327#21034#38500
      TabOrder = 3
      OnClick = BitBtn2Click
      NumGlyphs = 2
    end
    object BitBtn3: TBitBtn
      Left = 12
      Top = 136
      Width = 88
      Height = 25
      Caption = #21047#26032#32080#27083#30908
      TabOrder = 4
      OnClick = BitBtn3Click
    end
  end
  inherited CDS: TClientDataSet
    object CDSbu: TStringField
      FieldName = 'bu'
      FixedChar = True
      Size = 6
    end
    object CDScustno: TStringField
      DisplayLabel = #23458#25142#32232#34399
      FieldName = 'custno'
      Size = 100
    end
    object CDSsno: TStringField
      DisplayLabel = #24288#20839#26009#34399#30701#30908
      FieldName = 'sno'
      OnChange = CDSsnoChange
      Size = 50
    end
    object CDScust_pno: TStringField
      DisplayLabel = #23458#25142#29986#21697#32232#34399
      FieldName = 'cust_pno'
      Size = 50
    end
    object CDScust_pname: TStringField
      DisplayLabel = #23458#25142#21697#21517
      FieldName = 'cust_pname'
      OnChange = CDScust_pnameChange
      Size = 100
    end
    object CDSCustSpec: TStringField
      DisplayLabel = #23458#25142#23565#25033#32080#27083#20195#30908
      FieldName = 'CustSpec'
      Size = 100
    end
    object CDSCustSpec2: TStringField
      DisplayLabel = #32080#27083#20195#30908
      FieldName = 'CustSpec2'
      Size = 100
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'xls'
    Filter = #25152#26377'Excel'#27284#26696'(*.xls;*.xlsx)|*.xls;*.xlsx'
    Left = 368
    Top = 229
  end
  object ORD070: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 780
    Top = 405
  end
end
