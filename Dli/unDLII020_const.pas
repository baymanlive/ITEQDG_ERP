unit unDLII020_const;

interface

//�e�f��D��
const g_PrnCDS1Xml='<?xml version="1.0" standalone="yes"?>'
                  +'<DATAPACKET Version="2.0">'
                  +'<METADATA><FIELDS>'
                  +'<FIELD attrname="IsSale" fieldtype="string" WIDTH="1"/>'               //�C�L�X�f��аO(y/n)
                  +'<FIELD attrname="Dno" fieldtype="string" WIDTH="20"/>'                 //�X�f��k�W���y����
                  +'<FIELD attrname="Saleno" fieldtype="string" WIDTH="20"/>'              //��f�渹
                  +'<FIELD attrname="Saleno1" fieldtype="string" WIDTH="20"/>'             //��f�渹(�L��O)
                  +'<FIELD attrname="Saledate" fieldtype="date"/>'                         //��f���
                  +'<FIELD attrname="Saletype" fieldtype="string" WIDTH="40"/>'            //��O
                  +'<FIELD attrname="Salesno" fieldtype="string" WIDTH="20"/>'             //�~�ȭ��s��
                  +'<FIELD attrname="Salesname" fieldtype="string" WIDTH="40"/>'           //�~�ȭ�
                  +'<FIELD attrname="Deptno" fieldtype="string" WIDTH="20"/>'              //�����s��
                  +'<FIELD attrname="Dept" fieldtype="string" WIDTH="40"/>'                //����
                  +'<FIELD attrname="Cashtype" fieldtype="string" WIDTH="10"/>'            //���O
                  +'<FIELD attrname="Rate" fieldtype="string" WIDTH="10"/>'                //�ײv
                  +'<FIELD attrname="Custno" fieldtype="string" WIDTH="10"/>'              //�Ȥ�s��
                  +'<FIELD attrname="Custabs" fieldtype="string" WIDTH="20"/>'             //�Ȥ�²��
                  +'<FIELD attrname="Custom" fieldtype="string" WIDTH="200"/>'             //�Ȥ�W��
                  +'<FIELD attrname="Custno_addr" fieldtype="string" WIDTH="10"/>'         //�e�f�Ȥ�s��
                  +'<FIELD attrname="SendAddr" fieldtype="string" WIDTH="400"/>'           //�e�f�a�}
                  +'<FIELD attrname="Dealer" fieldtype="string" WIDTH="10"/>'              //���H
                  +'<FIELD attrname="COC_user" fieldtype="string" WIDTH="10"/>'            //�~�O�H
                  +'<FIELD attrname="Check_user" fieldtype="string" WIDTH="10"/>'          //�o�f�H
                  +'<FIELD attrname="Printcnt" fieldtype="string" WIDTH="10"/>'            //�C�L����
                  +'<FIELD attrname="QtyFormat" fieldtype="string" WIDTH="20"/>'           //�ƶq�榡�Ʀr��
                  +'<FIELD attrname="KgFormat" fieldtype="string" WIDTH="20"/>'            //�歫�榡�Ʀr��
                  +'<FIELD attrname="TotKgFormat" fieldtype="string" WIDTH="20"/>'         //�`���榡�Ʀr��
                  +'<FIELD attrname="SfFormat" fieldtype="string" WIDTH="20"/>'            //���n�榡�Ʀr��
                  +'<FIELD attrname="TotSfFormat" fieldtype="string" WIDTH="20"/>'         //�`���n�榡�Ʀr��
                  +'<FIELD attrname="QRCodeSaleno" fieldtype="string" WIDTH="400"/>'       //��f�渹�G���X���|
                  +'<FIELD attrname="QRCodeCustno" fieldtype="string" WIDTH="400"/>'       //�Ȥ�ΤG���X���|
                  +'<FIELD attrname="QRCodeCustnoText" fieldtype="string" WIDTH="200"/>'   //�Ȥ�ΤG���X���e
                  +'<FIELD attrname="MoreSaleno" fieldtype="string" WIDTH="1000"/>'        //�X�f���Ӧh�ӳ渹
                  +'<FIELD attrname="MXgfh" fieldtype="string" WIDTH="20"/>'               //�W�����ʸ�
                  +'</FIELDS><PARAMS/></METADATA>'
                  +'<ROWDATA></ROWDATA>'
                  +'</DATAPACKET>';

//�e�f�������
const g_PrnCDS2Xml='<?xml version="1.0" standalone="yes"?>'
                  +'<DATAPACKET Version="2.0">'
                  +'<METADATA><FIELDS>'
                  +'<FIELD attrname="Dno" fieldtype="string" WIDTH="20"/>'          //�y����
                  +'<FIELD attrname="Ditem" fieldtype="string" WIDTH="20"/>'        //�Ǹ�
                  +'<FIELD attrname="Orderno" fieldtype="string" WIDTH="20"/>'      //�q��渹
                  +'<FIELD attrname="Orderitem" fieldtype="string" WIDTH="10"/>'    //�q�涵��
                  +'<FIELD attrname="Pno" fieldtype="string" WIDTH="40"/>'          //�Ƹ�
                  +'<FIELD attrname="Pname" fieldtype="string" WIDTH="100"/>'       //�~�W
                  +'<FIELD attrname="Sizes" fieldtype="string" WIDTH="200"/>'       //�W��
                  +'<FIELD attrname="C_Orderno" fieldtype="string" WIDTH="40"/>'    //�Ȥ�q�渹
                  +'<FIELD attrname="C_Pno" fieldtype="string" WIDTH="100"/>'       //�ȤᲣ�~�s��
                  +'<FIELD attrname="C_Sizes" fieldtype="string" WIDTH="200"/>'     //�Ȥ�~�W�W��
                  +'<FIELD attrname="Units" fieldtype="string" WIDTH="10"/>'        //���
                  +'<FIELD attrname="Lot" fieldtype="string" WIDTH="4000"/>'        //�帹(�C�ӧ帹�Z�^������s��)
                  +'<FIELD attrname="LotDate" fieldtype="string" WIDTH="4000"/>'    //�ͧ帹�����,���Ĥ��,�ƶq(�C�ӧ帹�Z�^������s��)
                  +'<FIELD attrname="Custprono" fieldtype="string" WIDTH="1000"/>'
                  +'<FIELD attrname="Qty" fieldtype="r8"/>'                         //�ƶq
                  +'<FIELD attrname="Qty_m" fieldtype="r8"/>'                       //�ƶq(pp��M)
                  +'<FIELD attrname="KG_old" fieldtype="r8"/>'                      //��l�歫
                  +'<FIELD attrname="KG" fieldtype="r8"/>'                          //�B�z�Z�歫(�pPP���w���H�̼�)
                  +'<FIELD attrname="T_KG" fieldtype="r8"/>'                        //�`��
                  +'<FIELD attrname="SF" fieldtype="r8"/>'                          //��쭱�n
                  +'<FIELD attrname="T_SF" fieldtype="r8"/>'                        //�`���n
                  +'<FIELD attrname="Remark" fieldtype="string" WIDTH="400"/>'      //�Ƶ�
                  +'<FIELD attrname="QRcode" fieldtype="string" WIDTH="400"/>'      //�G���Xbmp�Ϥ����|
                  +'<FIELD attrname="PrdDate1" fieldtype="string" WIDTH="40"/>'
                  +'<FIELD attrname="PrdDate2" fieldtype="string" WIDTH="40"/>'      
                  +'</FIELDS><PARAMS/></METADATA>'
                  +'<ROWDATA></ROWDATA>'
                  +'</DATAPACKET>';

//�G���X
const g_QRCodeXml='<?xml version="1.0" standalone="yes"?>'
                 +'<DATAPACKET Version="2.0">'
                 +'<METADATA><FIELDS>'
                 +'<FIELD attrname="Saleno" fieldtype="string" WIDTH="20"/>'       //�X�f�渹
                 +'<FIELD attrname="Saleitem" fieldtype="i4"/>'                    //�X�f����
                 +'<FIELD attrname="Orderno" fieldtype="string" WIDTH="20"/>'      //�q��渹
                 +'<FIELD attrname="Orderitem" fieldtype="string" WIDTH="10"/>'    //�q�涵��2
                 +'<FIELD attrname="OldOrderitem" fieldtype="string" WIDTH="10"/>' //��q�涵��(102)
                 +'<FIELD attrname="Custno" fieldtype="string" WIDTH="10"/>'       //�Ȥ�s��
                 +'<FIELD attrname="Custabs" fieldtype="string" WIDTH="20"/>'      //�Ȥ�²��
                 +'<FIELD attrname="Custom" fieldtype="string" WIDTH="200"/>'      //�Ȥ�W��
                 +'<FIELD attrname="Pno" fieldtype="string" WIDTH="40"/>'          //�Ƹ�
                 +'<FIELD attrname="Pname" fieldtype="string" WIDTH="100"/>'       //�~�W
                 +'<FIELD attrname="Sizes" fieldtype="string" WIDTH="200"/>'       //�W��
                 +'<FIELD attrname="C_Orderno" fieldtype="string" WIDTH="40"/>'    //�Ȥ�q�渹
                 +'<FIELD attrname="C_Pno" fieldtype="string" WIDTH="100"/>'       //�ȤᲣ�~�s��
                 +'<FIELD attrname="C_Sizes" fieldtype="string" WIDTH="200"/>'     //�Ȥ�~�W�W��
                 +'<FIELD attrname="Units" fieldtype="string" WIDTH="10"/>'        //���
                 +'<FIELD attrname="Qty" fieldtype="r8"/>'                         //�ƶq
                 +'<FIELD attrname="Lot" fieldtype="string" WIDTH="200"/>'         //�帹
                 +'<FIELD attrname="PrdDate1" fieldtype="string" WIDTH="200"/>'    //�Ͳ����yyyymmdd
                 +'<FIELD attrname="PrdDate2" fieldtype="string" WIDTH="200"/>'    //�Ͳ����yyyy-mm-dd
                 +'<FIELD attrname="LstDate1" fieldtype="string" WIDTH="200"/>'    //���Ĥ��yyyymmdd
                 +'<FIELD attrname="LstDate2" fieldtype="string" WIDTH="200"/>'    //���Ĥ��yyyy-mm-dd
                 +'<FIELD attrname="KG_old" fieldtype="r8"/>'                      //��l�歫
                 +'<FIELD attrname="KG" fieldtype="r8"/>'                          //�B�z�Z�歫(�pPP���w���H�̼�)
                 +'<FIELD attrname="T_KG" fieldtype="r8"/>'                        //�`��
                 +'<FIELD attrname="SPEC" fieldtype="string" WIDTH="200"/>'        //SPEC(�Ȥ�~�W)
                 +'<FIELD attrname="OAO06" fieldtype="string" WIDTH="200"/>'       //�q��ƪ`
                 +'<FIELD attrname="Memo" fieldtype="string" WIDTH="1000"/>'       //�ƪ`
                 +'<FIELD attrname="KB" fieldtype="string" WIDTH="200"/>'          //�d�O�s��
                 +'<FIELD attrname="QRcode" fieldtype="string" WIDTH="400"/>'      //�G���Xbmp�Ϥ����|
                 +'<FIELD attrname="Remark" fieldtype="string" WIDTH="400"/>'
                 +'<FIELD attrname="QRcode2" fieldtype="string" WIDTH="400"/>'      //�G���X���e     
                 +'</FIELDS><PARAMS/></METADATA>'
                 +'<ROWDATA></ROWDATA>'
                 +'</DATAPACKET>';

//�G���X�帹xml
const g_lotxml='<?xml version="1.0" standalone="yes"?>'
              +'<DATAPACKET Version="2.0">'
              +'<METADATA><FIELDS>'
              +'<FIELD attrname="Saleno" fieldtype="string" WIDTH="20"/>'          //�X�f�渹
              +'<FIELD attrname="Saleitem" fieldtype="i4"/>'                       //�X�f����
              +'<FIELD attrname="Lot" fieldtype="string" WIDTH="20"/>'             //�帹
              +'<FIELD attrname="Qty" fieldtype="r8"/>'                            //�ƶq
              +'</FIELDS><PARAMS/></METADATA>'
              +'<ROWDATA></ROWDATA>'
              +'</DATAPACKET>';

const g_strHT='AC109/AC994/TW089';                     //�سq
const g_strMY='AC133/ACA28/ACE06';                     //����
const g_strED='AC217/AH027';                           //���F
const g_strJS='AC452/ACB19';                           //�N��
const g_strSY='AC084/ACD04';                           //�ͯq,�N�w�ͯq
const g_strCD='AC121/AC526/ACA97/AC820/AC305/ACD57/ACG02';   //�R�F
const g_strKJ='AC103/AC625';                           //�ֱ�
const g_strJW='AC132/AC425/ACA00';                     //����
const g_strCS='AC097/AC143';                           //�W�n
const g_strSH='AC360/AC085';                           //�ӧ�(�ӵ�)
const g_strMX='AC096';                                 //�W��
const g_strCY='AC075/AC405/AC950/AC310/AC311';         //�W��
const g_strSL='AC204/AC815';                           //�`�p
const g_strSN='AC111';                                 //�`�n
const g_strSG='AC091/AC117/ACC19';                     //3�s
const g_strWS='AC135/AC734';                           //����
const g_strMR='AC082';                                 //���U
const g_strXQ='AC172';                                 //�Y�j
const g_strMW='AC178';                                 //����
const g_strTL='AC093';                                 //�K�Q
const g_strYD='AC151';                                 //�̹y
const g_strLN='AC002/AC072';                           //�p��
const g_strAC052_AC071='AC052/AC071';                  //�s�{�̧Q�w�F,�L�q���
const g_strZJ='ACC91/AC222/ACD53';                           //����
const g_strZF='AC136/ACA27';                           //���I
//const g_strFZ='AC114/AC365/AC388/AC687/AC434/ACD39';   //�西
const g_strJLS='AC152/AH036';                                //�ҧQ�h
const g_strJY='AC715';                                //�@��
const g_strKX='AC344/AC192/ACD80/ACD05/ACE87';                    //�쵾

implementation

end.
