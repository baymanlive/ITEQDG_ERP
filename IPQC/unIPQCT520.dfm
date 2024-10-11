inherited FrmIPQCT520: TFrmIPQCT520
  Left = 404
  Top = 186
  Caption = 'FrmIPQCT520'
  ClientHeight = 660
  ClientWidth = 1016
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 1016
    TabOrder = 6
  end
  inherited Panel1: TPanel
    Width = 1016
    TabOrder = 7
  end
  object Chart1: TChart [2]
    Left = 60
    Top = 4
    Width = 620
    Height = 324
    AllowZoom = False
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    Legend.LegendStyle = lsSeries
    View3D = False
    TabOrder = 0
    OnDblClick = Chart1DblClick
  end
  object Chart2: TChart [3]
    Left = 685
    Top = 4
    Width = 325
    Height = 324
    AllowZoom = False
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      '')
    Title.Visible = False
    Legend.LegendStyle = lsSeries
    View3D = False
    TabOrder = 1
    Anchors = [akLeft, akTop, akRight]
    OnDblClick = Chart2DblClick
  end
  object Chart3: TChart [4]
    Left = 60
    Top = 334
    Width = 620
    Height = 280
    AllowZoom = False
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      'no')
    Title.Visible = False
    Legend.LegendStyle = lsSeries
    View3D = False
    TabOrder = 2
    OnDblClick = Chart3DblClick
  end
  object Chart4: TChart [5]
    Left = 685
    Top = 334
    Width = 325
    Height = 280
    AllowZoom = False
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      '')
    Title.Visible = False
    Legend.LegendStyle = lsSeries
    View3D = False
    TabOrder = 3
    Anchors = [akLeft, akTop, akRight]
    OnDblClick = Chart4DblClick
  end
  object Memo1: TMemo [6]
    Left = 60
    Top = 620
    Width = 950
    Height = 30
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    ParentColor = True
    PopupMenu = PopupMenu1
    ReadOnly = True
    TabOrder = 4
  end
  object rgp: TRadioGroup [7]
    Left = 4
    Top = 4
    Width = 50
    Height = 320
    ItemIndex = 0
    Items.Strings = (
      'T1'
      'T2'
      'T3'
      'T4'
      'T5')
    TabOrder = 5
    OnClick = rgpClick
  end
  object IdTCPClient1: TIdTCPClient
    MaxLineAction = maException
    ReadTimeout = 0
    OnDisconnected = IdTCPClient1Disconnected
    Port = 0
    Left = 762
    Top = 376
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 790
    Top = 375
    object N100: TMenuItem
      Caption = #21478#23384
      OnClick = N100Click
    end
  end
  object SaveDialog100: TSaveDialog
    DefaultExt = 'txt'
    Filter = #25991#26412#25991#20214'(*.txt)|*.txt'
    Left = 816
    Top = 377
  end
  object Timer100: TTimer
    Enabled = False
    Interval = 120000
    OnTimer = Timer100Timer
    Left = 792
    Top = 404
  end
  object IdUDPServer1: TIdUDPServer
    Bindings = <>
    DefaultPort = 0
    OnUDPRead = IdUDPServer1UDPRead
    Left = 762
    Top = 405
  end
end
