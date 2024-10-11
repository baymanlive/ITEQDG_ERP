object Form2: TForm2
  Left = 192
  Top = 125
  BorderStyle = bsDialog
  Caption = 'Date+Time'
  ClientHeight = 194
  ClientWidth = 354
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 112
    Top = 29
    Width = 21
    Height = 13
    Alignment = taRightJustify
    Caption = 'date'
  end
  object Label2: TLabel
    Left = 114
    Top = 74
    Width = 19
    Height = 13
    Alignment = taRightJustify
    Caption = 'time'
  end
  object dtp: TDateTimePicker
    Left = 136
    Top = 26
    Width = 100
    Height = 21
    Date = 44067.000000000000000000
    Time = 44067.000000000000000000
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 136
    Top = 71
    Width = 100
    Height = 21
    TabOrder = 1
    Text = 'cocemail.txt'
  end
  object BitBtn1: TBitBtn
    Left = 100
    Top = 125
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 196
    Top = 125
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = BitBtn2Click
  end
end
