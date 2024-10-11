inherited FrmMDT060_newlot: TFrmMDT060_newlot
  Width = 434
  Height = 390
  Caption = #25209#34399#38928#36664#20837
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 308
    Height = 351
    inherited btn_ok: TBitBtn
      Top = 70
      Glyph.Data = {00000000}
    end
    inherited btn_quit: TBitBtn
      Top = 100
    end
    object btn_query: TBitBtn
      Left = 10
      Top = 10
      Width = 90
      Height = 25
      Caption = 'btn_query'
      TabOrder = 2
      OnClick = btn_queryClick
      NumGlyphs = 2
    end
    object btn_insert: TBitBtn
      Left = 10
      Top = 42
      Width = 90
      Height = 25
      Caption = 'btn_insert'
      TabOrder = 3
      OnClick = btn_insertClick
      NumGlyphs = 2
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 308
    Height = 351
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Memo1: TMemo
      Left = 0
      Top = 105
      Width = 308
      Height = 246
      Align = alClient
      TabOrder = 0
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 308
      Height = 105
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object Label1: TLabel
        Left = 31
        Top = 48
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = 'Label1'
      end
      object Label2: TLabel
        Left = 30
        Top = 78
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = 'Label2'
      end
      object Label3: TLabel
        Left = 191
        Top = 78
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = 'Label3'
      end
      object Label4: TLabel
        Left = 31
        Top = 18
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = 'Label4'
      end
      object Label5: TLabel
        Left = 191
        Top = 18
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = 'Label4'
      end
      object dtp: TDateTimePicker
        Left = 65
        Top = 45
        Width = 100
        Height = 21
        Date = 43396.000000000000000000
        Time = 43396.000000000000000000
        TabOrder = 2
      end
      object Edit1: TEdit
        Left = 64
        Top = 75
        Width = 100
        Height = 21
        TabOrder = 3
      end
      object Edit2: TEdit
        Left = 225
        Top = 75
        Width = 60
        Height = 21
        TabOrder = 4
      end
      object Edit3: TEdit
        Left = 65
        Top = 15
        Width = 100
        Height = 21
        Enabled = False
        TabOrder = 0
      end
      object Edit4: TEdit
        Left = 225
        Top = 15
        Width = 60
        Height = 21
        Enabled = False
        TabOrder = 1
      end
    end
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 264
    Top = 16
  end
end
