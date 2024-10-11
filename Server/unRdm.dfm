object Rdm: TRdm
  OldCreateOrder = False
  Left = 205
  Top = 129
  Height = 288
  Width = 337
  object FADOStoredProc: TADOStoredProc
    CommandTimeout = 300
    Parameters = <>
    Left = 44
    Top = 16
  end
  object FADOCommand: TADOCommand
    CommandTimeout = 300
    Parameters = <>
    ParamCheck = False
    Left = 40
    Top = 80
  end
  object FADOQuery: TADOQuery
    CommandTimeout = 300
    Parameters = <>
    Left = 136
    Top = 80
  end
  object FDsp: TDataSetProvider
    DataSet = FADOQuery
    OnUpdateError = FDspUpdateError
    Left = 136
    Top = 12
  end
end
