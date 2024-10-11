unit TWODbarcode;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ExtCtrls;
 const
  PT_QRENCODE_FAIL             =$00000000; //An operation is Failed.
  PT_QRENCODE_SUCCESS          =$00000001; //An operation is successful.
  PT_QRENCODE_ALLOC_ERROR      =$00000200; //Error while allocating the memory.
  PT_QRENCODE_DATA_BIG         =$00000201; //Data to be encoded is too big.
  PT_QRENCODE_SIZE_SMALL       =$00000202; //The size of image to be pasted the symbol is too small.
  PT_QRENCODE_IMAGE_INVALID    =$00000203; //The image to be pasted is invalid.

  //QR Code ECC level constants
  PT_QR_ECCLEVEL_L	        =$0001; //Use ECC level L. (7% )
  PT_QR_ECCLEVEL_M          =$0000; //Use ECC level M. (15%)
  PT_QR_ECCLEVEL_Q          =$0003; //Use ECC level Q. (25%)
  PT_QR_ECCLEVEL_H	        =$0002; //Use ECC level H. (30%)

  //QR Code version constants
  PT_QR_VERSION_AUTO         =$0000; //Determine the version by the engine,then use the smallest version that can contain the data.

  //QR Code mask number constants
  PT_QR_MASKNUMBER_AUTO      =$0008; //Determine the mask number by the engine.
type
  pPTQRENCODESTRUCT=^PTQRENCODESTRUCT;
  PTQRENCODESTRUCT = record
        pData :              PChar ;    //Pointer to the data to be encoded.
        nDataLength :        Integer ;  //Length of the data in bytes.
        wVersion:            Smallint ;  //The version of the QR Code.
        wMaskNumber:         Smallint ;	//The mask number of the QR Code.
        wEccLevel  :         Smallint	; //Determines the ECC level for encoding a QR Code symbol.
        wModule  :           Smallint	; //The smallest element size in pixels.
        wGroupTotal :        Smallint	; //The number of symbols that belong to the group.
        wGroupIndex :        Smallint	; //The index of the symbol in the group
        wLeftSpace :         Smallint	; //The left   space of the symbol in pixels while generating Image.
        wRightSpace :        Smallint	; //The right  space of the symbol in pixels while generating Image.
        wTopSpace :          Smallint	; //The top    space of the symbol in pixels while generating Image.
        wBottomSpace :       Smallint	; //The bottom space of the symbol in pixels while generating Image.
 End;
 const
   PT_IMAGERW_FAIL                   =$00000000; //An error occured in an operation.
   PT_IMAGERW_SUCCESS                =$00000001; //An operation is successful.
   PT_IMAGERW_ALLOC_ERROR            =$00000100; //Error while allocating memory.
   PT_IMAGERW_FORMAT_UNSUPPORTED     =$00000101; //The format of image is unsupported.

Type
   pPTIMAGESTRUCT=^PTIMAGESTRUCT  ;
   PTIMAGESTRUCT = record
        dwWidth  :     DWORD;     //The width of the image in pixels.
        dwHeight :     DWORD;     //The height of the image in pixels.
        pBits :        PByte ;    //Pointer to the image data.
        pPalette:      PByte;     //Pointer to the palette data (RGBQUAD)for 1,4,8 bit image.
        wBitsPerPixel: Smallint   //Number of bits per pixel.
End;

  Procedure PTQREncodeInit(pEncode : pPTQRENCODESTRUCT) ;
        stdcall; far; external 'PtQREncode.dll' name 'PtQREncodeInit';
  Function PtQREncode(pEncode : pPTQRENCODESTRUCT; pImage : pPTIMAGESTRUCT) : Integer;
        stdcall; far; external 'PtQREncode.dll' name 'PtQREncode';
  Function PtQREncodeToImage(pEncode : pPTQRENCODESTRUCT; pImage : pPTIMAGESTRUCT;
                                 StartX:Integer; StartY : Integer) : Integer;
        stdcall; far; external 'PtQREncode.dll' name 'PtQREncodeToImage';


  Procedure PtInitImage(pImage : pPTIMAGESTRUCT);
        stdcall; far; external 'PtImageRW.dll' name 'PtInitImage';
  Function PtLoadImage(fileName : String; pImage : pPTIMAGESTRUCT;  FrameIndex: DWORD) : Integer;
      stdcall; far; external 'PtImageRW.dll' name 'PtLoadImage';
  Function PtSaveImage( fileName : String; pImage : pPTIMAGESTRUCT) : Integer;
      stdcall; far; external 'PtImageRW.dll' name 'PtSaveImage';
  Function PtCreateImage( pImage : pPTIMAGESTRUCT; ImageSize: DWORD; PaletteSize:DWORD ) : Integer;
      stdcall; far; external 'PtImageRW.dll' name 'PtCreateImage';
  Procedure PtFreeImage(pImage : pPTIMAGESTRUCT);
      stdcall; far; external 'PtImageRW.dll' name 'PtFreeImage';
  function getcode(codestr,filename:string;m_image : PTIMAGESTRUCT):Boolean;
implementation
  function getcode(codestr,filename:string;m_image : PTIMAGESTRUCT):Boolean;
  var
  ret : integer;
  m_encode : PTQRENCODESTRUCT;
begin
  PtQREncodeInit(@m_encode);
  m_encode.pData := pChar(codestr);
  m_encode.nDataLength :=lstrlen(m_encode.pData);
  ret := PtQREncode(@m_encode, @m_image);
  If ret <> PT_QRENCODE_SUCCESS Then
  begin
    ShowMessage('Encode Error');
    Result:=False;
    Exit;
  End;

  ret := PtSaveImage( filename, @m_image);

  {
  If ret <> PT_IMAGERW_SUCCESS Then
      ShowMessage('save bmp file  Error')
  Else
    CodeImage.Picture.LoadFromFile(filename);
  PtFreeImage(@m_image);
  }
  Result:=ret = PT_IMAGERW_SUCCESS;
end;

end.
 