object WarnFrm: TWarnFrm
  Left = 576
  Top = 331
  BorderStyle = bsDialog
  Caption = #35686#21578
  ClientHeight = 252
  ClientWidth = 562
  Color = clRed
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 545
    Height = 201
    Alignment = taCenter
    AutoSize = False
    Caption = #35531#20351#29992#27794#26377'HF'#28961#40565#32032#30340#30333#33394#27161#31844#32025'!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -40
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object BitBtn1: TBitBtn
    Left = 240
    Top = 224
    Width = 75
    Height = 25
    Caption = #30906#23450
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 0
  end
end
