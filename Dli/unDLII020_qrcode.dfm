inherited FrmDLII020_qrcode: TFrmDLII020_qrcode
  Left = 120
  Top = 83
  Width = 600
  Height = 410
  Caption = #20108#32173#30908#27161#31805#21015#21360
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 86
    Top = 168
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object Label2: TLabel [1]
    Left = 291
    Top = 168
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label2'
  end
  object Label3: TLabel [2]
    Left = 86
    Top = 203
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label3'
  end
  object Label4: TLabel [3]
    Tag = 1
    Left = 120
    Top = 310
    Width = 32
    Height = 13
    Caption = 'Label4'
  end
  inherited PnlRight: TPanel
    Left = 474
    Height = 372
    TabOrder = 5
  end
  object Edit1: TEdit [5]
    Left = 120
    Top = 165
    Width = 100
    Height = 21
    ImeName = #23567#29436#27627
    TabOrder = 1
  end
  object Edit2: TEdit [6]
    Left = 325
    Top = 165
    Width = 65
    Height = 21
    ImeName = #23567#29436#27627
    TabOrder = 2
  end
  object Memo1: TMemo [7]
    Left = 120
    Top = 200
    Width = 270
    Height = 101
    ImeName = #23567#29436#27627
    TabOrder = 4
  end
  object BitBtn1: TBitBtn [8]
    Left = 392
    Top = 162
    Width = 30
    Height = 25
    Caption = #26597#35426
    TabOrder = 3
    OnClick = BitBtn1Click
  end
  object GroupBox1: TGroupBox [9]
    Left = 120
    Top = 20
    Width = 270
    Height = 125
    Caption = #21015#21360#39006#22411
    TabOrder = 0
    object rb1: TRadioButton
      Left = 20
      Top = 30
      Width = 240
      Height = 17
      Caption = 'rb1'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rb1Click
    end
    object rb2: TRadioButton
      Left = 20
      Top = 60
      Width = 240
      Height = 17
      Caption = 'rb2'
      TabOrder = 1
      OnClick = rb2Click
    end
    object rb3: TRadioButton
      Left = 20
      Top = 90
      Width = 240
      Height = 17
      Caption = 'rb3'
      TabOrder = 2
      OnClick = rb3Click
    end
  end
  object Edit3: TEdit [10]
    Left = 232
    Top = 317
    Width = 100
    Height = 21
    ImeName = #23567#29436#27627
    TabOrder = 6
  end
  inherited ImageList1: TImageList
    Top = 319
  end
end
