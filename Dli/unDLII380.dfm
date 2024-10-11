inherited FrmDLII380: TFrmDLII380
  Left = 361
  Top = 189
  Caption = 'FrmDLII380'
  ClientHeight = 688
  ClientWidth = 889
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel [0]
    Left = 30
    Top = 136
    Width = 300
    Height = 150
    Shape = bsFrame
  end
  object Bevel2: TBevel [1]
    Left = 30
    Top = 328
    Width = 708
    Height = 305
    Shape = bsFrame
  end
  object Label1: TLabel [2]
    Left = 30
    Top = 120
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label3: TLabel [3]
    Left = 30
    Top = 312
    Width = 32
    Height = 13
    Caption = 'Label3'
  end
  object Label4: TLabel [4]
    Left = 122
    Top = 156
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label4'
  end
  object Label5: TLabel [5]
    Left = 122
    Top = 188
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label5'
  end
  object Label6: TLabel [6]
    Left = 122
    Top = 220
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label6'
  end
  object Label7: TLabel [7]
    Left = 80
    Top = 340
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label7'
  end
  object Label8: TLabel [8]
    Left = 79
    Top = 60
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label3'
  end
  object Label9: TLabel [9]
    Left = 122
    Top = 252
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label9'
  end
  object Label10: TLabel [10]
    Left = 115
    Top = 88
    Width = 38
    Height = 13
    Caption = 'Label10'
  end
  inherited ToolBar: TToolBar
    Width = 889
    ButtonWidth = 33
    TabOrder = 7
    inherited btn_print: TToolButton
      Caption = #26356#25913
      ImageIndex = 5
      OnClick = btn_printClick
    end
    inherited btn_export: TToolButton
      Caption = #20786#23384
      ImageIndex = 47
      OnClick = btn_exportClick
    end
    inherited btn_query: TToolButton
      Left = 74
      Caption = #37325#25972
      ImageIndex = 58
      OnClick = btn_queryClick
    end
    inherited ToolButton1: TToolButton
      Left = 111
    end
    inherited btn_quit: TToolButton
      Left = 119
    end
    object ToolButton100: TToolButton
      Left = 156
      Top = 0
      AutoSize = True
      Caption = #25918#26820
      ImageIndex = 48
      OnClick = ToolButton100Click
    end
  end
  inherited Panel1: TPanel
    Width = 889
    TabOrder = 8
  end
  object Edit1: TEdit [13]
    Left = 158
    Top = 152
    Width = 160
    Height = 21
    TabOrder = 1
  end
  object Edit2: TEdit [14]
    Left = 158
    Top = 184
    Width = 160
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
  end
  object Edit3: TEdit [15]
    Left = 158
    Top = 216
    Width = 160
    Height = 21
    TabOrder = 3
  end
  object cbb: TComboBox [16]
    Left = 116
    Top = 336
    Width = 160
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    OnChange = cbbChange
  end
  object Memo2: TMemo [17]
    Left = 40
    Top = 364
    Width = 690
    Height = 260
    ScrollBars = ssBoth
    TabOrder = 6
  end
  object Edit4: TEdit [18]
    Left = 115
    Top = 56
    Width = 625
    Height = 21
    TabOrder = 0
  end
  object Edit5: TEdit [19]
    Left = 158
    Top = 248
    Width = 160
    Height = 21
    TabOrder = 4
  end
  object BitBtn1: TBitBtn [20]
    Left = 292
    Top = 334
    Width = 75
    Height = 25
    Caption = 'test'
    TabOrder = 9
    OnClick = BitBtn1Click
  end
end
