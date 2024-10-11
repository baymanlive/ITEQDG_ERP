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
          Height = 360
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
        object GroupBox2: TGroupBox
          Left = 225
          Top = 15
          Width = 170
          Height = 360
          Caption = #36039#26448#20316#26989
          TabOrder = 6
          object RightX: TDBCheckBox
            Left = 10
            Top = 25
            Width = 140
            Height = 17
            Caption = #36039#26448#20316#26989
            DataField = 'RightX'
            DataSource = DS
            TabOrder = 0
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightX1: TDBCheckBox
            Left = 25
            Top = 50
            Width = 140
            Height = 17
            Caption = #25104#21697'/'#21322#25104#21697#30332#26009
            DataField = 'RightX1'
            DataSource = DS
            TabOrder = 1
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightX3: TDBCheckBox
            Left = 25
            Top = 100
            Width = 140
            Height = 17
            Caption = #26855#26495#31649#29702
            DataField = 'RightX3'
            DataSource = DS
            TabOrder = 3
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightX2: TDBCheckBox
            Left = 25
            Top = 75
            Width = 140
            Height = 17
            Caption = #36865#36008#21934#31649#29702
            DataField = 'RightX2'
            DataSource = DS
            TabOrder = 2
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightX4: TDBCheckBox
            Left = 25
            Top = 125
            Width = 140
            Height = 17
            Caption = #20986#36008#27298#26680
            DataField = 'RightX4'
            DataSource = DS
            TabOrder = 4
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightX5: TDBCheckBox
            Left = 25
            Top = 150
            Width = 140
            Height = 17
            Caption = #24235#23384#30436#40670
            DataField = 'RightX5'
            DataSource = DS
            TabOrder = 5
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightX6: TDBCheckBox
            Left = 25
            Top = 175
            Width = 140
            Height = 17
            Caption = #19978#33184#20633#26009
            DataField = 'RightX6'
            DataSource = DS
            TabOrder = 6
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightX7: TDBCheckBox
            Left = 25
            Top = 200
            Width = 140
            Height = 17
            Caption = #25104#21697'/'#21322#25104#21697#25910#26009
            DataField = 'RightX7'
            DataSource = DS
            TabOrder = 7
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightX71: TDBCheckBox
            Left = 45
            Top = 225
            Width = 88
            Height = 17
            Caption = #25505#36092#25910#26009
            DataField = 'RightX71'
            DataSource = DS
            TabOrder = 8
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightX72: TDBCheckBox
            Left = 45
            Top = 250
            Width = 88
            Height = 17
            Caption = #29983#29986#25910#26009
            DataField = 'RightX72'
            DataSource = DS
            TabOrder = 9
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightX8: TDBCheckBox
            Left = 25
            Top = 275
            Width = 140
            Height = 17
            Caption = #20786#20301#35519#25300
            DataField = 'RightX8'
            DataSource = DS
            TabOrder = 10
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightX9: TDBCheckBox
            Left = 25
            Top = 300
            Width = 140
            Height = 17
            Caption = #33258#21205#20489#19978#12289#19979#26550
            DataField = 'RightX9'
            DataSource = DS
            TabOrder = 11
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightX10: TDBCheckBox
            Left = 25
            Top = 325
            Width = 140
            Height = 17
            Caption = #30332#26009#27298#26597
            DataField = 'RightX10'
            DataSource = DS
            TabOrder = 12
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
        end
        object GroupBox3: TGroupBox
          Left = 400
          Top = 15
          Width = 170
          Height = 360
          Caption = 'COC'#20316#26989
          TabOrder = 7
          object RightY: TDBCheckBox
            Left = 9
            Top = 25
            Width = 140
            Height = 17
            Caption = 'COC'#20316#26989
            DataField = 'RightY'
            DataSource = DS
            TabOrder = 0
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightY1: TDBCheckBox
            Left = 25
            Top = 50
            Width = 140
            Height = 17
            Caption = 'COC'#25209#34399#25475#25551
            DataField = 'RightY1'
            DataSource = DS
            TabOrder = 1
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightY2: TDBCheckBox
            Left = 25
            Top = 75
            Width = 140
            Height = 17
            Caption = 'COC'#30064#24120#34389#29702
            DataField = 'RightY2'
            DataSource = DS
            TabOrder = 2
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightY3: TDBCheckBox
            Left = 25
            Top = 100
            Width = 140
            Height = 17
            Caption = #23458#25142#20108#32173#30908#27298#26597
            DataField = 'RightY3'
            DataSource = DS
            TabOrder = 3
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
        end
        object GroupBox4: TGroupBox
          Left = 575
          Top = 15
          Width = 170
          Height = 360
          Caption = #21046#36896#20316#26989
          TabOrder = 8
          object RightZ: TDBCheckBox
            Left = 10
            Top = 25
            Width = 140
            Height = 17
            Caption = #21046#36896#20316#26989
            DataField = 'RightZ'
            DataSource = DS
            TabOrder = 0
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightZ1: TDBCheckBox
            Left = 25
            Top = 50
            Width = 140
            Height = 17
            Caption = #20006#21253#30906#35469#25475#25551
            DataField = 'RightZ1'
            DataSource = DS
            TabOrder = 1
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightZ2: TDBCheckBox
            Left = 25
            Top = 75
            Width = 140
            Height = 17
            Caption = #21253#35037#31449#25475#25551
            DataField = 'RightZ2'
            DataSource = DS
            TabOrder = 2
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightZ3: TDBCheckBox
            Left = 25
            Top = 100
            Width = 140
            Height = 17
            Caption = #24037#21934#21462#27171#25475#25551
            DataField = 'RightZ3'
            DataSource = DS
            TabOrder = 3
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightZ4: TDBCheckBox
            Left = 25
            Top = 125
            Width = 140
            Height = 17
            Caption = #22739#21512#25286#21368#25475#25551
            DataField = 'RightZ4'
            DataSource = DS
            TabOrder = 4
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightZ5: TDBCheckBox
            Left = 25
            Top = 150
            Width = 140
            Height = 17
            Caption = 'PP'#22577#24037
            DataField = 'RightZ5'
            DataSource = DS
            TabOrder = 5
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
        object GroupBox1: TGroupBox
          Left = 750
          Top = 15
          Width = 170
          Height = 360
          Caption = #21123#33184#20316#26989
          TabOrder = 9
          object RightA: TDBCheckBox
            Left = 9
            Top = 25
            Width = 140
            Height = 17
            Caption = #21123#33184#20316#26989
            DataField = 'RightA'
            DataSource = DS
            TabOrder = 0
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object RightA1: TDBCheckBox
            Left = 25
            Top = 50
            Width = 140
            Height = 17
            Caption = 'IT968'#37325#24037#25475#25551
            DataField = 'RightA1'
            DataSource = DS
            TabOrder = 1
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
