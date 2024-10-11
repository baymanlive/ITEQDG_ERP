unit unMPST010_units;

interface

type
  POrderRec = ^ TOrderRec;
  TOrderRec = Record
    sdate,
    orderdate,
    orderno,
    orderitem,
    custno,
    custno2,
    custom,
    custom2,
    edate,
    adate,
    materialno,
    materialno1,
    pnlsize1,
    pnlsize2,
    orderqty,
    sqty,
    stealno,
    adCode,
    remainbooks,
    book_qty,
    lock,
    sdate1,
    machine1,
    boiler1,
    errorid,
    wono,
    orderno2,
    orderitem2,
    srcflag,
    oz,
    supplier,
    premark,
    premark2,
    premark3,
    regulateQty,
    sampleQty,
    pnlnum:         variant;    //pnlnum 表中無此欄位,保存PN板一開几
end;

const g_CDSxml='<?xml version="1.0" standalone="yes"?>'
              +'<DATAPACKET Version="2.0">'
              +'<METADATA><FIELDS>'
              +'<FIELD attrname="wono" fieldtype="string" WIDTH="10"/>'
              +'<FIELD attrname="orderno" fieldtype="string" WIDTH="10"/>'
              +'<FIELD attrname="orderdate" fieldtype="dateTime"/>'
              +'<FIELD attrname="orderitem" fieldtype="i4"/>'
              +'<FIELD attrname="materialno" fieldtype="string" WIDTH="20"/>'
              +'<FIELD attrname="materialno1" fieldtype="string" WIDTH="20"/>'
              +'<FIELD attrname="sqty" fieldtype="fixed" DECIMALS="3" WIDTH="15"/>'
              +'<FIELD attrname="orderQty" fieldtype="fixed" DECIMALS="3" WIDTH="15"/>'
              +'<FIELD attrname="regulateQty" fieldtype="fixed" DECIMALS="3" WIDTH="15"/>'
              +'<FIELD attrname="sampleQty" fieldtype="fixed" DECIMALS="3" WIDTH="15"/>'
              +'<FIELD attrname="edate" fieldtype="dateTime"/>'
              +'<FIELD attrname="adate" fieldtype="dateTime"/>'
              +'<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>'
              +'<FIELD attrname="custom" fieldtype="string" WIDTH="40"/>'
              +'<FIELD attrname="custom2" fieldtype="string" WIDTH="40"/>'
              +'<FIELD attrname="pnlsize1" fieldtype="fixed" DECIMALS="2" WIDTH="10"/>'
              +'<FIELD attrname="pnlsize2" fieldtype="fixed" DECIMALS="2" WIDTH="10"/>'
              +'<FIELD attrname="sdate1" fieldtype="dateTime"/>'
              +'<FIELD attrname="machine1" fieldtype="string" WIDTH="10"/>'
              +'<FIELD attrname="boiler1" fieldtype="i4"/>'
              +'<FIELD attrname="errorid" fieldtype="string" WIDTH="60"/>'
              +'<FIELD attrname="orderno2" fieldtype="string" WIDTH="10"/>'
              +'<FIELD attrname="orderitem2" fieldtype="i4"/>'
              +'<FIELD attrname="srcflag" fieldtype="i4"/>'
              +'<FIELD attrname="oz" fieldtype="string" WIDTH="10"/>'
              +'<FIELD attrname="supplier" fieldtype="string" WIDTH="10"/>'
              +'<FIELD attrname="premark" fieldtype="string" WIDTH="80"/>'
              +'<FIELD attrname="premark2" fieldtype="string" WIDTH="80"/>'
              +'<FIELD attrname="premark3" fieldtype="string" WIDTH="80"/>'
              +'<FIELD attrname="pnlnum" fieldtype="i4"/>'
              +'<FIELD attrname="custno2" fieldtype="string" WIDTH="50"/>'
              +'<FIELD attrname="custname2" fieldtype="string" WIDTH="50"/>'
              +'</FIELDS><PARAMS/></METADATA>'
              +'<ROWDATA></ROWDATA>'
              +'</DATAPACKET>';

const g_mps012pk='stype+''@''+cast(datepart(yy,sdate) as varchar(4))+''-''+cast(datepart(mm,sdate) as varchar(2))+''-''+cast(datepart(dd,sdate) as varchar(2))+''@''+cast(sno as varchar(10))';

implementation

end.
