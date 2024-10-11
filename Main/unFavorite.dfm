inherited FrmFavorite: TFrmFavorite
  Width = 816
  Height = 550
  Caption = 'FrmFavorite'
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object CLB: TCheckListBox [0]
    Left = 0
    Top = 41
    Width = 600
    Height = 471
    OnClickCheck = CLBClickCheck
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    Columns = 3
    ItemHeight = 13
    TabOrder = 1
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 800
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object btn_up: TSpeedButton
      Left = 607
      Top = 12
      Width = 17
      Height = 16
      Caption = #9650
      Flat = True
      OnClick = btn_upClick
    end
    object btn_down: TSpeedButton
      Left = 626
      Top = 12
      Width = 17
      Height = 16
      Caption = #9660
      Flat = True
      OnClick = btn_downClick
    end
    object lblsys: TLabel
      Tag = 1
      Left = 36
      Top = 15
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'lblsys'
    end
    object cbb: TComboBox
      Left = 70
      Top = 12
      Width = 150
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = cbbChange
    end
    object Edit1: TEdit
      Left = 290
      Top = 12
      Width = 100
      Height = 21
      TabOrder = 1
    end
    object btn_qfind: TBitBtn
      Left = 391
      Top = 10
      Width = 50
      Height = 25
      Caption = 'btn_qfind'
      TabOrder = 2
      OnClick = btn_qfindClick
    end
  end
  object LB: TListBox [2]
    Left = 600
    Top = 41
    Width = 200
    Height = 471
    Align = alRight
    BevelInner = bvNone
    BevelOuter = bvNone
    ItemHeight = 13
    TabOrder = 2
    OnDblClick = LBDblClick
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 134
    Top = 317
  end
end
