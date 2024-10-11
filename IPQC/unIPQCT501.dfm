inherited FrmIPQCT501: TFrmIPQCT501
  Left = 357
  Top = 168
  Caption = 'FrmIPQCT501'
  ClientHeight = 773
  ClientWidth = 1134
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 1134
  end
  inherited PnlBottom: TPanel
    Top = 743
    Width = 1134
  end
  inherited Panel1: TPanel
    Width = 1134
  end
  object PnlRight: TPanel [3]
    Left = 1024
    Top = 44
    Width = 110
    Height = 699
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 3
    object btn_ipqct501A: TBitBtn
      Left = 10
      Top = 10
      Width = 90
      Height = 25
      Hint = #21028#23450#31561#32026
      Caption = #29289#24615#21028#32026
      TabOrder = 2
      OnClick = btn_ipqct501AClick
    end
    object btn_ipqct501B: TBitBtn
      Left = 10
      Top = 40
      Width = 90
      Height = 25
      Hint = #20837#24235#31561#32026
      Caption = #33258#21205#21028#32026
      TabOrder = 0
      OnClick = btn_ipqct501BClick
    end
    object btn_ipqct501C: TBitBtn
      Tag = 2
      Left = 10
      Top = 70
      Width = 90
      Height = 25
      Hint = #25353#25209#34399#21069'8'#34399#26356#26032#29289#24615#31561#32026
      Caption = #29289#24615#31561#32026#26356#26032
      TabOrder = 1
      OnClick = btn_ipqct501CClick
    end
  end
  object Panel2: TPanel [4]
    Left = 0
    Top = 44
    Width = 1024
    Height = 699
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 4
    object PCL: TPageControl
      Left = 0
      Top = 0
      Width = 1024
      Height = 120
      ActivePage = TabSheet1
      Align = alTop
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = #22522#26412#36039#26009
        object Pnl1: TPanel
          Left = 0
          Top = 0
          Width = 1016
          Height = 92
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object shb01: TLabel
            Left = 31
            Top = 13
            Width = 55
            Height = 13
            Alignment = taRightJustify
            Caption = #31227#36681#21934#34399':'
          end
          object tc_sia02: TLabel
            Left = 57
            Top = 40
            Width = 29
            Height = 13
            Alignment = taRightJustify
            Caption = #25209#34399':'
          end
          object tc_sik03: TLabel
            Left = 279
            Top = 40
            Width = 42
            Height = 13
            Alignment = taRightJustify
            Caption = #24067#26009#34399':'
          end
          object shb09: TLabel
            Left = 57
            Top = 67
            Width = 29
            Height = 13
            Alignment = taRightJustify
            Caption = #27231#33274':'
          end
          object shb10: TLabel
            Left = 481
            Top = 13
            Width = 55
            Height = 13
            Alignment = taRightJustify
            Caption = #29983#29986#29289#20214':'
          end
          object ima02: TLabel
            Left = 507
            Top = 40
            Width = 29
            Height = 13
            Alignment = taRightJustify
            Caption = #21697#21517':'
          end
          object shb02: TLabel
            Left = 269
            Top = 13
            Width = 52
            Height = 13
            Alignment = taRightJustify
            Caption = #22577#24037#26085#26399
          end
          object shb05: TLabel
            Left = 266
            Top = 67
            Width = 55
            Height = 13
            Alignment = taRightJustify
            Caption = #24037#21934#34399#30908':'
          end
          object ima021: TLabel
            Left = 507
            Top = 67
            Width = 29
            Height = 13
            Alignment = taRightJustify
            Caption = #35215#26684':'
          end
          object DBEdit7: TDBEdit
            Left = 540
            Top = 64
            Width = 150
            Height = 21
            Color = clInfoBk
            DataField = 'ima021'
            DataSource = DS
            ReadOnly = True
            TabOrder = 9
          end
          object DBEdit1: TDBEdit
            Left = 90
            Top = 10
            Width = 150
            Height = 21
            Color = clInfoBk
            DataField = 'shb01'
            DataSource = DS
            ReadOnly = True
            TabOrder = 0
          end
          object DBEdit2: TDBEdit
            Left = 90
            Top = 37
            Width = 150
            Height = 21
            Color = clInfoBk
            DataField = 'tc_sia02'
            DataSource = DS
            ReadOnly = True
            TabOrder = 4
          end
          object DBEdit3: TDBEdit
            Left = 325
            Top = 37
            Width = 120
            Height = 21
            Color = clInfoBk
            DataField = 'tc_sik03'
            DataSource = DS
            ReadOnly = True
            TabOrder = 5
          end
          object DBEdit4: TDBEdit
            Left = 90
            Top = 64
            Width = 150
            Height = 21
            Color = clInfoBk
            DataField = 'shb09'
            DataSource = DS
            ReadOnly = True
            TabOrder = 7
          end
          object DBEdit5: TDBEdit
            Left = 540
            Top = 10
            Width = 150
            Height = 21
            Color = clInfoBk
            DataField = 'shb10'
            DataSource = DS
            ReadOnly = True
            TabOrder = 2
          end
          object DBEdit6: TDBEdit
            Left = 540
            Top = 37
            Width = 150
            Height = 21
            Color = clInfoBk
            DataField = 'ima02'
            DataSource = DS
            ReadOnly = True
            TabOrder = 6
          end
          object shbacti: TDBCheckBox
            Left = 709
            Top = 10
            Width = 97
            Height = 17
            Caption = #30906#35469
            Color = clBtnFace
            DataField = 'shbacti'
            DataSource = DS
            ParentColor = False
            ReadOnly = True
            TabOrder = 3
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object DBEdit43: TDBEdit
            Left = 325
            Top = 10
            Width = 120
            Height = 21
            Color = clInfoBk
            DataField = 'shb02'
            DataSource = DS
            ReadOnly = True
            TabOrder = 1
          end
          object DBEdit83: TDBEdit
            Left = 325
            Top = 64
            Width = 120
            Height = 21
            Color = clInfoBk
            DataField = 'shb05'
            DataSource = DS
            ReadOnly = True
            TabOrder = 8
          end
        end
      end
    end
    object PCL2: TPageControl
      Left = 0
      Top = 120
      Width = 1024
      Height = 579
      Hint = '  '
      ActivePage = TabSheet2
      Align = alClient
      TabOrder = 1
      object TabSheet2: TTabSheet
        Caption = #21322#25104#21697#29376#27841
        object PnlDetail: TPanel
          Left = 0
          Top = 0
          Width = 1016
          Height = 551
          Hint = '  '
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object tc_sia22: TLabel
            Left = 48
            Top = 33
            Width = 39
            Height = 13
            Alignment = taRightJustify
            Caption = #24067#22522#37327
          end
          object tc_sia161: TLabel
            Left = 65
            Top = 58
            Width = 22
            Height = 13
            Alignment = taRightJustify
            Caption = 'T/W'
          end
          object tc_sia171: TLabel
            Left = 68
            Top = 83
            Width = 19
            Height = 13
            Alignment = taRightJustify
            Caption = 'R/C'
          end
          object Label101: TLabel
            Tag = 1
            Left = 51
            Top = 8
            Width = 26
            Height = 13
            Caption = #38917#30446
          end
          object Label102: TLabel
            Tag = 1
            Left = 90
            Top = 8
            Width = 13
            Height = 13
            Caption = #24038
          end
          object Label103: TLabel
            Tag = 1
            Left = 256
            Top = 8
            Width = 26
            Height = 13
            Caption = #20013#24038
          end
          object Label104: TLabel
            Tag = 1
            Left = 380
            Top = 8
            Width = 13
            Height = 13
            Caption = #20013
          end
          object Label105: TLabel
            Tag = 1
            Left = 550
            Top = 8
            Width = 26
            Height = 13
            Caption = #20013#21491
          end
          object Label106: TLabel
            Tag = 1
            Left = 680
            Top = 8
            Width = 13
            Height = 13
            Caption = #21491
          end
          object tc_sia181: TLabel
            Left = 69
            Top = 108
            Width = 18
            Height = 13
            Alignment = taRightJustify
            Caption = 'R/F'
          end
          object tc_sia191: TLabel
            Left = 42
            Top = 133
            Width = 45
            Height = 13
            Alignment = taRightJustify
            Caption = 'P/G(C/F)'
          end
          object tc_sia196: TLabel
            Left = 36
            Top = 158
            Width = 51
            Height = 13
            Alignment = taRightJustify
            Caption = 'P/V(C/F2)'
          end
          object tc_sia201: TLabel
            Left = 78
            Top = 183
            Width = 9
            Height = 13
            Alignment = taRightJustify
            Caption = 'V'
          end
          object tc_sia43: TLabel
            Left = 23
            Top = 208
            Width = 64
            Height = 13
            Alignment = taRightJustify
            Caption = 'RC/TW'#20013#20540
          end
          object tc_sia38: TLabel
            Left = 48
            Top = 233
            Width = 39
            Height = 13
            Alignment = taRightJustify
            Caption = #38748#31896#24230
          end
          object tc_sia215: TLabel
            Left = 75
            Top = 258
            Width = 12
            Height = 13
            Alignment = taRightJustify
            Caption = 'Br'
          end
          object tc_sia41: TLabel
            Left = 56
            Top = 283
            Width = 31
            Height = 13
            Alignment = taRightJustify
            Caption = 'Hi-pot'
          end
          object tc_sia211: TLabel
            Left = 65
            Top = 308
            Width = 22
            Height = 13
            Alignment = taRightJustify
            Caption = 'SG1'
          end
          object tc_sia33: TLabel
            Left = 35
            Top = 333
            Width = 52
            Height = 13
            Alignment = taRightJustify
            Caption = #21028#23450#31561#32026
          end
          object tc_sia24: TLabel
            Left = 35
            Top = 358
            Width = 52
            Height = 13
            Alignment = taRightJustify
            Caption = #20837#24235#31561#32026
          end
          object tc_sia44: TLabel
            Left = 334
            Top = 208
            Width = 41
            Height = 13
            Alignment = taRightJustify
            Caption = 'RF'#20013#20540
          end
          object tc_sia39: TLabel
            Left = 336
            Top = 233
            Width = 39
            Height = 13
            Alignment = taRightJustify
            Caption = #21205#31896#24230
          end
          object tc_sia217: TLabel
            Left = 366
            Top = 258
            Width = 11
            Height = 13
            Alignment = taRightJustify
            Caption = 'Cl'
          end
          object tc_sia42: TLabel
            Left = 323
            Top = 283
            Width = 52
            Height = 13
            Alignment = taRightJustify
            Caption = #20633#35387#20449#24687
          end
          object tc_sia212: TLabel
            Left = 353
            Top = 308
            Width = 22
            Height = 13
            Alignment = taRightJustify
            Caption = 'SG2'
          end
          object tc_sia23: TLabel
            Left = 323
            Top = 333
            Width = 52
            Height = 13
            Alignment = taRightJustify
            Caption = #21462#27171#26178#38291
          end
          object tc_sia32: TLabel
            Left = 323
            Top = 358
            Width = 52
            Height = 13
            Alignment = taRightJustify
            Caption = #22806#35264#31561#32026
          end
          object tc_sia45: TLabel
            Left = 634
            Top = 208
            Width = 42
            Height = 13
            Alignment = taRightJustify
            Caption = 'PG'#20013#20540
          end
          object tc_sia40: TLabel
            Left = 611
            Top = 233
            Width = 65
            Height = 13
            Alignment = taRightJustify
            Caption = #27604#20363#27969#21205#24230
          end
          object tc_sia30: TLabel
            Left = 624
            Top = 308
            Width = 52
            Height = 13
            Alignment = taRightJustify
            Caption = #33184#27700#25209#34399
          end
          object tc_sia36: TLabel
            Left = 522
            Top = 358
            Width = 50
            Height = 13
            Alignment = taRightJustify
            Caption = 'CPK'#20633#35387
          end
          object btn_sp: TSpeedButton
            Left = 780
            Top = 305
            Width = 23
            Height = 22
            Caption = '...'
            OnClick = btn_spClick
          end
          object btn_sp2: TSpeedButton
            Left = 192
            Top = 180
            Width = 36
            Height = 22
            Caption = #26597#35426
            OnClick = btn_sp2Click
          end
          object tc_sia49: TLabel
            Left = 501
            Top = 258
            Width = 26
            Height = 13
            Alignment = taRightJustify
            Caption = #29255#37325
          end
          object tc_sia50: TLabel
            Left = 651
            Top = 258
            Width = 26
            Height = 13
            Alignment = taRightJustify
            Caption = #22291#37325
          end
          object DBEdit12: TDBEdit
            Left = 90
            Top = 30
            Width = 100
            Height = 21
            DataField = 'tc_sia22'
            DataSource = DS
            TabOrder = 0
          end
          object DBEdit13: TDBEdit
            Left = 90
            Top = 55
            Width = 100
            Height = 21
            DataField = 'tc_sia161'
            DataSource = DS
            TabOrder = 1
          end
          object DBEdit14: TDBEdit
            Left = 380
            Top = 55
            Width = 100
            Height = 21
            DataField = 'tc_sia163'
            DataSource = DS
            TabOrder = 2
          end
          object DBEdit15: TDBEdit
            Left = 90
            Top = 80
            Width = 100
            Height = 21
            DataField = 'tc_sia171'
            DataSource = DS
            TabOrder = 4
          end
          object DBEdit16: TDBEdit
            Left = 380
            Top = 80
            Width = 100
            Height = 21
            DataField = 'tc_sia173'
            DataSource = DS
            TabOrder = 5
          end
          object DBEdit17: TDBEdit
            Left = 680
            Top = 80
            Width = 100
            Height = 21
            DataField = 'tc_sia175'
            DataSource = DS
            TabOrder = 6
          end
          object DBEdit19: TDBEdit
            Left = 680
            Top = 55
            Width = 100
            Height = 21
            DataField = 'tc_sia165'
            DataSource = DS
            TabOrder = 3
          end
          object DBEdit18: TDBEdit
            Left = 680
            Top = 105
            Width = 100
            Height = 21
            DataField = 'tc_sia185'
            DataSource = DS
            TabOrder = 9
          end
          object DBEdit20: TDBEdit
            Left = 380
            Top = 105
            Width = 100
            Height = 21
            DataField = 'tc_sia183'
            DataSource = DS
            TabOrder = 8
          end
          object DBEdit21: TDBEdit
            Left = 90
            Top = 105
            Width = 100
            Height = 21
            DataField = 'tc_sia181'
            DataSource = DS
            TabOrder = 7
          end
          object DBEdit22: TDBEdit
            Left = 380
            Top = 130
            Width = 100
            Height = 21
            DataField = 'tc_sia193'
            DataSource = DS
            TabOrder = 14
          end
          object DBEdit23: TDBEdit
            Left = 230
            Top = 130
            Width = 100
            Height = 21
            DataField = 'tc_sia192'
            DataSource = DS
            TabOrder = 12
          end
          object DBEdit24: TDBEdit
            Left = 90
            Top = 130
            Width = 100
            Height = 21
            DataField = 'tc_sia191'
            DataSource = DS
            TabOrder = 10
          end
          object DBEdit25: TDBEdit
            Left = 680
            Top = 130
            Width = 100
            Height = 21
            DataField = 'tc_sia195'
            DataSource = DS
            TabOrder = 18
          end
          object DBEdit26: TDBEdit
            Left = 530
            Top = 130
            Width = 100
            Height = 21
            DataField = 'tc_sia194'
            DataSource = DS
            TabOrder = 16
          end
          object DBEdit27: TDBEdit
            Left = 380
            Top = 155
            Width = 100
            Height = 21
            DataField = 'tc_sia198'
            DataSource = DS
            TabOrder = 15
          end
          object DBEdit28: TDBEdit
            Left = 230
            Top = 155
            Width = 100
            Height = 21
            DataField = 'tc_sia197'
            DataSource = DS
            TabOrder = 13
          end
          object DBEdit29: TDBEdit
            Left = 90
            Top = 155
            Width = 100
            Height = 21
            DataField = 'tc_sia196'
            DataSource = DS
            TabOrder = 11
          end
          object DBEdit30: TDBEdit
            Left = 680
            Top = 155
            Width = 100
            Height = 21
            DataField = 'tc_sia19A'
            DataSource = DS
            TabOrder = 19
          end
          object DBEdit31: TDBEdit
            Left = 530
            Top = 155
            Width = 100
            Height = 21
            DataField = 'tc_sia199'
            DataSource = DS
            TabOrder = 17
          end
          object DBEdit32: TDBEdit
            Left = 90
            Top = 180
            Width = 100
            Height = 21
            DataField = 'tc_sia201'
            DataSource = DS
            TabOrder = 20
          end
          object DBEdit33: TDBEdit
            Left = 380
            Top = 180
            Width = 100
            Height = 21
            DataField = 'tc_sia203'
            DataSource = DS
            TabOrder = 21
          end
          object DBEdit34: TDBEdit
            Left = 680
            Top = 180
            Width = 100
            Height = 21
            DataField = 'tc_sia205'
            DataSource = DS
            TabOrder = 22
          end
          object DBEdit35: TDBEdit
            Left = 90
            Top = 205
            Width = 100
            Height = 21
            DataField = 'tc_sia43'
            DataSource = DS
            TabOrder = 23
          end
          object DBEdit36: TDBEdit
            Left = 380
            Top = 205
            Width = 100
            Height = 21
            DataField = 'tc_sia44'
            DataSource = DS
            TabOrder = 24
          end
          object DBEdit37: TDBEdit
            Left = 680
            Top = 205
            Width = 100
            Height = 21
            DataField = 'tc_sia45'
            DataSource = DS
            TabOrder = 25
          end
          object DBEdit38: TDBEdit
            Left = 90
            Top = 230
            Width = 100
            Height = 21
            DataField = 'tc_sia38'
            DataSource = DS
            TabOrder = 26
          end
          object DBEdit39: TDBEdit
            Left = 380
            Top = 230
            Width = 100
            Height = 21
            DataField = 'tc_sia39'
            DataSource = DS
            TabOrder = 27
          end
          object DBEdit40: TDBEdit
            Left = 680
            Top = 230
            Width = 100
            Height = 21
            DataField = 'tc_sia40'
            DataSource = DS
            TabOrder = 28
          end
          object DBEdit41: TDBEdit
            Left = 90
            Top = 255
            Width = 100
            Height = 21
            DataField = 'tc_sia215'
            DataSource = DS
            TabOrder = 29
          end
          object DBEdit42: TDBEdit
            Left = 380
            Top = 255
            Width = 100
            Height = 21
            DataField = 'tc_sia217'
            DataSource = DS
            TabOrder = 30
          end
          object DBEdit44: TDBEdit
            Left = 90
            Top = 280
            Width = 100
            Height = 21
            DataField = 'tc_sia41'
            DataSource = DS
            TabOrder = 33
          end
          object DBEdit45: TDBEdit
            Left = 380
            Top = 280
            Width = 250
            Height = 21
            DataField = 'tc_sia42'
            DataSource = DS
            TabOrder = 34
          end
          object DBEdit46: TDBEdit
            Left = 90
            Top = 305
            Width = 100
            Height = 21
            DataField = 'tc_sia211'
            DataSource = DS
            TabOrder = 35
          end
          object DBEdit47: TDBEdit
            Left = 380
            Top = 305
            Width = 100
            Height = 21
            DataField = 'tc_sia212'
            DataSource = DS
            TabOrder = 36
          end
          object DBEdit48: TDBEdit
            Left = 680
            Top = 305
            Width = 100
            Height = 21
            DataField = 'tc_sia30'
            DataSource = DS
            TabOrder = 37
          end
          object DBEdit49: TDBEdit
            Left = 90
            Top = 330
            Width = 100
            Height = 21
            DataField = 'tc_sia33'
            DataSource = DS
            TabOrder = 38
          end
          object DBEdit50: TDBEdit
            Left = 380
            Top = 330
            Width = 100
            Height = 21
            DataField = 'tc_sia23'
            DataSource = DS
            TabOrder = 39
          end
          object DBEdit51: TDBEdit
            Left = 90
            Top = 355
            Width = 100
            Height = 21
            DataField = 'tc_sia24'
            DataSource = DS
            TabOrder = 41
          end
          object DBEdit52: TDBEdit
            Left = 380
            Top = 355
            Width = 100
            Height = 21
            DataField = 'tc_sia32'
            DataSource = DS
            TabOrder = 42
          end
          object DBEdit53: TDBEdit
            Left = 575
            Top = 355
            Width = 225
            Height = 21
            DataField = 'tc_sia36'
            DataSource = DS
            TabOrder = 43
          end
          object tc_sia31: TDBCheckBox
            Left = 680
            Top = 330
            Width = 133
            Height = 17
            Caption = #35069#31243#21028#23450'(Y/N)'
            DataField = 'tc_sia31'
            DataSource = DS
            TabOrder = 40
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object DBEdit8: TDBEdit
            Left = 530
            Top = 255
            Width = 100
            Height = 21
            DataField = 'tc_sia49'
            DataSource = DS
            TabOrder = 31
          end
          object DBEdit9: TDBEdit
            Left = 680
            Top = 255
            Width = 100
            Height = 21
            DataField = 'tc_sia50'
            DataSource = DS
            TabOrder = 32
          end
        end
      end
    end
  end
  inherited CDS: TClientDataSet
    BeforePost = CDSBeforePost
  end
end
