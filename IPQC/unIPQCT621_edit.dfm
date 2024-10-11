inherited FrmIPQCT621_edit: TFrmIPQCT621_edit
  Width = 1100
  Height = 400
  Caption = #35519#33184#35352#37636#32173#35703
  PixelsPerInch = 96
  TextHeight = 13
  object ad: TLabel [0]
    Left = 112
    Top = 33
    Width = 11
    Height = 13
    Alignment = taRightJustify
    Caption = 'ad'
  end
  object ver: TLabel [1]
    Left = 333
    Top = 33
    Width = 15
    Height = 13
    Alignment = taRightJustify
    Caption = 'ver'
  end
  object lot: TLabel [2]
    Left = 562
    Top = 33
    Width = 12
    Height = 13
    Alignment = taRightJustify
    Caption = 'lot'
  end
  object qty: TLabel [3]
    Left = 793
    Top = 33
    Width = 15
    Height = 13
    Alignment = taRightJustify
    Caption = 'qty'
  end
  object c13_1: TLabel [4]
    Left = 92
    Top = 93
    Width = 29
    Height = 13
    Alignment = taRightJustify
    Caption = 'c13_1'
  end
  object c13_2: TLabel [5]
    Left = 319
    Top = 93
    Width = 29
    Height = 13
    Alignment = taRightJustify
    Caption = 'c13_2'
  end
  object c13_3: TLabel [6]
    Left = 545
    Top = 93
    Width = 29
    Height = 13
    Alignment = taRightJustify
    Caption = 'c13_3'
  end
  object c13_4: TLabel [7]
    Left = 779
    Top = 93
    Width = 29
    Height = 13
    Alignment = taRightJustify
    Caption = 'c13_4'
  end
  object Niandu: TLabel [8]
    Left = 86
    Top = 133
    Width = 35
    Height = 13
    Alignment = taRightJustify
    Caption = 'Niandu'
  end
  object LudaiQty: TLabel [9]
    Left = 303
    Top = 133
    Width = 45
    Height = 13
    Alignment = taRightJustify
    Caption = 'LudaiQty'
  end
  object Spos: TLabel [10]
    Left = 550
    Top = 133
    Width = 24
    Height = 13
    Alignment = taRightJustify
    Caption = 'Spos'
  end
  object Spos_time: TLabel [11]
    Left = 757
    Top = 133
    Width = 51
    Height = 13
    Alignment = taRightJustify
    Caption = 'Spos_time'
  end
  object Temperature: TLabel [12]
    Left = 61
    Top = 173
    Width = 60
    Height = 13
    Alignment = taRightJustify
    Caption = 'Temperature'
  end
  object RemainLot: TLabel [13]
    Left = 295
    Top = 173
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = 'RemainLot'
  end
  object AddQty: TLabel [14]
    Left = 535
    Top = 173
    Width = 39
    Height = 13
    Alignment = taRightJustify
    Caption = 'AddQty'
  end
  object AddSG: TLabel [15]
    Left = 771
    Top = 173
    Width = 37
    Height = 13
    Alignment = taRightJustify
    Caption = 'AddSG'
  end
  object T1: TLabel [16]
    Left = 108
    Top = 213
    Width = 13
    Height = 13
    Alignment = taRightJustify
    Caption = 'T1'
  end
  object T1_time: TLabel [17]
    Left = 308
    Top = 213
    Width = 40
    Height = 13
    Alignment = taRightJustify
    Caption = 'T1_time'
  end
  object T2: TLabel [18]
    Left = 561
    Top = 213
    Width = 13
    Height = 13
    Alignment = taRightJustify
    Caption = 'T2'
  end
  object T2_time: TLabel [19]
    Left = 768
    Top = 213
    Width = 40
    Height = 13
    Alignment = taRightJustify
    Caption = 'T2_time'
  end
  object T3: TLabel [20]
    Left = 108
    Top = 253
    Width = 13
    Height = 13
    Alignment = taRightJustify
    Caption = 'T3'
  end
  object T3_time: TLabel [21]
    Left = 308
    Top = 253
    Width = 40
    Height = 13
    Alignment = taRightJustify
    Caption = 'T3_time'
  end
  object T4: TLabel [22]
    Left = 561
    Top = 253
    Width = 13
    Height = 13
    Alignment = taRightJustify
    Caption = 'T4'
  end
  object T4_time: TLabel [23]
    Left = 768
    Top = 253
    Width = 40
    Height = 13
    Alignment = taRightJustify
    Caption = 'T4_time'
  end
  object Opt_uid: TLabel [24]
    Left = 82
    Top = 293
    Width = 39
    Height = 13
    Alignment = taRightJustify
    Caption = 'Opt_uid'
  end
  object Opt_uname: TLabel [25]
    Left = 292
    Top = 293
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'Opt_uname'
  end
  object Bevel1: TBevel [26]
    Left = 40
    Top = 72
    Width = 917
    Height = 5
    Shape = bsTopLine
  end
  object Conf_uid: TLabel [27]
    Left = 529
    Top = 293
    Width = 45
    Height = 13
    Alignment = taRightJustify
    Caption = 'Conf_uid'
  end
  object Conf_uname: TLabel [28]
    Left = 746
    Top = 293
    Width = 62
    Height = 13
    Alignment = taRightJustify
    Caption = 'Conf_uname'
  end
  inherited PnlRight: TPanel
    Left = 974
    Height = 361
    TabOrder = 28
  end
  object DBEdit1: TDBEdit [30]
    Left = 125
    Top = 30
    Width = 130
    Height = 21
    Color = clInfoBk
    DataField = 'ad'
    DataSource = FrmIPQCT621.DS
    Enabled = False
    TabOrder = 0
  end
  object DBEdit2: TDBEdit [31]
    Left = 350
    Top = 30
    Width = 130
    Height = 21
    Color = clInfoBk
    DataField = 'ver'
    DataSource = FrmIPQCT621.DS
    Enabled = False
    TabOrder = 1
  end
  object DBEdit3: TDBEdit [32]
    Left = 575
    Top = 30
    Width = 130
    Height = 21
    Color = clInfoBk
    DataField = 'lot'
    DataSource = FrmIPQCT621.DS
    Enabled = False
    TabOrder = 2
  end
  object DBEdit4: TDBEdit [33]
    Left = 810
    Top = 30
    Width = 130
    Height = 21
    Color = clInfoBk
    DataField = 'qty'
    DataSource = FrmIPQCT621.DS
    Enabled = False
    TabOrder = 3
  end
  object DBEdit5: TDBEdit [34]
    Left = 125
    Top = 90
    Width = 130
    Height = 21
    DataField = 'c13_1'
    DataSource = FrmIPQCT621.DS
    TabOrder = 4
  end
  object DBEdit6: TDBEdit [35]
    Left = 350
    Top = 90
    Width = 130
    Height = 21
    DataField = 'c13_2'
    DataSource = FrmIPQCT621.DS
    TabOrder = 5
  end
  object DBEdit7: TDBEdit [36]
    Left = 575
    Top = 90
    Width = 130
    Height = 21
    DataField = 'c13_3'
    DataSource = FrmIPQCT621.DS
    TabOrder = 6
  end
  object DBEdit8: TDBEdit [37]
    Left = 810
    Top = 90
    Width = 130
    Height = 21
    DataField = 'c13_4'
    DataSource = FrmIPQCT621.DS
    TabOrder = 7
  end
  object DBEdit9: TDBEdit [38]
    Left = 125
    Top = 130
    Width = 60
    Height = 21
    DataField = 'Niandu'
    DataSource = FrmIPQCT621.DS
    TabOrder = 8
  end
  object DBEdit10: TDBEdit [39]
    Left = 350
    Top = 130
    Width = 130
    Height = 21
    DataField = 'LudaiQty'
    DataSource = FrmIPQCT621.DS
    TabOrder = 9
  end
  object DBEdit11: TDBEdit [40]
    Left = 575
    Top = 130
    Width = 130
    Height = 21
    DataField = 'Spos'
    DataSource = FrmIPQCT621.DS
    TabOrder = 10
  end
  object DBEdit13: TDBEdit [41]
    Left = 125
    Top = 170
    Width = 130
    Height = 21
    DataField = 'Temperature'
    DataSource = FrmIPQCT621.DS
    TabOrder = 12
  end
  object DBEdit14: TDBEdit [42]
    Left = 350
    Top = 170
    Width = 130
    Height = 21
    DataField = 'RemainLot'
    DataSource = FrmIPQCT621.DS
    TabOrder = 13
  end
  object DBEdit15: TDBEdit [43]
    Left = 575
    Top = 170
    Width = 130
    Height = 21
    DataField = 'AddQty'
    DataSource = FrmIPQCT621.DS
    TabOrder = 14
  end
  object DBEdit16: TDBEdit [44]
    Left = 810
    Top = 170
    Width = 130
    Height = 21
    DataField = 'AddSG'
    DataSource = FrmIPQCT621.DS
    TabOrder = 15
  end
  object DBEdit17: TDBEdit [45]
    Left = 125
    Top = 210
    Width = 130
    Height = 21
    DataField = 'T1'
    DataSource = FrmIPQCT621.DS
    TabOrder = 16
  end
  object DBEdit19: TDBEdit [46]
    Left = 575
    Top = 210
    Width = 130
    Height = 21
    DataField = 'T2'
    DataSource = FrmIPQCT621.DS
    TabOrder = 18
  end
  object DBEdit21: TDBEdit [47]
    Left = 125
    Top = 250
    Width = 130
    Height = 21
    DataField = 'T3'
    DataSource = FrmIPQCT621.DS
    TabOrder = 20
  end
  object DBEdit23: TDBEdit [48]
    Left = 575
    Top = 250
    Width = 130
    Height = 21
    DataField = 'T4'
    DataSource = FrmIPQCT621.DS
    TabOrder = 22
  end
  object DBEdit25: TDBEdit [49]
    Left = 125
    Top = 290
    Width = 130
    Height = 21
    DataField = 'Opt_uid'
    DataSource = FrmIPQCT621.DS
    TabOrder = 24
  end
  object DBEdit26: TDBEdit [50]
    Left = 350
    Top = 290
    Width = 130
    Height = 21
    Color = clInfoBk
    DataField = 'Opt_uname'
    DataSource = FrmIPQCT621.DS
    Enabled = False
    TabOrder = 25
  end
  object DBEdit27: TDBEdit [51]
    Left = 575
    Top = 290
    Width = 130
    Height = 21
    DataField = 'Conf_uid'
    DataSource = FrmIPQCT621.DS
    TabOrder = 26
  end
  object DBEdit28: TDBEdit [52]
    Left = 810
    Top = 290
    Width = 130
    Height = 21
    Color = clInfoBk
    DataField = 'Conf_uname'
    DataSource = FrmIPQCT621.DS
    Enabled = False
    TabOrder = 27
  end
  object DBDateTimeEditEh1: TDBDateTimeEditEh [53]
    Left = 810
    Top = 130
    Width = 130
    Height = 21
    DataField = 'Spos_time'
    DataSource = FrmIPQCT621.DS
    DynProps = <>
    EditButtons = <>
    Kind = dtkDateTimeEh
    TabOrder = 11
    Visible = True
  end
  object DBDateTimeEditEh2: TDBDateTimeEditEh [54]
    Left = 350
    Top = 210
    Width = 130
    Height = 21
    DataField = 't1_time'
    DataSource = FrmIPQCT621.DS
    DynProps = <>
    EditButtons = <>
    Kind = dtkDateTimeEh
    TabOrder = 17
    Visible = True
  end
  object DBDateTimeEditEh3: TDBDateTimeEditEh [55]
    Left = 810
    Top = 210
    Width = 130
    Height = 21
    DataField = 't2_time'
    DataSource = FrmIPQCT621.DS
    DynProps = <>
    EditButtons = <>
    Kind = dtkDateTimeEh
    TabOrder = 19
    Visible = True
  end
  object DBDateTimeEditEh4: TDBDateTimeEditEh [56]
    Left = 350
    Top = 250
    Width = 130
    Height = 21
    DataField = 't3_time'
    DataSource = FrmIPQCT621.DS
    DynProps = <>
    EditButtons = <>
    Kind = dtkDateTimeEh
    TabOrder = 21
    Visible = True
  end
  object DBDateTimeEditEh5: TDBDateTimeEditEh [57]
    Left = 810
    Top = 250
    Width = 130
    Height = 21
    DataField = 't4_time'
    DataSource = FrmIPQCT621.DS
    DynProps = <>
    EditButtons = <>
    Kind = dtkDateTimeEh
    TabOrder = 23
    Visible = True
  end
  object DBEdit12: TDBEdit [58]
    Left = 195
    Top = 130
    Width = 60
    Height = 21
    Color = clInfoBk
    DataField = 'Niandu_std'
    DataSource = FrmIPQCT621.DS
    Enabled = False
    TabOrder = 29
  end
end
