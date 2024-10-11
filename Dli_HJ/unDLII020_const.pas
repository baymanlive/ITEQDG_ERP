unit unDLII020_const;

interface

//送貨單主檔
const g_PrnCDS1Xml='<?xml version="1.0" standalone="yes"?>'
                  +'<DATAPACKET Version="2.0">'
                  +'<METADATA><FIELDS>'
                  +'<FIELD attrname="Dno" fieldtype="string" WIDTH="20"/>'             //出貨單右上角流水號
                  +'<FIELD attrname="Saleno" fieldtype="string" WIDTH="20"/>'          //鎖貨單號(此欄位名稱不可更改)
                  +'<FIELD attrname="Saleno1" fieldtype="string" WIDTH="20"/>'         //鎖貨單號(無單別)
                  +'<FIELD attrname="Saledate" fieldtype="date"/>'                     //鎖貨日期
                  +'<FIELD attrname="Saletype" fieldtype="string" WIDTH="40"/>'        //單別
                  +'<FIELD attrname="Salesno" fieldtype="string" WIDTH="20"/>'         //業務員編號
                  +'<FIELD attrname="Salesname" fieldtype="string" WIDTH="40"/>'       //業務員
                  +'<FIELD attrname="Deptno" fieldtype="string" WIDTH="20"/>'          //部門編號
                  +'<FIELD attrname="Dept" fieldtype="string" WIDTH="40"/>'            //部門
                  +'<FIELD attrname="Cashtype" fieldtype="string" WIDTH="10"/>'        //幣別
                  +'<FIELD attrname="Rate" fieldtype="string" WIDTH="10"/>'            //匯率
                  +'<FIELD attrname="Custno" fieldtype="string" WIDTH="10"/>'          //客戶編號
                  +'<FIELD attrname="Custabs" fieldtype="string" WIDTH="20"/>'         //客戶簡稱
                  +'<FIELD attrname="Custom" fieldtype="string" WIDTH="200"/>'         //客戶名稱
                  +'<FIELD attrname="Custno_addr" fieldtype="string" WIDTH="10"/>'     //送貨客戶編號
                  +'<FIELD attrname="SendAddr" fieldtype="string" WIDTH="400"/>'       //送貨地址
                  +'<FIELD attrname="Dealer" fieldtype="string" WIDTH="10"/>'          //制表人
                  +'<FIELD attrname="COC_user" fieldtype="string" WIDTH="10"/>'        //品保人
                  +'<FIELD attrname="Check_user" fieldtype="string" WIDTH="10"/>'      //發貨人
                  +'<FIELD attrname="Printcnt" fieldtype="string" WIDTH="10"/>'        //列印次數(此欄位名稱不可更改)
                  +'<FIELD attrname="QtyFormat" fieldtype="string" WIDTH="20"/>'       //數量格式化字串
                  +'<FIELD attrname="KgFormat" fieldtype="string" WIDTH="20"/>'        //單重格式化字串
                  +'<FIELD attrname="TotKgFormat" fieldtype="string" WIDTH="20"/>'     //總重格式化字串
                  +'<FIELD attrname="SfFormat" fieldtype="string" WIDTH="20"/>'        //面積格式化字串
                  +'<FIELD attrname="TotSfFormat" fieldtype="string" WIDTH="20"/>'     //總面積格式化字串
                  +'<FIELD attrname="QRCodeSaleno" fieldtype="string" WIDTH="400"/>'   //鎖貨單號2維碼
                  +'<FIELD attrname="MoreSaleno" fieldtype="string" WIDTH="1000"/>'    //出貨明細多個單號
                  +'<FIELD attrname="MXgfh" fieldtype="string" WIDTH="20"/>'           //名幸關封號
                  +'</FIELDS><PARAMS/></METADATA>'
                  +'<ROWDATA></ROWDATA>'
                  +'</DATAPACKET>';

//送貨單明細檔
const g_PrnCDS2Xml='<?xml version="1.0" standalone="yes"?>'
                  +'<DATAPACKET Version="2.0">'
                  +'<METADATA><FIELDS>'
                  +'<FIELD attrname="Dno" fieldtype="string" WIDTH="20"/>'          //流水號
                  +'<FIELD attrname="Ditem" fieldtype="string" WIDTH="20"/>'        //序號
                  +'<FIELD attrname="Orderno" fieldtype="string" WIDTH="20"/>'      //訂單單號
                  +'<FIELD attrname="Orderitem" fieldtype="string" WIDTH="10"/>'    //訂單項次
                  +'<FIELD attrname="Pno" fieldtype="string" WIDTH="40"/>'          //料號
                  +'<FIELD attrname="Pname" fieldtype="string" WIDTH="100"/>'       //品名
                  +'<FIELD attrname="Sizes" fieldtype="string" WIDTH="200"/>'       //規格
                  +'<FIELD attrname="C_Orderno" fieldtype="string" WIDTH="40"/>'    //客戶訂單號
                  +'<FIELD attrname="C_Pno" fieldtype="string" WIDTH="100"/>'       //客戶產品編號
                  +'<FIELD attrname="C_Sizes" fieldtype="string" WIDTH="200"/>'     //客戶品名規格
                  +'<FIELD attrname="Units" fieldtype="string" WIDTH="10"/>'        //單位
                  +'<FIELD attrname="Lot" fieldtype="string" WIDTH="4000"/>'        //批號(每個批號后回車換行連接)
                  +'<FIELD attrname="Qty" fieldtype="r8"/>'                         //數量
                  +'<FIELD attrname="Qty_m" fieldtype="r8"/>'                       //數量(pp米M)
                  +'<FIELD attrname="KG_old" fieldtype="r8"/>'                      //原始單重
                  +'<FIELD attrname="KG" fieldtype="r8"/>'                          //處理后單重(如PP卷已乘以米數)
                  +'<FIELD attrname="T_KG" fieldtype="r8"/>'                        //總重
                  +'<FIELD attrname="SF" fieldtype="r8"/>'                          //單位面積
                  +'<FIELD attrname="T_SF" fieldtype="r8"/>'                        //總面積
                  +'<FIELD attrname="Remark" fieldtype="string" WIDTH="400"/>'      //備註
                  +'<FIELD attrname="QRcode" fieldtype="string" WIDTH="400"/>'      //二維碼bmp圖片路徑
                  +'<FIELD attrname="PrdDate1" fieldtype="string" WIDTH="20"/>'     //生產日期(JP客戶送貨單)
                  +'</FIELDS><PARAMS/></METADATA>'
                  +'<ROWDATA></ROWDATA>'
                  +'</DATAPACKET>';

//二維碼
const g_QRCodeXml='<?xml version="1.0" standalone="yes"?>'
                 +'<DATAPACKET Version="2.0">'
                 +'<METADATA><FIELDS>'
                 +'<FIELD attrname="Saleno" fieldtype="string" WIDTH="20"/>'       //出貨單號
                 +'<FIELD attrname="Saleitem" fieldtype="i4"/>'                    //出貨項次
                 +'<FIELD attrname="Orderno" fieldtype="string" WIDTH="20"/>'      //訂單單號
                 +'<FIELD attrname="Orderitem" fieldtype="string" WIDTH="10"/>'    //訂單項次2
                 +'<FIELD attrname="OldOrderitem" fieldtype="string" WIDTH="10"/>' //原訂單項次(102)
                 +'<FIELD attrname="Custno" fieldtype="string" WIDTH="10"/>'       //客戶編號
                 +'<FIELD attrname="Custabs" fieldtype="string" WIDTH="20"/>'      //客戶簡稱
                 +'<FIELD attrname="Custom" fieldtype="string" WIDTH="200"/>'      //客戶名稱
                 +'<FIELD attrname="Pno" fieldtype="string" WIDTH="40"/>'          //料號
                 +'<FIELD attrname="Pname" fieldtype="string" WIDTH="100"/>'       //品名
                 +'<FIELD attrname="Sizes" fieldtype="string" WIDTH="200"/>'       //規格
                 +'<FIELD attrname="C_Orderno" fieldtype="string" WIDTH="40"/>'    //客戶訂單號
                 +'<FIELD attrname="C_Pno" fieldtype="string" WIDTH="100"/>'       //客戶產品編號
                 +'<FIELD attrname="C_Sizes" fieldtype="string" WIDTH="200"/>'     //客戶品名規格
                 +'<FIELD attrname="Units" fieldtype="string" WIDTH="10"/>'        //單位
                 +'<FIELD attrname="Qty" fieldtype="r8"/>'                         //數量
                 +'<FIELD attrname="Lot" fieldtype="string" WIDTH="20"/>'          //批號
                 +'<FIELD attrname="PrdDate1" fieldtype="string" WIDTH="20"/>'     //生產日期yyyymmdd
                 +'<FIELD attrname="PrdDate2" fieldtype="string" WIDTH="20"/>'     //生產日期yyyy-m-d
                 +'<FIELD attrname="LstDate1" fieldtype="string" WIDTH="20"/>'     //有效日期yyyymmdd
                 +'<FIELD attrname="LstDate2" fieldtype="string" WIDTH="20"/>'     //有效日期yyyy-m-d
                 +'<FIELD attrname="KG_old" fieldtype="r8"/>'                      //原始單重
                 +'<FIELD attrname="KG" fieldtype="r8"/>'                          //處理后單重(如PP卷已乘以米數)
                 +'<FIELD attrname="T_KG" fieldtype="r8"/>'                        //總重
                 +'<FIELD attrname="SPEC" fieldtype="string" WIDTH="200"/>'        //SPEC(客戶品名)
                 +'<FIELD attrname="OAO06" fieldtype="string" WIDTH="200"/>'       //訂單備注
                 +'<FIELD attrname="KB" fieldtype="string" WIDTH="200"/>'          //卡板編號
                 +'<FIELD attrname="QRcode" fieldtype="string" WIDTH="400"/>'      //二維碼bmp圖片路徑
                 +'<FIELD attrname="QRcode1" fieldtype="string" WIDTH="400"/>'      //二維碼bmp圖片路徑
                 +'</FIELDS><PARAMS/></METADATA>'
                 +'<ROWDATA></ROWDATA>'
                 +'</DATAPACKET>';

//二維碼批號xml
const g_lotxml='<?xml version="1.0" standalone="yes"?>'
              +'<DATAPACKET Version="2.0">'
              +'<METADATA><FIELDS>'
              +'<FIELD attrname="Saleno" fieldtype="string" WIDTH="20"/>'          //出貨單號
              +'<FIELD attrname="Saleitem" fieldtype="i4"/>'                       //出貨項次
              +'<FIELD attrname="Lot" fieldtype="string" WIDTH="20"/>'             //批號
              +'<FIELD attrname="Qty" fieldtype="r8"/>'                            //數量
              +'</FIELDS><PARAMS/></METADATA>'
              +'<ROWDATA></ROWDATA>'
              +'</DATAPACKET>';

const g_strHT='AC109/AC994/TW089';                 //華通
const g_strSY='AC084';                             //生益
const g_strCD='AC121/AC526/ACA97/AC820/AC305';     //崇達
const g_strKJ='AC103/AC625';                       //快捷
const g_strJW='AC132/AC425/ACA00';                 //景旺
const g_strCS='AC097/AC143';                       //超聲
const g_strSH='AC360/AC085';                       //勝宏
const g_strMX='AC096';                             //名幸
const g_strCY='AC075/AC405/AC950/AC310/AC311';     //超毅
const g_strSL='AC204/AC815';                       //深聯
const g_strSN='AC111';                             //深南
const g_strSG='AC091/AC117/ACC19';                 //3廣
const g_strWS='AC135/AC734';                       //維勝
const g_strJP='AC294';                             //敬鵬
const g_strJH='AC101';                             //競華
const g_strQCX='AC145';                            //全成信

implementation

end.
