unit unMPST070_cdsxml;

interface

const g_OrdXML='<?xml version="1.0" standalone="yes"?>'
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
              +'<FIELD attrname="edate" fieldtype="dateTime"/>'
              +'<FIELD attrname="adate" fieldtype="dateTime"/>'
              +'<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>'
              +'<FIELD attrname="custom" fieldtype="string" WIDTH="40"/>'
              +'<FIELD attrname="custom2" fieldtype="string" WIDTH="40"/>'
              +'<FIELD attrname="pnlsize1" fieldtype="fixed" DECIMALS="2" WIDTH="10"/>'
              +'<FIELD attrname="pnlsize2" fieldtype="fixed" DECIMALS="2" WIDTH="10"/>'
              +'<FIELD attrname="sdate1" fieldtype="dateTime"/>'
              +'<FIELD attrname="machine1" fieldtype="string" WIDTH="10"/>'
              +'<FIELD attrname="errorid" fieldtype="string" WIDTH="30"/>'
              +'<FIELD attrname="orderno2" fieldtype="string" WIDTH="10"/>'
              +'<FIELD attrname="orderitem2" fieldtype="i4"/>'
              +'<FIELD attrname="srcflag" fieldtype="i4"/>'
              +'<FIELD attrname="pnlnum" fieldtype="i4"/>'
              +'<FIELD attrname="unit" fieldtype="string" WIDTH="10"/>'
              +'<FIELD attrname="oao06" fieldtype="string" WIDTH="100"/>'
              +'</FIELDS><PARAMS/></METADATA>'
              +'<ROWDATA></ROWDATA>'
              +'</DATAPACKET>';

const g_DiffCoreXML='<?xml version="1.0" standalone="yes"?>'
                   +'<DATAPACKET Version="2.0">'
                   +'<METADATA><FIELDS>'
                   +'<FIELD attrname="materialno" fieldtype="string" WIDTH="20"/>'
                   +'<FIELD attrname="machine" fieldtype="string" WIDTH="10"/>'
                   +'<FIELD attrname="sdate" fieldtype="dateTime"/>'
                   +'<FIELD attrname="sqty" fieldtype="fixed" DECIMALS="3" WIDTH="15"/>'
                   +'<FIELD attrname="adate" fieldtype="dateTime"/>'
                   +'<FIELD attrname="remark1" fieldtype="string" WIDTH="200"/>'
                   +'<FIELD attrname="remark2" fieldtype="string" WIDTH="200"/>'
                   +'<FIELD attrname="remark3" fieldtype="string" WIDTH="200"/>'
                   +'<FIELD attrname="remark4" fieldtype="string" WIDTH="200"/>'
                   +'<FIELD attrname="remark5" fieldtype="string" WIDTH="200"/>'
                   +'</FIELDS><PARAMS/></METADATA>'
                   +'<ROWDATA></ROWDATA>'
                   +'</DATAPACKET>';

implementation

end.
