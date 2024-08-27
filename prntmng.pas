unit prntmng;

interface
Uses Windows, SysUtils, Classes, Graphics, Dialogs, Forms, Grids, printers, trains;

type
  TPrintManager=class;

  TPrintManager=class(TObject)
  private
    FMetaFile: TMetaFile;
    FMetaFileCanvas: TMetaFileCanvas;
    FCalcProject: TCalcProject;

    FPageOrientation: TPrinterOrientation;
    FIconSize_mm: Integer;
    FIsLabelPresent: Boolean;
    FPreview: Boolean;
    FCanvas: TCanvas;
    FWidthPels: Integer; //ширина oбласти рисования
    FHeightPels: Integer; // высота области рисования
    FMidLineWidth: Integer; //толщина промежуточных линий
    FFrmLineWidth: Integer; //толщина обводящих линий
    FPageWidth_mm: Integer; //реальные размеры листа страницы в мм
    FPageHeight_mm: Integer;
    FPLogPelsX1: Integer; // разрешение принтера
    FPLogPelsY1: Integer;
    FSLogPelsX1: Integer; // разрешение монитора
    FSLogPelsY1: Integer;
    FLogPelsX1: Integer; // разрешение при построении
    FLogPelsY1: Integer;
    FLineOffs: Integer; // текущая строка печати
    FPrinterOffsX: Integer; //смещение до начала области печати
    FPrinterOffsY: Integer;
    function cm_to_pixh(cm: Single): Integer;
    function cm_to_pixw(cm: Single): Integer;
    procedure DashLine(X1, Y1, X2, Y2, DashLength: Integer);
    procedure DrawGraph(ShowCredits: Boolean=True);
    procedure SetPageOrientation(Value: TPrinterOrientation);
  public
    constructor Create;
    destructor Destroy; override;
    procedure ExportEMF(Path: String);
    procedure LoadFromFile(FileName: String);
    procedure LoadFromStream(Stream: TStream);
    procedure PrePrint(CalcProject: TCalcProject; DrawCredits: Boolean=False);
    procedure PrintSheet(CalcProject: TCalcProject);
    property MetaFile: TMetaFile read FMetaFile;
    property PageOrientation: TPrinterOrientation read FPageOrientation write SetPageOrientation;
    property WidthPels: Integer read FWidthPels;
    property IconSize_mm: Integer read FIconSize_mm;
    property HeightPels: Integer read FHeightPels;
    property MidLineWidth: Integer read FMidLineWidth;
    property FrmLineWidth: Integer read FFrmLineWidth;
    property PageWidth_mm: Integer read FPageWidth_mm;
    property PageHeight_mm: Integer read FPageHeight_mm;
    property PLogPelsX1: Integer read FPLogPelsX1;
    property PLogPelsY1: Integer read FPLogPelsY1;
    property SLogPelsX1: Integer read FSLogPelsX1;
    property SLogPelsY1: Integer read FSLogPelsY1;
    property LogPelsX1: Integer read FLogPelsX1;
    property LogPelsY1: Integer read FLogPelsY1;
    property LineOffs: Integer read FLineOffs write FLineOffs;
    property PrinterOffsX: Integer read FPrinterOffsX;
    property PrinterOffsY: Integer read FPrinterOffsY;
    property IsLabelPresent: Boolean read FIsLabelPresent;

  end;

{$IFOPT O-}
Var
  CreateCounter: Integer=0;
  CreateCalcCounter: Integer=0;
{$ENDIF}

implementation
Uses main, prninfo;

{ TPrintManager }

function TPrintManager.cm_to_pixh(cm: Single): Integer;
begin
  Result:=Trunc(cm/2.54*FLogPelsY1);
end;

function TPrintManager.cm_to_pixw(cm: Single): Integer;
begin
  Result:=Trunc(cm/2.54*FLogPelsX1);
end;

constructor TPrintManager.Create;
begin
  inherited;
{$IFOPT O-}
  Inc(CreateCounter);
{$ENDIF}
  FIconSize_mm:=10;
  FIsLabelPresent:=True;
end;

procedure TPrintManager.DashLine(X1, Y1, X2, Y2, DashLength: Integer);
Var
  I, D, X, Y: Integer; Draw: Boolean;
begin
  D:=Abs(Y2-Y1)div DashLength;
  X:=X1; Y:=Y1; Draw:=False;
  FCanvas.MoveTo(X, Y);
  For I:=0 To D Do
  begin
    If I<>D Then
      Y:=Y+DashLength
    Else
      Y:=Y2;
    Draw:=not Draw;
    If Draw Then FCanvas.LineTo(X, Y);
    FCanvas.MoveTo(X, Y);
  end;

end;

destructor TPrintManager.Destroy;
begin
  If FMetaFile<>nil Then FreeAndNil(FMetaFile);
{$IFOPT O-}
  Dec(CreateCounter);
{$ENDIF}
{  For I:=0 To FPrintPageList.Count-1 Do       это просто список указателей, а не объектов
    TPrintPage(FPrintPageList.Items[I]).Free;}
  inherited;
end;

procedure TPrintManager.DrawGraph;
Var
  I: Integer;
  S: String; HS, LS, HS1: Integer;
  MaxVan, MinVan: Integer;
  VanX, VanY, VanC: Integer;
  Van_in_cm: Single;
  Tr: TTrain;
  PA, PA1: array of TPoint;
  FBY: Single;
  B: TBitmap;
  hPic, wPic, xPic, yPic: Integer;
  rcL: TRect; hdcMem: HDC;
  bkColor: TColor;
    //LB:TLogBrush;
    //LF:tagLogFonta;DC:THandle;P:PChar;
begin
{$OPTIMIZATION ON}
  FBY:=4.5; //base offset from top of page !!!!!!
  With FCanvas Do
  begin
    Pen.Color:=clBlack;
    CopyMode:=cmSrcCopy;
//------------------------------------------------------------------------------
//  here we paint background of table
//------------------------------------------------------------------------------
//  white rect
//------------------------------------------------------------------------------

    Brush.Style:=bsSolid;
    Brush.Color:=clWhite;
    FillRect(Rect(0, 0, FWidthPels, FHeightPels));

//      If IsLabelPresent Then
    If ShowCredits Then
      try
        BEGIN
          B:=TBitmap.Create;
          try
            B.Assign(MainForm.Image1.Picture.Bitmap);

            wPic:=Trunc(cm_to_pixw(IconSize_mm));
            hPic:=Trunc(cm_to_pixh(IconSize_mm)/B.Width*B.Height);

            xPic:=Trunc(cm_to_pixw(2+24)-wPic);
            yPic:=cm_to_pixh(FBY+9.5)-hPic;
            rcL.Left:=xPic;
            rcL.Top:=yPic;
            rcL.Bottom:=yPic+hPic;
            rcL.Right:=xPic+wPic;

            hdcMem:=CreateCompatibleDC(Handle);
            SelectObject(hdcMem, B.Handle);
            StretchBlt(Handle, xPic, yPic, wPic, hPic, hdcMem, 0, 0, B.Width, B.Height, SRCCOPY);
            DeleteDC(hdcMem);

          finally
            B.Free;
          end;
        END;
      except//мало ли что...
      end;

    If ShowCredits Then
    begin
      Font.Size:=16;
      Font.Name:='Arial';
      Font.Pitch:=fpDefault;
      Font.Orientation:=0;
      Font.Style:= [];
      bkColor:=Font.Color;
      Font.Color:=clGray;

      S:='Петербургский Государственный Университет';
      LS:=TextWidth(S);
      HS:=TextHeight(S);
      TextOut(cm_to_pixw(2+0.5), cm_to_pixh(FBY), S);

      S:='Путей Сообщений';

      TextOut(cm_to_pixw(2+0.5)+LS div 2-TextWidth(S)div 2, cm_to_pixh(FBY)+HS, S);

      try
        BEGIN
          B:=TBitmap.Create;
          try
            B.Assign(MainForm.Image2.Picture.Bitmap);

            wPic:=Trunc(cm_to_pixw(2));
            hPic:=Trunc(cm_to_pixh(2)/B.Width*B.Height);

            xPic:=Trunc(cm_to_pixw(2)+LS div 4-wPic div 2);
            yPic:=cm_to_pixh(FBY)+2*HS;
            rcL.Left:=xPic;
            rcL.Top:=yPic;
            rcL.Bottom:=yPic+hPic;
            rcL.Right:=xPic+wPic;

            hdcMem:=CreateCompatibleDC(Handle);
            SelectObject(hdcMem, B.Handle);
            StretchBlt(Handle, xPic, yPic, wPic, hPic, hdcMem, 0, 0, B.Width, B.Height, SRCCOPY);
            DeleteDC(hdcMem);

          finally
            B.Free;
          end;
        END;
      except//мало ли что...
      end;
    end;
    Font.Size:=8;
    Font.Color:=bkColor;
    Font.Name:='Arial';
    Font.Pitch:=fpDefault;

    Pen.Width:=FrmLineWidth; //Mid
   // border
    MoveTo(cm_to_pixw(2), cm_to_pixh(FBY));
    LineTo(cm_to_pixw(26), cm_to_pixh(FBY));
    LineTo(cm_to_pixw(26), cm_to_pixh(FBY+10));
    LineTo(cm_to_pixw(2), cm_to_pixh(FBY+10));
    LineTo(cm_to_pixw(2), cm_to_pixh(FBY));

    Pen.Width:=MidLineWidth; //Mid
    For I:=1 To 23 Do
    Begin
      MoveTo(cm_to_pixw(2+I), cm_to_pixh(FBY));
      LineTo(cm_to_pixw(2+I), cm_to_pixh(FBY+10));
    End;
 { DONE 2 -oRayev Pavel -cCommon :  Функция рисования штриховых линий}
   {If FPreview Then
     begin
       Pen.Style:=psDot;
       For I:=0 To 23 Do
         Begin
           MoveTo(cm_to_pixw(2+I+0.5),cm_to_pixh(FBY));
           LineTo(cm_to_pixw(2+I+0.5),cm_to_pixh(FBY+10));
         End;
       Pen.Style:=psSolid;
     end
   Else}
    begin
      For I:=0 To 23 Do
      Begin
        DashLine(cm_to_pixw(2+I+0.5), cm_to_pixh(FBY),
          cm_to_pixw(2+I+0.5), cm_to_pixh(FBY+10), cm_to_pixh(0.25));
      End;
    end;

//------------------------------------------------------------------------------
//time values painting
//------------------------------------------------------------------------------
    Brush.Style:=bsClear;
//at top
    For I:=18 To 23 Do
    begin
      //If I mod 4 <> 0 Then Continue;
      If FCalcProject.CalcKVDI Then
        S:=TimeToStr(EncodeTime((I-18)div 6+8, ((I-18)*10)mod 60, 0, 0))
      Else
        S:=TimeToStr(EncodeTime(I, 0, 0, 0));

      LS:=TextWidth(S);
      HS:=TextHeight(S)+cm_to_pixh(0.35);
      TextOut(cm_to_pixw(2+I-18)-LS div 2, cm_to_pixh(FBY)-HS, S);
    end;
    For I:=0 To 18 Do
    begin
      If FCalcProject.CalcKVDI Then
        S:=TimeToStr(EncodeTime((I+6)div 6+8, ((I)*10)mod 60, 0, 0))
      Else
        S:=TimeToStr(EncodeTime((I), 0, 0, 0));
      LS:=TextWidth(S);
      HS:=TextHeight(S)+cm_to_pixh(0.35);
      TextOut(cm_to_pixw(2+6+I)-LS div 2, cm_to_pixh(FBY)-HS, S);
    end;
//at bottom
    For I:=18 To 23 Do
    begin
      If FCalcProject.CalcKVDI Then
        S:=TimeToStr(EncodeTime((I-18)div 6+8, ((I-18)*10)mod 60, 0, 0))
      Else
        S:=TimeToStr(EncodeTime((I), 0, 0, 0));
      LS:=TextWidth(S);
      HS:={TextHeight(S)+} cm_to_pixh(0.35);
      TextOut(cm_to_pixw(2+I-18)-LS div 2, cm_to_pixh(FBY+10)+HS, S);
    end;
    For I:=0 To 18 Do
    begin
      If FCalcProject.CalcKVDI Then
        S:=TimeToStr(EncodeTime((I+6)div 6+8, ((I)*10)mod 60, 0, 0))
      Else
        S:=TimeToStr(EncodeTime((I), 0, 0, 0));
      LS:=TextWidth(S);
      HS:={TextHeight(S)+} cm_to_pixh(0.35);
      TextOut(cm_to_pixw(2+6+I)-LS div 2, cm_to_pixh(FBY+10)+HS, S);
    end;
    Brush.Style:=bsSolid;

//------------------------------------------------------------------------------
//     paint arrows of departing trains
//------------------------------------------------------------------------------
    Pen.Width:=MidLineWidth;

    For I:=0 To FCalcProject.DepartTrainsCount-1 Do
    Begin
      Tr:=FCalcProject.DepartTrains[I];
      Brush.Color:=clBlack;

      If FCalcProject.CalcKVDI Then
      begin
        MoveTo(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6), cm_to_pixh(FBY));
        LineTo(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6+1), cm_to_pixh(FBY-2));
        Polygon([Point(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6+1), cm_to_pixh(FBY-2)),
          Point(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6+0.75), cm_to_pixh(FBY-1.68)),
            Point(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6+0.88), cm_to_pixh(FBY-1.8))]);
        Polygon([Point(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6+1), cm_to_pixh(FBY-2)),
          Point(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6+0.905), cm_to_pixh(FBY-1.625)),
            Point(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6+0.894), cm_to_pixh(FBY-1.78))]);

        Brush.Style:=bsClear;
        Font.Orientation :=633;
        TextOut(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6+0.101), cm_to_pixh(FBY-0.78), Tr.sNumber+'/'+Tr.sVanCount);
      end
      else
      begin
        MoveTo(cm_to_pixw(2+Tr.BaseTime*24), cm_to_pixh(FBY));
        LineTo(cm_to_pixw(2+Tr.BaseTime*24+1), cm_to_pixh(FBY-2));
        Polygon([Point(cm_to_pixw(2+Tr.BaseTime*24+1), cm_to_pixh(FBY-2)),
          Point(cm_to_pixw(2+Tr.BaseTime*24+0.75), cm_to_pixh(FBY-1.68)),
            Point(cm_to_pixw(2+Tr.BaseTime*24+0.88), cm_to_pixh(FBY-1.8))]);
        Polygon([Point(cm_to_pixw(2+Tr.BaseTime*24+1), cm_to_pixh(FBY-2)),
          Point(cm_to_pixw(2+Tr.BaseTime*24+0.905), cm_to_pixh(FBY-1.625)),
            Point(cm_to_pixw(2+Tr.BaseTime*24+0.894), cm_to_pixh(FBY-1.78))]);

        Brush.Style:=bsClear;
        Font.Orientation:=633;
        TextOut(cm_to_pixw(2+Tr.BaseTime*24+0.101), cm_to_pixh(FBY-0.78), Tr.sNumber+'/'+Tr.sVanCount);
      end;

      Brush.Style:=bsSolid;
      Font.Orientation:=0;

    End;
//------------------------------------------------------------------------------
//     paint arrows of arriving trains
//------------------------------------------------------------------------------
    For I:=0 To FCalcProject.ArriveTrainsCount-1 Do
    Begin
      Tr:=FCalcProject.ArriveTrains[I];
      Brush.Color:=clBlack;
      If FCalcProject.CalcKVDI Then
      begin

        MoveTo(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6), cm_to_pixh(FBY+12-2));
        LineTo(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6-1), cm_to_pixh(FBY+12));
        Polygon([Point(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6), cm_to_pixh(FBY+12-2)),
          Point(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6+0.76-1), cm_to_pixh(FBY+12-1.68)),
            Point(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6+0.88-1), cm_to_pixh(FBY+12-1.8))]);
        Polygon([Point(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6), cm_to_pixh(FBY+12-2)),
          Point(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6+0.915-1), cm_to_pixh(FBY+12-1.625)),
            Point(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6+0.894-1), cm_to_pixh(FBY+12-1.78))]);

        Brush.Style:=bsClear;
        Font.Orientation:=633;
        TextOut(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6-1.151+0.04), cm_to_pixh(FBY+12-0.38), Tr.sNumber+'/'+Tr.sVanCount);
      end
      Else
      begin
        MoveTo(cm_to_pixw(2+Tr.BaseTime*24), cm_to_pixh(FBY+12-2));
        LineTo(cm_to_pixw(2+Tr.BaseTime*24-1), cm_to_pixh(FBY+12));
        Polygon([Point(cm_to_pixw(2+Tr.BaseTime*24), cm_to_pixh(FBY+12-2)),
          Point(cm_to_pixw(2+Tr.BaseTime*24+0.76-1), cm_to_pixh(FBY+12-1.68)),
            Point(cm_to_pixw(2+Tr.BaseTime*24+0.88-1), cm_to_pixh(FBY+12-1.8))]);
        Polygon([Point(cm_to_pixw(2+Tr.BaseTime*24), cm_to_pixh(FBY+12-2)),
          Point(cm_to_pixw(2+Tr.BaseTime*24+0.915-1), cm_to_pixh(FBY+12-1.625)),
            Point(cm_to_pixw(2+Tr.BaseTime*24+0.894-1), cm_to_pixh(FBY+12-1.78))]);

        Brush.Style:=bsClear;
        Font.Orientation:=633;
        TextOut(cm_to_pixw(2+Tr.BaseTime*24-1.151+0.04), cm_to_pixh(FBY+12-0.38), Tr.sNumber+'/'+Tr.sVanCount);
      end;
      Brush.Style:=bsSolid;
      Font.Orientation:=0;

                                {
          Brush.Style:=bsClear;
          FillChar(LF,SizeOf(LF),0);
          If FPreView Then LF.lfHeight:=10 Else LF.lfHeight:=Trunc(10*FPLogPelsX1/FSLogPelsX1);
          LF.lfWidth:=0;LF.lfEscapement:=633;
          LF.lfFaceName:='Arial';
          DC:=Handle;
          DeleteObject(SelectObject(DC,CreateFontIndirect(LF)));
          SetTextColor(DC,0);
          P:=PChar(Tr.sNumber);
          Windows.TextOut(DC,cm_to_pixw(2+Tr.BaseTime*24+0.05-1),cm_to_pixh(FBY+12-0.7),P,4);
          Brush.Style:=bsSolid;}
    End;

    Brush.Color:=clWhite;

//------------------------------------------------------------------------------
//     paint line of arriving trains
//------------------------------------------------------------------------------
    MaxVan:=FCalcProject.UsedVanCount;
    MinVan:=FCalcProject.ConstVanCount;
    VanC:=MinVan;
    Van_in_cm:=MaxVan/10;
//------------------------------------------------------------------------------
//   Sizes of starting and ending van counts
//------------------------------------------------------------------------------
//   Starting quantity
//------------------------------------------------------------------------------
    If MidLineWidth>1 Then
      Pen.Width:=MidLineWidth div 2
    Else
      Pen.Width:=1;
    MoveTo(cm_to_pixw(2), cm_to_pixh(-MinVan/Van_in_cm+FBY+10));
    LineTo(cm_to_pixw(1.4), cm_to_pixh(-MinVan/Van_in_cm+FBY+10));
    MoveTo(cm_to_pixw(2), cm_to_pixh(FBY+10));
    LineTo(cm_to_pixw(1.4), cm_to_pixh(FBY+10));
    MoveTo(cm_to_pixw(1.6), cm_to_pixh(-MinVan/Van_in_cm+FBY+10));
    LineTo(cm_to_pixw(1.6), cm_to_pixh(FBY+10));

    Brush.Color:=clBlack;
    Polygon([Point(cm_to_pixw(1.6), cm_to_pixh(-MinVan/Van_in_cm+FBY+10)),
      Point(cm_to_pixw(1.55), cm_to_pixh(-MinVan/Van_in_cm+FBY+10+0.25)),
        Point(cm_to_pixw(1.6), cm_to_pixh(-MinVan/Van_in_cm+FBY+10+0.17)),
        Point(cm_to_pixw(1.65), cm_to_pixh(-MinVan/Van_in_cm+FBY+10+0.25)),
        Point(cm_to_pixw(1.6), cm_to_pixh(-MinVan/Van_in_cm+FBY+10))]);
    Polygon([Point(cm_to_pixw(1.6), cm_to_pixh(FBY+10)),
      Point(cm_to_pixw(1.55), cm_to_pixh(FBY+10-0.25)),
        Point(cm_to_pixw(1.6), cm_to_pixh(FBY+10-0.17)),
        Point(cm_to_pixw(1.65), cm_to_pixh(FBY+10-0.25)),
        Point(cm_to_pixw(1.6), cm_to_pixh(FBY+10))]);
    Brush.Color:=clWhite;

    Brush.Style:=bsClear;
    Font.Orientation:=900;
    TextOut(cm_to_pixw(1.58)-TextHeight(IntToStr(MinVan)), cm_to_pixh(FBY+10-MinVan/Van_in_cm/2)+TextWidth(IntToStr(MinVan))div 2, IntToStr(MinVan));
    Brush.Style:=bsSolid;
    Font.Orientation:=0;

{          Brush.Style:=bsClear;
          FillChar(LF,SizeOf(LF),0);
          If FPreView Then LF.lfHeight:=10 Else LF.lfHeight:=Trunc(11*FPLogPelsX1/FSLogPelsX1);
          LF.lfWidth:=0;LF.lfEscapement:=900;
          LF.lfFaceName:='Arial';
          DC:=Handle;
          DeleteObject(SelectObject(DC,CreateFontIndirect(LF)));
          SetTextColor(DC,0);
          P:=PChar(IntToStr(MinVan));
          If FPreview Then Windows.TextOut(DC,cm_to_pixw(1.6)-TextHeight('12'),cm_to_pixh(FBY+10-MinVan/Van_in_cm/2)+TextWidth(P) div 2,P,Length(IntToStr(MinVan)))
          Else Windows.TextOut(DC,cm_to_pixw(1.6)-LF.lfHeight,cm_to_pixh(FBY+10-MinVan/Van_in_cm/2)+TextWidth(P) div 2,P,Length(IntToStr(MinVan)));
          Brush.Style:=bsSolid;
}
//------------------------------------------------------------------------------
//   Ending quantity
//------------------------------------------------------------------------------
    If MidLineWidth>1 Then
      Pen.Width:=MidLineWidth div 2
    Else
      Pen.Width:=1;
    MoveTo(cm_to_pixw(25), cm_to_pixh(FBY));
    LineTo(cm_to_pixw(25+1.5), cm_to_pixh(FBY));
    MoveTo(cm_to_pixw(25), cm_to_pixh(FBY+10));
    LineTo(cm_to_pixw(25+1.5), cm_to_pixh(FBY+10));
    MoveTo(cm_to_pixw(25+1.4), cm_to_pixh(FBY));
    LineTo(cm_to_pixw(25+1.4), cm_to_pixh(FBY+10));

    Brush.Color:=clBlack;
    Polygon([Point(cm_to_pixw(25+1.4), cm_to_pixh(FBY)),
      Point(cm_to_pixw(25+1.35), cm_to_pixh(FBY+0.25)),
        Point(cm_to_pixw(25+1.4), cm_to_pixh(FBY+0.17)),
        Point(cm_to_pixw(25+1.45), cm_to_pixh(FBY+0.25)),
        Point(cm_to_pixw(25+1.4), cm_to_pixh(FBY))]);
    Polygon([Point(cm_to_pixw(25+1.4), cm_to_pixh(FBY+10)),
      Point(cm_to_pixw(25+1.35), cm_to_pixh(FBY+10-0.25)),
        Point(cm_to_pixw(25+1.4), cm_to_pixh(FBY+10-0.17)),
        Point(cm_to_pixw(25+1.45), cm_to_pixh(FBY+10-0.25)),
        Point(cm_to_pixw(25+1.4), cm_to_pixh(FBY+10))]);
    Brush.Color:=clWhite;

    Brush.Style:=bsClear;
    Font.Orientation:=900;
    TextOut(cm_to_pixw(25+1.4)-TextHeight(IntToStr(MaxVan)), cm_to_pixh(FBY+5)+TextWidth(IntToStr(MaxVan))div 2, IntToStr(MaxVan));
    Brush.Style:=bsSolid;
    Font.Orientation:=0;

{          Brush.Style:=bsClear;
          FillChar(LF,SizeOf(LF),0);
          If FPreView Then LF.lfHeight:=10 Else LF.lfHeight:=Trunc(11*FPLogPelsX1/FSLogPelsX1);
          LF.lfWidth:=0;LF.lfEscapement:=900;
          LF.lfFaceName:='Arial';
          DC:=Handle;
          DeleteObject(SelectObject(DC,CreateFontIndirect(LF)));
          SetTextColor(DC,0);
          P:=PChar(IntToStr(MaxVan));
          If FPreview Then Windows.TextOut(DC,cm_to_pixw(25+1.4)-TextHeight('12'),cm_to_pixh(FBY+5)+TextWidth(P) div 2,P,Length(IntToStr(MaxVan)))
          Else Windows.TextOut(DC,cm_to_pixw(25+1.4)-LF.lfHeight,cm_to_pixh(FBY+5)+TextWidth(P) div 2,P,Length(IntToStr(MaxVan)));
          Brush.Style:=bsSolid;
}

//------------------------------------------------------------------------------
//     paint line of arriving trains continue
//------------------------------------------------------------------------------
    I:=4+FCalcProject.ArriveTrainsCount*2+FCalcProject.DepartTrainsCount*2;
    SetLength(PA, I);
    I:=1+FCalcProject.DepartTrainsCount*2;
    SetLength(PA1, I);

    If FCalcProject.CalcKVDI Then
      VanX:=cm_to_pixw(2)
      //VanX:=cm_to_pixw(2+14)
    Else
      VanX:=cm_to_pixw(2);

    Pen.Width:=FrmLineWidth;
//    MoveTo(VanX,cm_to_pixh(14.5));
    PA[0]:=Point(VanX, cm_to_pixh(FBY+10));
//    LineTo(VanX,cm_to_pixh(14.5)-VanY);
    PA[1]:=Point(VanX, cm_to_pixh(FBY+10-MinVan/Van_in_cm));

    For I:=0 To FCalcProject.ArriveTrainsCount-1 Do
    Begin
      Tr:=FCalcProject.ArriveTrains[I];
      VanY:=cm_to_pixh(FBY+10-VanC/Van_in_cm);
//        LineTo(cm_to_pixw(2+Tr.BaseTime*24),VanY);

      If FCalcProject.CalcKVDI Then
        PA[2*I+2]:=Point(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6), VanY)
      Else
        PA[2*I+2]:=Point(cm_to_pixw(2+Tr.BaseTime*24), VanY);

      VanC:=VanC+Tr.VanCount;
      VanY:=cm_to_pixh(FBY+10-VanC/Van_in_cm);
//        LineTo(cm_to_pixw(2+Tr.BaseTime*24),VanY);
      If FCalcProject.CalcKVDI Then
        PA[2*I+3]:=Point(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6), VanY)
      Else
        PA[2*I+3]:=Point(cm_to_pixw(2+Tr.BaseTime*24), VanY);
    End;

    VanY:=cm_to_pixh(FBY+10-VanC/Van_in_cm);
        //LineTo(cm_to_pixw(2+24),VanY);
    If FCalcProject.CalcKVDI Then
      PA[FCalcProject.ArriveTrainsCount*2+2]:=Point(cm_to_pixw(2+24), VanY)
      //PA[FCalcProject.ArriveTrainsCount*2+2]:=Point(cm_to_pixw(2+18), VanY)
    Else
      PA[FCalcProject.ArriveTrainsCount*2+2]:=Point(cm_to_pixw(2+24), VanY);
//!!!!!!!!!!!!!!

//------------------------------------------------------------------------------
//     paint line of departing trains
//------------------------------------------------------------------------------

    VanC:=0;

//    VanY:= cm_to_pixh(0/Van_in_cm);
//    VanX:= cm_to_pixw(2);
//    MoveTo(VanX,cm_to_pixh(14.5));
//    LineTo(VanX,cm_to_pixh(14.5)-VanY);
 //   PA1[0]:=Point(VanX,cm_to_pixh(14.5)-VanY);

    For I:=0 To FCalcProject.DepartTrainsCount-1 Do
    Begin
      Tr:=FCalcProject.DepartTrains[I];
      VanY:=cm_to_pixh(FBY+10-VanC/Van_in_cm);
//        LineTo(cm_to_pixw(2+Tr.BaseTime*24),VanY);
      If FCalcProject.CalcKVDI Then
        PA1[I*2]:=Point(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6), VanY)
      Else
        PA1[I*2]:=Point(cm_to_pixw(2+Tr.BaseTime*24), VanY);

      VanC:=VanC+Tr.VanCount;
      VanY:=cm_to_pixh(FBY+10-VanC/Van_in_cm);
//        LineTo(cm_to_pixw(2+Tr.BaseTime*24),VanY);
      If FCalcProject.CalcKVDI Then
        PA1[1+I*2]:=Point(cm_to_pixw(2+(Tr.BaseTime-14/24)*24*6), VanY)
      Else
        PA1[1+I*2]:=Point(cm_to_pixw(2+Tr.BaseTime*24), VanY);
    End;
    VanY:=cm_to_pixh(FBY+10-VanC/Van_in_cm);
//        LineTo(cm_to_pixw(2+24),VanY);
    If FCalcProject.CalcKVDI Then
      PA1[FCalcProject.DepartTrainsCount*2]:=Point(cm_to_pixw(2+24), VanY)
      //PA1[FCalcProject.DepartTrainsCount*2]:=Point(cm_to_pixw(2+18), VanY)
    Else
      PA1[FCalcProject.DepartTrainsCount*2]:=Point(cm_to_pixw(2+24), VanY);

    For I:=0 To FCalcProject.DepartTrainsCount*2 Do
    begin
      PA[FCalcProject.ArriveTrainsCount*2+3+I]:=PA1[FCalcProject.DepartTrainsCount*2-I];
    end;

       //Brush.Style:=bsDiagCross;

//draw polygon of van-hours square
    Brush.Color:=clRed;
    Pen.Color:=clRed;
    try
      If FCalcProject.GetIsVanCountCycled Then
        Brush.Color:=clGreen
      Else
        Brush.Color:=clRed;
    except
    end;

    try
      If FCalcProject.GetIsVanCountCycled Then
        Pen.Color:=clGreen
      Else
        Pen.Color:=clRed;
    except
    end;

    Pen.Width:=FrmLineWidth;

    If FPreview Then
    BEGIN

      Brush.Style:=bsSolid;
      Brush.Color:=clSilver;
      FCanvas.Polygon(PA);
      {
       BB:=TBitmap.Create;
       try

         BB.PixelFormat:=pf24bit;
         BB.Height:=8;BB.Width:=8;
         For I:=0 To 7 Do For J:=0 To 7 Do
           BB.Canvas.Pixels[I,J]:=clWhite;

         BB.Canvas.Pixels[0,0]:=Pen.Color;
         BB.Canvas.Pixels[1,1]:=clBlack;
         BB.Canvas.Pixels[2,2]:=Pen.Color;
         BB.Canvas.Pixels[3,3]:=clBlack;
         BB.Canvas.Pixels[4,4]:=Pen.Color;
         BB.Canvas.Pixels[5,5]:=clBlack;
         BB.Canvas.Pixels[6,6]:=Pen.Color;
         BB.Canvas.Pixels[7,7]:=clBlack;
         BB.Canvas.Pixels[0,7]:=Pen.Color;
         BB.Canvas.Pixels[1,6]:=clBlack;
         BB.Canvas.Pixels[2,5]:=Pen.Color;
         BB.Canvas.Pixels[3,4]:=clBlack;
         BB.Canvas.Pixels[4,3]:=Pen.Color;
         BB.Canvas.Pixels[5,2]:=clBlack;
         BB.Canvas.Pixels[6,1]:=Pen.Color;
         BB.Canvas.Pixels[7,0]:=clBlack;
         Brush.Bitmap:=BB;

         FCanvas.Polygon(PA);
         Brush.Bitmap:=nil;
       finally
         BB.Free;
       end;    }
    END
    Else
    BEGIN
      Brush.Style:=bsSolid;
      Brush.Color:=clSilver;
      FCanvas.Polygon(PA);

    END;

       //Brush.Style:=bsSolid;
       //Brush.Color:=clWhite;

//------------------------------------------------------------------------------
//   Caption of calculation
//------------------------------------------------------------------------------
    Pen.Color:=clBlack;
    Brush.Style:=bsClear;
    Font.Name:='Times New Roman';
    Font.Size:=14;
    Font.Style:= [fsBold];
    S:='РАСЧЕТ ВАГОНО-ЧАСОВ НА СТАНЦИИ';
    LS:=TextWidth(S);
    HS:=TextHeight(S);
    TextOut(cm_to_pixw(13)-LS div 2, cm_to_pixh(FBY-2.5)-HS, S);

//------------------------------------------------------------------------------
//   Results of calculation
//------------------------------------------------------------------------------

    try
      BEGIN
        B:=TBitmap.Create;
        try
          If FCalcProject.CalcKVDI Then
            B.Assign(MainForm.ImageK.Picture.Bitmap)
          Else
            B.Assign(MainForm.ImageA.Picture.Bitmap);

          wPic:=Trunc(cm_to_pixw(3));
          hPic:=Trunc(cm_to_pixh(3)/B.Width*B.Height);

          xPic:=Trunc(cm_to_pixw(15));
          yPic:=cm_to_pixh(FBY+12.5);
          rcL.Left:=xPic;
          rcL.Top:=yPic;
          rcL.Bottom:=yPic+hPic;
          rcL.Right:=xPic+wPic;

          hdcMem:=CreateCompatibleDC(Handle);
          SelectObject(hdcMem, B.Handle);
          StretchBlt(Handle, xPic, yPic, wPic, hPic, hdcMem, 0, 0, B.Width, B.Height, SRCCOPY);
          DeleteDC(hdcMem);

        finally
          B.Free;
        end;
      END;
    except//мало ли что...
    end;

    Font.Name:='Times New Roman';
    Font.Size:=10;
    Font.Style:= [];
    S:='Вагоно-часов на станции:  '; //+IntToStr(FCalcProject.GetVanHours)
    LS:=TextWidth(S);
    HS:=TextHeight(S);
    TextOut(cm_to_pixw(3), cm_to_pixh(FBY+12.5), S);
    Font.Name:='Arial';
    Font.Style:= [fsBold];
    S:=FormatFloat('0.0', FCalcProject.GetVanHours);
    HS:=Abs(HS-TextHeight(S));
    TextOut(cm_to_pixw(3)+LS, cm_to_pixh(FBY+12.5)-HS div 2, S);
    HS1:=TextHeight(S);

    Font.Name:='Times New Roman';
    Font.Style:= [];
    S:='Средний простой одного вагона на станции, ч:  '; //+IntToStr(FCalcProject.GetVanHours)
    LS:=TextWidth(S);
    HS:=TextHeight(S);
    TextOut(cm_to_pixw(3), cm_to_pixh(FBY+12.5)+HS1, S);
    Font.Name:='Arial';
    Font.Style:= [fsBold];
    try
      If FCalcProject.CalcKVDI Then
        S:=FormatFloat('0.00', 2*FCalcProject.GetVanHours/(FCalcProject.ArrivedVansCount+FCalcProject.DepartedVansCount))
      Else
        S:=FormatFloat('0.00', FCalcProject.GetVanHours/FCalcProject.UsedVanCount);
    except
    end;
    HS:=Abs(HS-TextHeight(S));
    HS1:=cm_to_pixh(FBY+12.5)+HS1-HS div 2;
    TextOut(cm_to_pixw(3)+LS, HS1, S);

    If FCalcProject.CalcKVDI Then
    begin
      Font.Name:='Arial';
      Font.Style:= [];
      S:='РАСЧЕТ ДЛЯ КВДИ! ';
      LS:=TextWidth(S);
      HS:=TextHeight(S);
      TextOut(cm_to_pixw(3), HS+HS1, S);
    end;
  end;
end;

procedure TPrintManager.ExportEMF(Path: String);
begin
  PrePrint(FCalcProject, True);
  FMetaFile.SaveToFile(Path);
  PrePrint(FCalcProject, False);
end;

procedure TPrintManager.LoadFromFile(FileName: String);
begin

end;

procedure TPrintManager.LoadFromStream(Stream: TStream);
begin

end;

procedure TPrintManager.PrePrint(CalcProject: TCalcProject; DrawCredits: Boolean=False);
Var
  DC: HDC;
//    PrintPage:TPrintPage;
begin
  FPreview:=True;
  FCalcProject:=CalcProject;
    //InitPrnData(Printer.Handle,3,5);
  FMidLineWidth:={Trunc(LogPelsY1*PreViewZoom[PreForm.ComboBox1.ItemIndex]*0.3/25.4)+} 1;
  FFrmLineWidth:={Trunc(LogPelsY1*PreViewZoom[PreForm.ComboBox1.ItemIndex]*0.5/25.4)+} 2;
  DC:=GetDC(0);
  try

    FSLogPelsX1:=GetDeviceCaps(DC, LOGPIXELSX);
    FSLogPelsY1:=GetDeviceCaps(DC, LOGPIXELSY);
    If Printer.Printers.Count>0 Then
    begin
      FPLogPelsX1:=GetDeviceCaps(Printer.Handle, LOGPIXELSX); //300
      FPLogPelsY1:=GetDeviceCaps(Printer.Handle, LOGPIXELSY); //300
    end
    Else
    begin
      FPLogPelsX1:=300;
      FPLogPelsY1:=300;
    end;

    FLogPelsX1:=FSLogPelsX1;
    FLogPelsY1:=FSLogPelsY1;
    If Printer.Printers.Count>0 Then
    begin
      FPrinterOffsX:=GetDeviceCaps(Printer.Handle, PHYSICALOFFSETX); //14
      FPrinterOffsY:=GetDeviceCaps(Printer.Handle, PHYSICALOFFSETY); //40
      FPageWidth_mm:=Round(GetDeviceCaps(Printer.Handle, PHYSICALWIDTH)/FPLogPelsX1*25.4); //    297
      FPageHeight_mm:=Round(GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT)/FPLogPelsY1*25.4); //   210
//    FWidthPels:=Round(GetDeviceCaps(Printer.Handle,HORZRES)/FPLogPelsX1*FSLogPelsX1);   //    1062
//    FHeightPels:=Round(GetDeviceCaps(Printer.Handle,VERTRES)/FPLogPelsY1*FSLogPelsY1);  //    768
      FWidthPels:=Round(GetDeviceCaps(Printer.Handle, PHYSICALWIDTH)/FPLogPelsX1*FSLogPelsX1); //1122
      FHeightPels:=Round(GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT)/FPLogPelsY1*FSLogPelsY1); //    794
    end
    Else
    begin
      FPrinterOffsX:=14;
      FPrinterOffsY:=40;
      FPageWidth_mm:=297;
      FPageHeight_mm:=210;
      FWidthPels:=1122;
      FHeightPels:=794;
    end;

  finally
    ReleaseDC(0, DC);
  end;
  FIsLabelPresent:=True;
  FLineOffs:=Round(FLogPelsY1*10/25.4);

  If FMetaFile<>nil Then FreeAndNil(FMetaFile);
  FMetaFile:=TMetaFile.Create;
  //FMetaFile.Transparent:=False;
  FMetaFile.MMWidth:=Round(WidthPels/LogPelsX1*25.4*100*1.1); //PrintManager.PageWidth_mm*100; //21000;
  FMetaFile.MMHeight:=Round(HeightPels/LogPelsY1*25.4*100*1.1); //PrintManager.PageHeight_mm*100; //29700;
  FMetaFile.Width:=WidthPels; //Trunc(210*DispRes/25.4);
  FMetaFile.Height:=HeightPels; //Trunc(297*DispRes/25.4);

  FMetaFileCanvas:=TMetafileCanvas.Create(FMetaFile, Screen.Forms[0].Canvas.Handle);
  try
    FCanvas:=FMetaFileCanvas;
    DrawGraph(DrawCredits);
  finally
    FMetaFileCanvas.Free;
  end;
end;

procedure TPrintManager.PrintSheet(CalcProject: TCalcProject);
Var
  DC: HDC; PF: TPrnPForm; I: Integer;
begin
  PF:=TPrnPForm.Create(MainForm);
  try
    PF.Show;
    PF.Label2.Caption:=Printer.Printers[Printer.PrinterIndex];
    PF.Label4.Caption:=CalcProject.FileName;
    PF.RePaint;
    Application.ProcessMessages;

    FPreview:=False;
    FCalcProject:=CalcProject;
    DC:=GetDC(0);
    try

      FSLogPelsX1:=GetDeviceCaps(DC, LOGPIXELSX); //pix in inch for screen
      FSLogPelsY1:=GetDeviceCaps(DC, LOGPIXELSY);
      FPLogPelsX1:=GetDeviceCaps(Printer.Handle, LOGPIXELSX); //pix in inch for printer - print resolution
      FPLogPelsY1:=GetDeviceCaps(Printer.Handle, LOGPIXELSY);
      FLogPelsX1:=FPLogPelsX1;
      FLogPelsY1:=FPLogPelsY1;
      FPrinterOffsX:=GetDeviceCaps(Printer.Handle, PHYSICALOFFSETX); //offset from left of paper for printer in pix
      FPrinterOffsY:=GetDeviceCaps(Printer.Handle, PHYSICALOFFSETY); //offset from top of paper for printer in pix
      FPageWidth_mm:=Round(GetDeviceCaps(Printer.Handle, PHYSICALWIDTH)/FPLogPelsX1*25.4); //paper width in mm
      FPageHeight_mm:=Round(GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT)/FPLogPelsY1*25.4); //paper height in mm
//      FWidthPels:=Round(GetDeviceCaps(Printer.Handle,HORZRES)); //paper width in pix
//      FHeightPels:=Round(GetDeviceCaps(Printer.Handle,VERTRES));//paper height in pix
      FWidthPels:=Round(GetDeviceCaps(Printer.Handle, PHYSICALWIDTH));
      FHeightPels:=Round(GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT)); //    768

    finally
      ReleaseDC(0, DC);
    end;
    PF.Label6.Caption:=IntToStr(FPLogPelsX1);
    PF.RePaint;
    PF.BringToFront;
    Application.ProcessMessages;

    FIsLabelPresent:=True;
    FLineOffs:=Round(FLogPelsY1*10/25.4);
    FMidLineWidth:=Trunc(LogPelsY1*0.3/25.4)+1;
    FFrmLineWidth:=Trunc(LogPelsY1*0.5/25.4)+2;

    Printer.Title:='VanHours - '+CalcProject.FileName;
    Printer.BeginDoc;
    try

      FCanvas:=Printer.Canvas;

  //printing !!!!!!!!!!
      DrawGraph;

    finally
      Printer.EndDoc;
      For I:=0 To 10000000 Do
        ;
    end;
  finally
    PF.Free;
  end;
end;

procedure TPrintManager.SetPageOrientation(Value: TPrinterOrientation);
begin

end;

end.

