inherited FrmORDI170_query: TFrmORDI170_query
  Left = 552
  Top = 293
  Width = 901
  Height = 463
  Caption = #26597#35426
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 775
    Height = 424
    inherited btn_ok: TBitBtn
      Top = 47
    end
    inherited btn_quit: TBitBtn
      Top = 84
    end
    object btn_ordi170select: TBitBtn
      Tag = 2
      Left = 10
      Top = 10
      Width = 90
      Height = 25
      Hint = #25490#31243#26597#35426
      Caption = #26597#35426
      TabOrder = 2
      OnClick = btn_ordi170selectClick
      NumGlyphs = 2
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 775
    Height = 424
    Align = alClient
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 1
      Top = 1
      Width = 773
      Height = 101
      Align = alTop
      Caption = #26597#35426#26781#20214
      TabOrder = 0
      object Label2: TLabel
        Left = 69
        Top = 44
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = 'Label2'
      end
      object Label4: TLabel
        Left = 69
        Top = 70
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = 'Label1'
      end
      object Label1: TLabel
        Left = 69
        Top = 18
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = 'Label1'
      end
      object Edit2: TEdit
        Left = 112
        Top = 40
        Width = 236
        Height = 21
        TabOrder = 0
      end
      object Edit3: TEdit
        Left = 112
        Top = 66
        Width = 417
        Height = 21
        TabOrder = 1
      end
      object Edit1: TEdit
        Left = 112
        Top = 14
        Width = 121
        Height = 21
        TabOrder = 2
        Text = 'ITEQDG'
      end
      object Chb_IsOk: TCheckBox
        Left = 572
        Top = 68
        Width = 97
        Height = 17
        Caption = #26159#21542#25291#36681
        TabOrder = 3
      end
    end
    object DBGridEh1: TDBGridEh
      Left = 1
      Top = 102
      Width = 773
      Height = 321
      Align = alClient
      DataSource = DS2
      DynProps = <>
      IndicatorOptions = [gioShowRowIndicatorEh]
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 1
      OnDblClick = DBGridEh1DblClick
      Columns = <
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'Bu'
          Footers = <>
          Width = 96
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'CustNo'
          Footers = <>
          Width = 113
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'CustItemCode'
          Footers = <>
          Width = 211
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'CustDesc'
          Footers = <>
          Width = 255
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 425
    Top = 205
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 397
    Top = 281
  end
end
