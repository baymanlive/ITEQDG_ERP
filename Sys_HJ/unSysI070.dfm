inherited FrmSysI070: TFrmSysI070
  Caption = 'FrmSysI070'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PCL: TPageControl
    inherited TabSheet1: TTabSheet
      inherited Pnl1: TPanel
        object UserId: TLabel
          Left = 18
          Top = 38
          Width = 68
          Height = 13
          Alignment = taRightJustify
          Caption = #20351#29992#32773#24115#34399':'
          FocusControl = DBEdit1
        end
        object Wk_no: TLabel
          Left = 18
          Top = 73
          Width = 68
          Height = 13
          Alignment = taRightJustify
          Caption = #20351#29992#32773#24037#34399':'
          FocusControl = DBEdit2
        end
        object Password: TLabel
          Left = 57
          Top = 143
          Width = 29
          Height = 13
          Alignment = taRightJustify
          Caption = #23494#30908':'
          FocusControl = DBEdit3
        end
        object Bevel3: TBevel
          Left = 208
          Top = 8
          Width = 5
          Height = 450
          Shape = bsLeftLine
        end
        object Coc_no: TLabel
          Left = 6
          Top = 178
          Width = 80
          Height = 13
          Alignment = taRightJustify
          Caption = 'COC'#25991#20214#32232#34399':'
          FocusControl = DBEdit4
        end
        object username: TLabel
          Left = 18
          Top = 108
          Width = 68
          Height = 13
          Alignment = taRightJustify
          Caption = #20351#29992#32773#22995#21517':'
          FocusControl = DBEdit5
        end
        object DBEdit1: TDBEdit
          Left = 90
          Top = 35
          Width = 100
          Height = 21
          DataField = 'UserId'
          DataSource = DS
          TabOrder = 0
        end
        object DBEdit2: TDBEdit
          Left = 90
          Top = 70
          Width = 100
          Height = 21
          DataField = 'Wk_no'
          DataSource = DS
          TabOrder = 1
        end
        object DBEdit3: TDBEdit
          Left = 90
          Top = 140
          Width = 100
          Height = 21
          DataField = 'Password'
          DataSource = DS
          PasswordChar = '*'
          TabOrder = 3
        end
        object not_use: TDBCheckBox
          Left = 90
          Top = 210
          Width = 97
          Height = 17
          Caption = #20572#29992
          DataField = 'not_use'
          DataSource = DS
          TabOrder = 5
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object GroupBox1: TGroupBox
          Left = 230
          Top = 15
          Width = 170
          Height = 420
          Caption = #25910#26009
          TabOrder = 6
          object RightA: TDBCheckBox
            Left = 10
            Top = 25
            Width = 140
            Height = 17
            Caption = #25910#26009#20316#26989
            DataField = 'RightA'
            DataSource = DS
            TabOrder = 0
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
        end
        object GroupBox2: TGroupBox
          Left = 405
          Top = 15
          Width = 170
          Height = 420
          Caption = #30332#26009
          TabOrder = 7
          object RightB: TDBCheckBox
            Left = 10
            Top = 25
            Width = 140
            Height = 17
            Caption = #30332#26009#20316#26989
            DataField = 'RightB'
            DataSource = DS
            TabOrder = 0
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightB1: TDBCheckBox
            Left = 25
            Top = 50
            Width = 140
            Height = 17
            Caption = 'M/L'#25209#34399#25475#25551
            DataField = 'RightB1'
            DataSource = DS
            TabOrder = 1
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightB3: TDBCheckBox
            Left = 25
            Top = 100
            Width = 140
            Height = 17
            Caption = 'M/L'#20986#36008#30906#35469
            DataField = 'RightB3'
            DataSource = DS
            TabOrder = 3
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightB2: TDBCheckBox
            Left = 25
            Top = 75
            Width = 140
            Height = 17
            Caption = #37569#22522#26495#25209#34399#25475#25551
            DataField = 'RightB2'
            DataSource = DS
            TabOrder = 2
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightB4: TDBCheckBox
            Left = 25
            Top = 125
            Width = 140
            Height = 17
            Caption = #37569#22522#26495#20986#36008#30906#35469
            DataField = 'RightB4'
            DataSource = DS
            TabOrder = 4
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightB5: TDBCheckBox
            Left = 25
            Top = 150
            Width = 140
            Height = 17
            Caption = #24182#21253#30906#35469
            DataField = 'RightB5'
            DataSource = DS
            TabOrder = 5
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
        end
        object GroupBox3: TGroupBox
          Left = 580
          Top = 15
          Width = 170
          Height = 420
          Caption = 'COC'
          TabOrder = 8
          object RightC: TDBCheckBox
            Left = 9
            Top = 25
            Width = 140
            Height = 17
            Caption = 'COC'#20316#26989
            DataField = 'RightC'
            DataSource = DS
            TabOrder = 0
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightC1: TDBCheckBox
            Left = 25
            Top = 50
            Width = 140
            Height = 17
            Caption = 'COC'#25209#34399#25475#25551
            DataField = 'RightC1'
            DataSource = DS
            TabOrder = 1
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightC2: TDBCheckBox
            Left = 25
            Top = 75
            Width = 140
            Height = 17
            Caption = 'COC'#30064#24120#34389#29702
            DataField = 'RightC2'
            DataSource = DS
            TabOrder = 2
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
        end
        object DBEdit4: TDBEdit
          Left = 90
          Top = 175
          Width = 100
          Height = 21
          DataField = 'Coc_no'
          DataSource = DS
          TabOrder = 4
        end
        object DBEdit5: TDBEdit
          Left = 90
          Top = 105
          Width = 100
          Height = 21
          DataField = 'username'
          DataSource = DS
          TabOrder = 2
        end
        object GroupBox4: TGroupBox
          Left = 755
          Top = 15
          Width = 170
          Height = 420
          Caption = #27966#36554
          TabOrder = 9
          object RightD: TDBCheckBox
            Left = 9
            Top = 25
            Width = 140
            Height = 17
            Caption = #20986#36008#21934#31649#29702
            DataField = 'RightD'
            DataSource = DS
            TabOrder = 0
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightD1: TDBCheckBox
            Left = 25
            Top = 50
            Width = 140
            Height = 17
            Caption = #20986#24288
            DataField = 'RightD1'
            DataSource = DS
            TabOrder = 1
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightD2: TDBCheckBox
            Left = 25
            Top = 75
            Width = 140
            Height = 17
            Caption = #22238#32879
            DataField = 'RightD2'
            DataSource = DS
            TabOrder = 2
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
        end
      end
    end
    inherited TabSheet2: TTabSheet
      inherited Pnl2: TPanel
        Height = 412
        object Iuser: TLabel
          Left = 38
          Top = 38
          Width = 49
          Height = 13
          Alignment = taRightJustify
          Caption = #26032#22686'user:'
        end
        object Idate: TLabel
          Left = 192
          Top = 38
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = #24314#27284#26085#26399':'
        end
        object Muser: TLabel
          Left = 38
          Top = 68
          Width = 49
          Height = 13
          Alignment = taRightJustify
          Caption = #20462#25913'user:'
        end
        object Mdate: TLabel
          Left = 192
          Top = 68
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = #20462#25913#26085#26399':'
        end
        object DBEdit8: TDBEdit
          Left = 90
          Top = 35
          Width = 80
          Height = 21
          Hint = #24115#34399
          Color = clYellow
          DataField = 'Iuser'
          DataSource = DS
          Enabled = False
          TabOrder = 0
        end
        object DBEdit9: TDBEdit
          Left = 250
          Top = 35
          Width = 150
          Height = 21
          Hint = #24115#34399
          Color = clYellow
          DataField = 'Idate'
          DataSource = DS
          Enabled = False
          TabOrder = 1
        end
        object DBEdit10: TDBEdit
          Left = 90
          Top = 65
          Width = 80
          Height = 21
          Hint = #24115#34399
          Color = clYellow
          DataField = 'Muser'
          DataSource = DS
          Enabled = False
          TabOrder = 2
        end
        object DBEdit11: TDBEdit
          Left = 250
          Top = 65
          Width = 150
          Height = 21
          Hint = #24115#34399
          Color = clYellow
          DataField = 'Mdate'
          DataSource = DS
          Enabled = False
          TabOrder = 3
        end
      end
    end
  end
end
