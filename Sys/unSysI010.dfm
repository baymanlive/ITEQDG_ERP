inherited FrmSysI010: TFrmSysI010
  Caption = 'FrmSysI010'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PCL: TPageControl
    inherited TabSheet1: TTabSheet
      inherited Pnl1: TPanel
        object Bu: TLabel
          Left = 43
          Top = 38
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = #29151#36939#20013#24515':'
        end
        object ShortName: TLabel
          Left = 69
          Top = 73
          Width = 29
          Height = 13
          Alignment = taRightJustify
          Caption = #31777#31281':'
        end
        object Cname: TLabel
          Left = 43
          Top = 108
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = #20013#25991#21517#31281':'
        end
        object Ename: TLabel
          Left = 43
          Top = 143
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = #33521#25991#21517#31281':'
        end
        object Address: TLabel
          Left = 69
          Top = 178
          Width = 29
          Height = 13
          Alignment = taRightJustify
          Caption = #22320#22336':'
        end
        object Tel: TLabel
          Left = 69
          Top = 213
          Width = 29
          Height = 13
          Alignment = taRightJustify
          Caption = #38651#35441':'
        end
        object Fax: TLabel
          Left = 69
          Top = 248
          Width = 29
          Height = 13
          Alignment = taRightJustify
          Caption = #20659#30495':'
        end
        object DBEdit1: TDBEdit
          Left = 100
          Top = 35
          Width = 162
          Height = 21
          DataField = 'Bu'
          DataSource = DS
          TabOrder = 0
        end
        object DBEdit2: TDBEdit
          Left = 100
          Top = 70
          Width = 162
          Height = 21
          DataField = 'ShortName'
          DataSource = DS
          TabOrder = 1
        end
        object DBEdit3: TDBEdit
          Left = 100
          Top = 105
          Width = 433
          Height = 21
          DataField = 'Cname'
          DataSource = DS
          TabOrder = 2
        end
        object DBEdit4: TDBEdit
          Left = 100
          Top = 140
          Width = 433
          Height = 21
          DataField = 'Ename'
          DataSource = DS
          TabOrder = 3
        end
        object DBEdit5: TDBEdit
          Left = 100
          Top = 175
          Width = 433
          Height = 21
          DataField = 'Address'
          DataSource = DS
          TabOrder = 4
        end
        object DBEdit6: TDBEdit
          Left = 100
          Top = 210
          Width = 162
          Height = 21
          DataField = 'Tel'
          DataSource = DS
          TabOrder = 5
        end
        object DBEdit7: TDBEdit
          Left = 100
          Top = 245
          Width = 162
          Height = 21
          DataField = 'Fax'
          DataSource = DS
          TabOrder = 6
        end
      end
    end
    inherited TabSheet2: TTabSheet
      inherited Pnl2: TPanel
        object Iuser: TLabel
          Left = 47
          Top = 38
          Width = 49
          Height = 13
          Alignment = taRightJustify
          Caption = #26032#22686'user:'
        end
        object Idate: TLabel
          Left = 217
          Top = 38
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = #24314#27284#26085#26399':'
        end
        object Muser: TLabel
          Left = 47
          Top = 73
          Width = 49
          Height = 13
          Alignment = taRightJustify
          Caption = #20462#25913'user:'
        end
        object Mdate: TLabel
          Left = 217
          Top = 73
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = #20462#25913#26085#26399':'
        end
        object DBEdit8: TDBEdit
          Left = 100
          Top = 35
          Width = 86
          Height = 21
          Color = clInfoBk
          DataField = 'Iuser'
          DataSource = DS
          Enabled = False
          TabOrder = 0
        end
        object DBEdit9: TDBEdit
          Left = 275
          Top = 35
          Width = 162
          Height = 21
          Color = clInfoBk
          DataField = 'Idate'
          DataSource = DS
          Enabled = False
          TabOrder = 1
        end
        object DBEdit10: TDBEdit
          Left = 100
          Top = 70
          Width = 86
          Height = 21
          Color = clInfoBk
          DataField = 'Muser'
          DataSource = DS
          Enabled = False
          TabOrder = 2
        end
        object DBEdit11: TDBEdit
          Left = 275
          Top = 70
          Width = 162
          Height = 21
          Color = clInfoBk
          DataField = 'Mdate'
          DataSource = DS
          Enabled = False
          TabOrder = 3
        end
      end
    end
  end
end
