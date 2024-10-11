object ServerMethods: TServerMethods
  OldCreateOrder = False
  Height = 288
  Width = 313
  object FDsp: TDataSetProvider
    DataSet = FADOQuery
    OnUpdateError = FDspUpdateError
    Left = 236
    Top = 28
  end
  object FADOQuery: TADOQuery
    CommandTimeout = 300
    Parameters = <>
    Left = 32
    Top = 28
  end
  object FADOCommand: TADOCommand
    CommandTimeout = 300
    Parameters = <>
    Left = 132
    Top = 28
  end
end
