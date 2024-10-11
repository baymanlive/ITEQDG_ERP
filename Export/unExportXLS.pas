unit unExportXLS;

interface

Uses
  Windows, Messages, SysUtils, Classes, StdCtrls, ComCtrls, ComObj, Controls,
  Forms, DB, ExcelXP, DBClient, Variants, Clipbrd;

type
  TExportXls = class
  private
    FDataSet:TDataSet;
    FRecNo:Integer;
    FList:TStrings;
    FArrFIndex: array [1..250] of Integer;          //�̤j250�C
    procedure AddHead(var xExcelApp:Variant; xRow:Integer);
    procedure AddRow(var xExcelApp:Variant; xRow:Integer);
    function GetRowData:string;
    procedure XlsAutoFit(var xExcelApp:Variant; Const ProcId:String='');
  public
    constructor Create(DataSet:TDataSet; FieldNameList:TStrings);
    destructor Destroy; override;
    procedure ToXls(Const ExportAll:Boolean=True; Const ProcId:String='');             //�v���g�Jexcel�ɥX(�C)
    procedure ToXls_Clipboard(Const ExportAll:Boolean=True; Const ProcId:String='');   //�ϥΨt�ΰŶK�O�߶K��k(��,�������q��Paste��k�|����)
    procedure ToXls_MPSI010;
    procedure ToXls_MPSI070;
  end;

implementation

uses unGlobal, unCommon;

{ TExportXls }

constructor TExportXls.Create(DataSet: TDataSet; FieldNameList: TStrings);
begin
  FDataSet:=DataSet;
  FRecNo:=DataSet.RecNo;
  FList:=FieldNameList;
end;

destructor TExportXls.Destroy;
begin

  inherited;
end;

//���Y�θ�Ʀ�m
procedure TExportXls.AddHead(var xExcelApp:Variant; xRow:Integer);
var
  x, y, z: Integer;
begin
  for x := 0 To FList.Count - 1 do
  for y := 0 To FDataSet.FieldCount - 1 do
  if ((FList.Strings[x] = FDataSet.Fields[y].DisplayLabel) and (FDataSet.Fields[y].Tag = 1)) then
  begin
    z:=x+1;
    xExcelApp.Cells[xRow,z].Value:=FDataSet.Fields[y].DisplayLabel;
    FArrFIndex[z] := y;
    Break;
  end;
end;

//�ƾ�
procedure TExportXls.AddRow(var xExcelApp:Variant; xRow:Integer);
var
  x, y, z: Integer;
  tmpStr, tmpTime: string;
begin
  with FDataSet do
  for x := 0 To FList.Count - 1 do
  begin
    z:=x+1;
    y := FArrFIndex[z];
    if not Fields[y].IsNull then
    begin
      tmpStr:='';
      if Fields[y].DataType in ([ftTime, ftDate, ftDateTime]) then
      begin
        if FormatDateTime('HHNN', Fields[y].Value)='0000' then
           tmpTime:='YYYY'+DateSeparator+'M'+DateSeparator+'D'
        else
           tmpTime:='YYYY'+DateSeparator+'M'+DateSeparator+'D HH:NN:SS';

        tmpStr:=FormatDateTime(tmpTime, Fields[y].Value);
      end
      else if Fields[y].DataType in ([ftString, ftWideString]) then
        tmpStr:=StringReplace(StringReplace(StringReplace(Fields[y].AsString,#13#10,'',[rfReplaceAll]),#9,'',[rfReplaceAll]),#10,'',[rfReplaceAll])
      else if Fields[y].DataType <> ftBlob then
        tmpStr:=Fields[y].AsString;

      xExcelApp.Cells[xRow,z].Value:=tmpStr;
    end;
  end;
end;

function TExportXls.GetRowData:string;
var
  x, y, z: Integer;
  tmpStr, tmpTime: string;
begin
  Result :='';
  with FDataSet do
  for x := 0 To FList.Count - 1 do
  begin
    z:=x+1;
    y := FArrFIndex[z];
    tmpStr:='';
    if not Fields[y].IsNull then
    begin
      if Fields[y].DataType in ([ftTime, ftDate, ftDateTime]) then
      begin
        if FormatDateTime('HHNN', Fields[y].Value)='0000' then
           tmpTime:='YYYY'+DateSeparator+'M'+DateSeparator+'D'
        else
           tmpTime:='YYYY'+DateSeparator+'M'+DateSeparator+'D HH:NN:SS';

        tmpStr:=FormatDateTime(tmpTime, Fields[y].Value);
      end
      else if Fields[y].DataType in ([ftString, ftWideString]) then
        tmpStr:=StringReplace(StringReplace(StringReplace(Fields[y].AsString,#13#10,'',[rfReplaceAll]),#9,'',[rfReplaceAll]),#10,'',[rfReplaceAll])
      else if Fields[y].DataType <> ftBlob then
        tmpStr:=Fields[y].AsString;
    end;

    Result:=Result+tmpStr+#9;  //VK_TAB
  end;
end;

//�榡��
procedure TExportXls.XlsAutoFit(var xExcelApp:Variant; Const ProcId:String='');
var
  i,j,n:Integer;
  ExcelSheet:Variant;
begin
  for j:=1 to xExcelApp.WorkSheets.Count do
  begin
    ExcelSheet:=xExcelApp.WorkSheets[j];
    ExcelSheet.Activate;
    for i := 0 to FList.Count - 1 do
    begin
      n := FArrFIndex[i+1];
      if FDataSet.Fields[n].DataType in [ftFloat, ftBCD, ftCurrency] then
      begin
        if not SameText(ProcId, 'DLIR120') then
           ExcelSheet.Columns[i+1].NumberFormat := '#,##0.00_ '
      end
      else if FDataSet.Fields[n].DataType in [ftDate, ftDateTime] then
         ExcelSheet.Columns[i+1].NumberFormat := 'yyyy'+DateSeparator+'m'+DateSeparator+'d'
      else if FDataSet.Fields[n].DataType in [ftAutoInc, ftSmallint, ftInteger, ftWord] then
         ExcelSheet.Columns[i+1].NumberFormat := '#,##0_ '
      else if FDataSet.Fields[n].DataType = ftTime then
         ExcelSheet.Columns[i+1].NumberFormat := 'h:mm'
      else
         ExcelSheet.Columns[i+1].NumberFormat := '@';
      ExcelSheet.Columns[i+1].Font.Size:=10;
    end;
    ExcelSheet.Rows[1].NumberFormat := '@';
    ExcelSheet.Columns.EntireColumn.AutoFit;
    ExcelSheet.Range['A2'].Select;
  end;

  xExcelApp.WorkSheets[1].Activate;
end;

//�v��ץX
procedure TExportXls.ToXls(Const ExportAll:Boolean=True; Const ProcId:String='');
var
  isOK:Boolean;
  H:HWND;
  i,j,tmpRow:Integer;
  tmpXlsCaption:string;
  ExcelApp:Variant;
begin
  try
    ExcelApp := CreateOleObject('Excel.Application');
  except
    ShowMsg('Create Excel Application Error',16);
    Exit;
  end;

  isOK:=False;
  Fillchar(FArrFIndex, SizeOf(FArrFIndex), -1);
  g_ProgressBar.Position:=0;
  g_ProgressBar.Max:=FDataSet.RecordCount;
  g_ProgressBar.Visible:=True;
  try      
    ExcelApp.Visible:=False;
    ExcelApp.DisplayAlerts:=False;
    ExcelApp.WorkBooks.Add;
    for i:=ExcelApp.WorkSheets.Count downto 2 do
    begin
      ExcelApp.WorkSheets[i].Select;
      ExcelApp.WorkSheets[i].Delete;
    end;
  
    ExcelApp.WorkSheets[1].Activate;
    AddHead(ExcelApp,1);
    for i := 0 to FList.Count - 1 do
    begin
      j:=i+1;
      if FDataSet.Fields[FArrFIndex[j]].DataType in ([ftString, ftWideString]) then
         ExcelApp.Columns[j].NumberFormat := '@';
    end;

    //�g�J�ƾ�
    if FDataSet.RecordCount>0 then
    begin
      tmpRow:=2;
      with FDataSet do
      begin
        if ExportAll then
        begin
          First;
          while not Eof do
          begin
            g_ProgressBar.Position:=g_ProgressBar.Position+1;
            Application.ProcessMessages;
            AddRow(ExcelApp,tmpRow);
            Next;
            Inc(tmpRow);
          end;
        end else
          AddRow(ExcelApp,tmpRow);
      end;
    end;

    XlsAutoFit(ExcelApp, ProcId);
    
    isOK:=True;
    ExcelApp.Visible:=True;
    tmpXlsCaption:=ExcelApp.Caption;
    H:=FindWindow(nil, PChar(tmpXlsCaption));
    if H>0 then
       SetForegroundWindow(H);
  finally
    g_ProgressBar.Visible:=False;
    if not isOK then
       ExcelApp.Quit;
  end;
end;

//�ŶK�O�ץX
procedure TExportXls.ToXls_Clipboard(Const ExportAll:Boolean=True; Const ProcId:String='');
var
  isOK:Boolean;
  H:HWND;
  i,j:Integer;
  tmpXlsCaption:string;
  tmpList:TStrings;
  ExcelApp:Variant;
begin
  try
    ExcelApp := CreateOleObject('Excel.Application');
  except
    ShowMsg('Create Excel Application Error',16);
    Exit;
  end;

  isOK:=False;
  Fillchar(FArrFIndex, SizeOf(FArrFIndex), -1);
  g_ProgressBar.Position:=0;
  g_ProgressBar.Max:=FDataSet.RecordCount;
  g_ProgressBar.Visible:=True;
  tmpList:=TStringList.Create;
  try
    ExcelApp.Visible:=False;
    ExcelApp.DisplayAlerts:=False;
    ExcelApp.WorkBooks.Add;
    for i:=ExcelApp.WorkSheets.Count downto 2 do
    begin
      ExcelApp.WorkSheets[i].Select;
      ExcelApp.WorkSheets[i].Delete;
    end;
  
    ExcelApp.WorkSheets[1].Activate;
    AddHead(ExcelApp,1);
    for i := 0 to FList.Count - 1 do
    begin
      j:=i+1;
      if FDataSet.Fields[FArrFIndex[j]].DataType in ([ftString, ftWideString]) then
         ExcelApp.Columns[j].NumberFormat := '@';
    end;

    if FDataSet.RecordCount>0 then
    begin
      //�g�J�ƾ�
      with FDataSet do
      begin
        if ExportAll then
        begin
          First;
          while not Eof do
          begin
            g_ProgressBar.Position:=g_ProgressBar.Position+1;
            Application.ProcessMessages;

            tmpList.Add(GetRowData);
            Next;
          end;
        end else
          tmpList.Add(GetRowData);
      end;

      Clipboard.Clear;
      SetClipboardText(tmpList.Text); //Clipboard.AsText:=FTmpList.Text;
      Sleep(500);                     //�����X�{���~:Class Worksheet �� Paste ��k����;�O�_�ӧְ��ߪO������?,���ɤ@�U
      ExcelApp.Range['A2'].Select;
      ExcelApp.ActiveSheet.Paste;
    end;
    
    XlsAutoFit(ExcelApp, ProcId);

    isOK:=True;
    ExcelApp.Visible:=True;
    tmpXlsCaption:=ExcelApp.Caption;
    H:=FindWindow(nil, PChar(tmpXlsCaption));
    if H>0 then
       SetForegroundWindow(H);
  finally
    g_ProgressBar.Visible:=False;
    Clipboard.Clear;
    FreeAndNil(tmpList);
    if not isOK then
       ExcelApp.Quit;
  end;
end;

//CCL�Ƶ{�@�~�S�w�榡
procedure TExportXls.ToXls_MPSI010;
var
  isOK:Boolean;
  H:HWND;
  i,j,tmpRow,tmpColorIndex:Integer;
  tmpMachine,tmpStealno,tmpMaxCol,tmpCellX,tmpCellY,tmpOrderno,tmpXlsCaption:string;
  tmpArrIsEmptyData:array of Boolean;
  ExcelApp:Variant;
  tmpList:TStrings;
begin
  try
    ExcelApp := CreateOleObject('Excel.Application');
  except
    ShowMsg('Create Excel Application Error',16);
    Exit;
  end;

  isOK:=False;
  tmpColorIndex:=35;
  Fillchar(FArrFIndex, SizeOf(FArrFIndex), -1);
  tmpMaxCol:=Chr(FList.Count+64);   //�̤j�C,A~Z(�ɥX�C����W�XZ)
  tmpList:=TStringList.Create;
  g_ProgressBar.Position:=0;
  g_ProgressBar.Max:=FDataSet.RecordCount;
  g_ProgressBar.Visible:=True;
  try
    GetMPSMachine;
    tmpList.DelimitedText:=g_MachineCCL;
    SetLength(tmpArrIsEmptyData,tmpList.Count);

    ExcelApp.Visible:=False;
    ExcelApp.DisplayAlerts:=False;
    ExcelApp.WorkBooks.Add;
    for i:=ExcelApp.WorkSheets.Count downto 2 do
    begin
      ExcelApp.WorkSheets[i].Select;
      ExcelApp.WorkSheets[i].Delete;
    end;

    //�]�wWorkSheets[1],�䥦�qWorkSheets[1]�ƻs
    ExcelApp.WorkSheets[1].Activate;
    ExcelApp.WorkSheets[1].Name:=tmpList.Strings[0];
    AddHead(ExcelApp,2);
    ExcelApp.Range['A2:'+tmpMaxCol+'2'].Interior.ColorIndex := tmpColorIndex;
    ExcelApp.Range['A2:'+tmpMaxCol+'2'].Interior.Pattern := xlSolid;
    ExcelApp.Range['A2:'+tmpMaxCol+'2'].Borders.LineStyle := xlContinuous;
    ExcelApp.Range['A2:'+tmpMaxCol+'2'].Borders.Weight := xlMedium;
    ExcelApp.Range['A2:'+tmpMaxCol+'2'].Borders.ColorIndex := xlAutomatic;
    if tmpMaxCol>'A' then
       ExcelApp.Range['A2:'+tmpMaxCol+'2'].Borders[xlInsideVertical].Weight := xlThin;
    for i := 0 to FList.Count - 1 do
    begin
      j:=i+1;
      if FDataSet.Fields[FArrFIndex[j]].DataType in ([ftString, ftWideString]) then
         ExcelApp.Columns[j].NumberFormat := '@';
    end;
    for i:=tmpList.Count-1 downto 1 do
    begin
      ExcelApp.WorkSheets[1].Select;
      ExcelApp.WorkSheets[1].Copy(After:=ExcelApp.WorkSheets[1]);
      ExcelApp.WorkSheets[2].Name:=tmpList.Strings[i];
    end;

    //�g�J�ƾ�
    for i:=0 to tmpList.Count-1 do
    begin
      ExcelApp.WorkSheets[i+1].Activate;
      tmpRow:=3;
      tmpCellX:='A3';
      tmpColorIndex:=35;
      tmpMachine:=tmpList.Strings[i];
      TClientDataSet(FDataSet).Filtered:=False;
      TClientDataSet(FDataSet).Filter:='Machine='+Quotedstr(tmpMachine)+' and (not (not ErrorFlag=0))';
      TClientDataSet(FDataSet).Filtered:=True;
      if TClientDataSet(FDataSet).FindField('spy') <> nil then
        TClientDataSet(FDataSet).IndexFieldNames:='Machine;Jitem;spy;OZ;Materialno;Simuver;Citem'
      else
        TClientDataSet(FDataSet).IndexFieldNames:='Machine;Jitem;OZ;Materialno;Simuver;Citem';
      with FDataSet do
      begin
        tmpArrIsEmptyData[i]:=IsEmpty;
        First;
        while not Eof do
        begin
          g_ProgressBar.Position:=g_ProgressBar.Position+1;
          Application.ProcessMessages;

          tmpStealno:=FieldByName('Stealno').AsString;
          tmpOrderno:=FieldByName('Orderno').AsString;
          AddRow(ExcelApp,tmpRow);
          Next;

          //���O���P:�]�m��ؽu�M����
          if Eof or (tmpStealno<>FieldByName('Stealno').AsString) then
          begin
            tmpCellY:=tmpMaxCol+IntToStr(tmpRow);
            if (Copy(tmpCellX,2,10)=Copy(tmpCellY,2,10)) and (tmpOrderno<>'') then  //�浧����(�A�K�[�@���Ū�,��ܥզ�)
            begin
              Inc(tmpRow);
              tmpCellY:=tmpMaxCol+IntToStr(tmpRow);
            end else
            begin
              ExcelApp.Range[tmpCellX+':'+tmpCellY].Interior.ColorIndex := tmpColorIndex;
              if tmpColorIndex=35 then
                 tmpColorIndex:=36
              else
                 tmpColorIndex:=35;
            end;
            ExcelApp.Range[tmpCellX+':'+tmpCellY].Interior.Pattern := xlSolid;

            ExcelApp.Range[tmpCellX+':'+tmpCellY].Borders.LineStyle := xlContinuous;
            ExcelApp.Range[tmpCellX+':'+tmpCellY].Borders.Weight := xlMedium;
            ExcelApp.Range[tmpCellX+':'+tmpCellY].Borders.ColorIndex := xlAutomatic;
            //Borders[xlEdgeLeft] xlEdgeRight xlEdgeTop xlEdgeBottom ��1 �k2 �W3 �U4
            //Borders[xlDiagonalDown] xlDiagonalUp ���U5\ �k�W6/

            if tmpCellX<>tmpCellY then                           //�h�C,����u
            begin
              ExcelApp.Range[tmpCellX+':'+tmpCellY].Borders[xlInsideVertical].LineStyle := xlContinuous;
              ExcelApp.Range[tmpCellX+':'+tmpCellY].Borders[xlInsideVertical].Weight := xlThin;
              ExcelApp.Range[tmpCellX+':'+tmpCellY].Borders[xlInsideVertical].ColorIndex := xlAutomatic;
            end;

            if (Copy(tmpCellX,2,10)<>Copy(tmpCellY,2,10)) then   //�h��,����u
            begin
              ExcelApp.Range[tmpCellX+':'+tmpCellY].Borders[xlInsideHorizontal].LineStyle := xlDot;
              ExcelApp.Range[tmpCellX+':'+tmpCellY].Borders[xlInsideHorizontal].Weight := xlThin;
              ExcelApp.Range[tmpCellX+':'+tmpCellY].Borders[xlInsideHorizontal].ColorIndex := xlAutomatic;
            end;

            tmpCellX:='A'+IntToStr(tmpRow+1);
          end;

          Inc(tmpRow);
        end;
        ExcelApp.Cells[tmpRow,1].Value:=CheckLang('��y');
        ExcelApp.Cells[tmpRow,4].Value:=CheckLang('��u');
        ExcelApp.Cells[tmpRow,6].Value:=CheckLang('�f��');
        ExcelApp.Cells[tmpRow,8].Value:=CheckLang('�ͺ�');
      end;
    end;

    XlsAutoFit(ExcelApp);
    for i:=1 to ExcelApp.WorkSheets.Count do
    begin
      ExcelApp.WorkSheets[i].Range['A1'].Value:=CheckLang('��s���:')+DateTimeToStr(Now);
      ExcelApp.WorkSheets[i].Range['E1'].Value:=ExcelApp.WorkSheets[i].Name+CheckLang('�u�Ͳ����Ǫ�');
    end;

    //�R���L�ƾڪ�WorkSheets,�Y���L�ƾ�,�O�d�Ĥ@��WorkSheets
    j:=1;
    for i:=Low(tmpArrIsEmptyData) to High(tmpArrIsEmptyData) do
    begin
      if not tmpArrIsEmptyData[i] then
      begin
        j:=0;
        Break;
      end;
    end;

    for i:=High(tmpArrIsEmptyData) downto j do
    if tmpArrIsEmptyData[i] then
    begin
      ExcelApp.WorkSheets[i+1].Select;
      ExcelApp.WorkSheets[i+1].Delete;
    end;

    ExcelApp.WorkSheets[1].Activate;

    isOK:=True;
    ExcelApp.Visible:=True;
    tmpXlsCaption:=ExcelApp.Caption;
    H:=FindWindow(nil, PChar(tmpXlsCaption));
    if H>0 then
       SetForegroundWindow(H);
  finally
    g_ProgressBar.Visible:=False;
    FreeAndNil(tmpList);
    if not isOK then
       ExcelApp.Quit;
  end;
end;

//PP�Ƶ{�@�~�S�w�榡
procedure TExportXls.ToXls_MPSI070;
var
  isOK:Boolean;
  H:HWND;
  i,j,tmpRow,tmpColorIndex:Integer;
  tmpMachine,tmpMaxCol,tmpCellX,tmpCellY,tmpXlsCaption:string;
  tmpSdate:TDateTime;
  tmpArrIsEmptyData:array of Boolean;
  ExcelApp:Variant;
  tmpList:TStrings;
begin
  try
    ExcelApp := CreateOleObject('Excel.Application');
  except
    ShowMsg('Create Excel Application Error',16);
    Exit;
  end;

  isOK:=False;
  tmpColorIndex:=35;
  Fillchar(FArrFIndex, SizeOf(FArrFIndex), -1);
  tmpMaxCol:=Chr(FList.Count+64);   //�̤j�C,A~Z(�ɥX�C����W�XZ)
  tmpList:=TStringList.Create;
  g_ProgressBar.Position:=0;
  g_ProgressBar.Max:=FDataSet.RecordCount;
  g_ProgressBar.Visible:=True;
  try
    GetMPSMachine;
    tmpList.DelimitedText:=g_MachinePP;
    SetLength(tmpArrIsEmptyData,tmpList.Count);

    ExcelApp.Visible:=False;
    ExcelApp.DisplayAlerts:=False;
    ExcelApp.WorkBooks.Add;
    for i:=ExcelApp.WorkSheets.Count downto 2 do
    begin
      ExcelApp.WorkSheets[i].Select;
      ExcelApp.WorkSheets[i].Delete;
    end;

    //�]�wWorkSheets[1],�䥦�qWorkSheets[1]�ƻs
    ExcelApp.WorkSheets[1].Activate;
    ExcelApp.WorkSheets[1].Name:=tmpList.Strings[0];
    AddHead(ExcelApp,2);
    ExcelApp.Range['A2:'+tmpMaxCol+'2'].Interior.ColorIndex := tmpColorIndex;
    ExcelApp.Range['A2:'+tmpMaxCol+'2'].Interior.Pattern := xlSolid;
    ExcelApp.Range['A2:'+tmpMaxCol+'2'].Borders.LineStyle := xlContinuous;
    ExcelApp.Range['A2:'+tmpMaxCol+'2'].Borders.Weight := xlMedium;
    ExcelApp.Range['A2:'+tmpMaxCol+'2'].Borders.ColorIndex := xlAutomatic;
    if tmpMaxCol>'A' then
       ExcelApp.Range['A2:'+tmpMaxCol+'2'].Borders[xlInsideVertical].Weight := xlThin;
    for i := 0 to FList.Count - 1 do
    begin
      j:=i+1;
      if FDataSet.Fields[FArrFIndex[j]].DataType in ([ftString, ftWideString]) then
         ExcelApp.Columns[j].NumberFormat := '@';
    end;
    for i:=tmpList.Count-1 downto 1 do
    begin
      ExcelApp.WorkSheets[1].Select;
      ExcelApp.WorkSheets[1].Copy(After:=ExcelApp.WorkSheets[1]);
      ExcelApp.WorkSheets[2].Name:=tmpList.Strings[i];
    end;

    //�g�J�ƾ�
    for i:=0 to tmpList.Count-1 do
    begin
      ExcelApp.WorkSheets[i+1].Activate;
      tmpRow:=3;
      tmpCellX:='A3';
      tmpColorIndex:=35;
      tmpMachine:=tmpList.Strings[i];
      TClientDataSet(FDataSet).Filtered:=False;
      TClientDataSet(FDataSet).Filter:='Machine='+Quotedstr(tmpMachine)+' and (not (not ErrorFlag=0))';
      TClientDataSet(FDataSet).Filtered:=True;
      TClientDataSet(FDataSet).AddIndex('xIndex', 'Machine;Sdate;Jitem;AD;FISno;RC;Fiber;Simuver;Citem', [ixCaseInsensitive], 'RC');
      TClientDataSet(FDataSet).IndexName:='xIndex';
      with FDataSet do
      begin
        tmpArrIsEmptyData[i]:=IsEmpty;
        First;
        while not Eof do
        begin
          g_ProgressBar.Position:=g_ProgressBar.Position+1;
          Application.ProcessMessages;

          tmpSdate:=FieldByName('Sdate').AsDateTime;
          AddRow(ExcelApp,tmpRow);
          Next;

          //�Ͳ�������P:�]�m��ؽu�M����
          if Eof or (tmpSdate<>FieldByName('Sdate').AsDateTime) then
          begin
            tmpCellY:=tmpMaxCol+IntToStr(tmpRow);
            ExcelApp.Range[tmpCellX+':'+tmpCellY].Interior.ColorIndex := tmpColorIndex;
            ExcelApp.Range[tmpCellX+':'+tmpCellY].Interior.Pattern := xlSolid;

            ExcelApp.Range[tmpCellX+':'+tmpCellY].Borders.LineStyle := xlContinuous;
            ExcelApp.Range[tmpCellX+':'+tmpCellY].Borders.Weight := xlMedium;
            ExcelApp.Range[tmpCellX+':'+tmpCellY].Borders.ColorIndex := xlAutomatic;
            //Borders[xlEdgeLeft] xlEdgeRight xlEdgeTop xlEdgeBottom ��1 �k2 �W3 �U4
            //Borders[xlDiagonalDown] xlDiagonalUp ���U5\ �k�W6/

            if tmpCellX<>tmpCellY then                           //�h�C,����u
            begin
              ExcelApp.Range[tmpCellX+':'+tmpCellY].Borders[xlInsideVertical].LineStyle := xlContinuous;
              ExcelApp.Range[tmpCellX+':'+tmpCellY].Borders[xlInsideVertical].Weight := xlThin;
              ExcelApp.Range[tmpCellX+':'+tmpCellY].Borders[xlInsideVertical].ColorIndex := xlAutomatic;
            end;

            if (Copy(tmpCellX,2,10)<>Copy(tmpCellY,2,10)) then   //�h��,����u
            begin
              ExcelApp.Range[tmpCellX+':'+tmpCellY].Borders[xlInsideHorizontal].LineStyle := xlDot;
              ExcelApp.Range[tmpCellX+':'+tmpCellY].Borders[xlInsideHorizontal].Weight := xlThin;
              ExcelApp.Range[tmpCellX+':'+tmpCellY].Borders[xlInsideHorizontal].ColorIndex := xlAutomatic;
            end;

            tmpCellX:='A'+IntToStr(tmpRow+1);
            if tmpColorIndex=35 then
               tmpColorIndex:=36
            else
               tmpColorIndex:=35;
          end;

          Inc(tmpRow);
        end;
        ExcelApp.Cells[tmpRow,1].Value:=CheckLang('��y');
        ExcelApp.Cells[tmpRow,4].Value:=CheckLang('��u');
        ExcelApp.Cells[tmpRow,6].Value:=CheckLang('�f��');
        ExcelApp.Cells[tmpRow,8].Value:=CheckLang('�ͺ�');
      end;
    end;

    XlsAutoFit(ExcelApp);
    for i:=1 to ExcelApp.WorkSheets.Count do
    begin
      ExcelApp.WorkSheets[i].Range['A1'].Value:=CheckLang('��s���:')+DateTimeToStr(Now);
      ExcelApp.WorkSheets[i].Range['E1'].Value:=ExcelApp.WorkSheets[i].Name+CheckLang('�u�Ͳ����Ǫ�');
    end;

    //�R���L�ƾڪ�WorkSheets,�Y���L�ƾ�,�O�d�Ĥ@��WorkSheets
    j:=1;
    for i:=Low(tmpArrIsEmptyData) to High(tmpArrIsEmptyData) do
    begin
      if not tmpArrIsEmptyData[i] then
      begin
        j:=0;
        Break;
      end;
    end;

    for i:=High(tmpArrIsEmptyData) downto j do
    if tmpArrIsEmptyData[i] then
    begin
      ExcelApp.WorkSheets[i+1].Select;
      ExcelApp.WorkSheets[i+1].Delete;
    end;

    ExcelApp.WorkSheets[1].Activate;

    isOK:=True;
    ExcelApp.Visible:=True;
    tmpXlsCaption:=ExcelApp.Caption;
    H:=FindWindow(nil, PChar(tmpXlsCaption));
    if H>0 then
       SetForegroundWindow(H);
  finally
    g_ProgressBar.Visible:=False;
    FreeAndNil(tmpList);
    if not isOK then
       ExcelApp.Quit;
  end;
end;

end.
