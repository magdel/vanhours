unit preprint;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ToolWin, ComCtrls, ExtCtrls, ActnList, Buttons, prntmng,
  System.Actions;

Const
   crMyZoom = 1;
   CH_MYZOOM = 300;
   PreViewZoom:Array[0..9] Of Single=(0.1,0.25,0.5,0.75,1.0,1.5,2.0,5.0,1.0,0.5);

type
  TPrePForm = class(TForm)
    ControlBar2: TControlBar;
    ScrollBox1: TScrollBox;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    Label1: TLabel;
    ScaleCmbBox: TComboBox;
    ToolButton4: TToolButton;
    PaintBox1: TPaintBox;
    StatusBar1: TStatusBar;
    ActionList1: TActionList;
    APrevPrnSetup: TAction;
    APrevPrint: TAction;
    SpeedButton1: TSpeedButton;
    ToolButton11: TToolButton;
    AExp: TAction;
    SaveDialog1: TSaveDialog;
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ScaleCmbBoxChange(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton1Click(Sender: TObject);
    procedure APrevPrnSetupExecute(Sender: TObject);
    procedure APrevPrintExecute(Sender: TObject);
    procedure AExpUpdate(Sender: TObject);
    procedure ScrollBox1MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ScrollBox1MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure AExpExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure APrevPrnSetupUpdate(Sender: TObject);
    procedure APrevPrintUpdate(Sender: TObject);
  private
    { Private declarations }
    FDrawMetaFile:TMetaFile;
    procedure AdjustPaintBoxSize;
    procedure AdjustPaintBoxPosition;
  public
    { Public declarations }
    PrintManager:TPrintManager;
//    property PrintManager:TPrintManager read FPrintManager write FPrintManager;
  end;

var
  PrePForm: TPrePForm;

implementation
Uses main, calcwin, printers;
{$R *.DFM}

procedure TPrePForm.PaintBox1Paint(Sender: TObject);
Var R:TRect; //X,Y:Integer;
begin
 R.Left:=0;R.Right:=PaintBox1.Width;
 R.Top:=0;R.Bottom:=PaintBox1.Height;
 Brush.Color:=clWhite;
 Brush.Style:=bsSolid;
 PaintBox1.Canvas.FillRect(R);

 R.Left:=0;//Round(PrintManager.PrinterOffsX*PrintManager.SLogPelsX1/PrintManager.PLogPelsX1*PreViewZoom[ScaleCmbBox.ItemIndex]);
 R.Top:=Round(PrintManager.PrinterOffsY*PrintManager.SLogPelsY1/PrintManager.PLogPelsY1*PreViewZoom[ScaleCmbBox.ItemIndex]);
 R.Right:=Round(PrintManager.WidthPels*PreViewZoom[ScaleCmbBox.ItemIndex])+R.Left;
 R.Bottom:=Round(PrintManager.HeightPels*PreViewZoom[ScaleCmbBox.ItemIndex])+R.Top;

 PaintBox1.Canvas.StretchDraw(R,FDrawMetaFile);
  With PaintBox1,PaintBox1.Canvas Do
    begin
           Brush.Color:=clBlack;
           Pen.Width:=1;
           FrameRect(Rect(0,0,Width-3,Height-3)); {
           Pen.Style:=psDashDot;
           MoveTo(R.Left,R.Top);
           LineTo(R.Right,R.Top);
           LineTo(R.Right,R.Bottom);
           LineTo(R.Left,R.Bottom);
           LineTo(R.Left,R.Top);     }
           //Rectangle(R);
           //FrameRect(R);
           Pen.Style:=psSolid;
           Brush.Color:=ScrollBox1.Color;
           FillRect(Rect(Width-3,0,Width,4));
           FillRect(Rect(0,Height-3,4,Height));

           Brush.Color:=clBlack;
           FillRect(Rect(Width-3,4,Width,Height));
           FillRect(Rect(4,Height-3,Width,Height));
    end;

end;


procedure TPrePForm.FormShow(Sender: TObject);
var
  Save_Cursor:TCursor;
begin
Save_Cursor := Screen.Cursor;
Screen.Cursor := crHourglass;    { Show hourglass cursor }
try
  { Do some lengthy operations }
  //If FPrintManager=nil Then begin ShowMessage('No print manager');exit;end;

  ScaleCmbBox.ItemIndex:=9;

  If PrintManager<>nil Then PrintManager.Free;
  PrintManager:=TPrintManager.Create;

  PrintManager.PrePrint(TCalcForm(MainForm.ActiveMDIChild).CalcProject);
                     
  FDrawMetaFile.Assign(PrintManager.MetaFile);   // LoadFromFile('1.emf');
  AdjustPaintBoxSize;

  //Repaint;
  ScrollBox1.SetFocus;
finally
Screen.Cursor := Save_Cursor;  { Always restore to normal }
end;

end;

procedure TPrePForm.FormDestroy(Sender: TObject);
begin
  If PrintManager<>nil Then FreeAndNil(PrintManager);
  FDrawMetaFile.Free;

{$IFOPT O-}
 MessageBox(0,PChar('!Баланс создания и удаления: '+IntToStr(CreateCounter)),'Расчет',MB_OK or MB_ICONEXCLAMATION);
 MessageBox(0,PChar('!Баланс кальк создания и удаления: '+IntToStr(CreateCalcCounter)),'Расчет',MB_OK or MB_ICONEXCLAMATION);
{$ENDIF}
end;

procedure TPrePForm.FormCreate(Sender: TObject);
begin
StatusBar1.Font.Name:='MS Sans Serif';
StatusBar1.Font.Style:=[];
StatusBar1.Font.Size:=8;
StatusBar1.Font.Color:=clBlack;
  FDrawMetaFile:=TMetaFile.Create;
  PaintBox1.Cursor:=crMyZoom;
try
  Printer.Orientation:=poLandscape;
except
end;
end;

procedure TPrePForm.AdjustPaintBoxSize;
Var C:Single;
begin                                      
    Case ScaleCmbBox.ItemIndex Of
    0,1,2,3,4,5,6,7:begin
    PaintBox1.Width:=Round(PrintManager.PageWidth_mm*PrintManager.SLogPelsX1*PreViewZoom[ScaleCmbBox.ItemIndex]/25.4); //Trunc(210*DispRes/25.4);
    PaintBox1.Height:=Round(PrintManager.PageHeight_mm*PrintManager.SLogPelsY1*PreViewZoom[ScaleCmbBox.ItemIndex]/25.4); //Trunc(297*DispRes/25.4);
    AdjustPaintBoxPosition;

                    End;
    8:begin
        PaintBox1.Width:= ScrollBox1.ClientWidth-16;
        AdjustPaintBoxPosition;     //pass 2
        PaintBox1.Width:= ScrollBox1.ClientWidth-16;
        C:=(PrintManager.PageHeight_mm*PrintManager.SLogPelsY1/
    (PrintManager.PageWidth_mm*PrintManager.SLogPelsX1));
        PaintBox1.Height:= Round(PaintBox1.Width*C);
        C:=PaintBox1.Width/(PrintManager.PageWidth_mm*PrintManager.SLogPelsX1/25.4);
        PreViewZoom[8]:=C;
      end;
    9:begin
        PaintBox1.Height:= ScrollBox1.ClientHeight-16;
//        C:=((PrintManager.PageWidth_mm*PrintManager.SLogPelsX1)/
//        (PrintManager.PageHeight_mm*PrintManager.SLogPelsY1));
        C:=(PrintManager.WidthPels)/
        (PrintManager.HeightPels);
        PaintBox1.Width:= Round(PaintBox1.Height*C);

        AdjustPaintBoxPosition;                  //pass 2
        PaintBox1.Height:= ScrollBox1.ClientHeight-16;
//        C:=((PrintManager.PageWidth_mm*PrintManager.SLogPelsX1)/
//        (PrintManager.PageHeight_mm*PrintManager.SLogPelsY1));
        C:=(PrintManager.WidthPels)/
        (PrintManager.HeightPels);
        PaintBox1.Width:= Round(PaintBox1.Height*C);
        //C:=PaintBox1.Height/(PrintManager.PageHeight_mm*PrintManager.SLogPelsY1/25.4);
        C:=PaintBox1.Height/(PrintManager.HeightPels);
        PreViewZoom[9]:=C;
      end;
    End;
//    PaintBox1.Width:=Round(PrintManager.WidthPels*PreViewZoom[ScaleCmbBox.ItemIndex]); //Trunc(210*DispRes/25.4);
//    PaintBox1.Height:=Round(PrintManager.HeightPels*PreViewZoom[ScaleCmbBox.ItemIndex]); //Trunc(297*DispRes/25.4);
    PaintBox1.Repaint;
end;

procedure TPrePForm.ScaleCmbBoxChange(Sender: TObject);
begin
  AdjustPaintBoxSize;
  ScrollBox1.SetFocus;
end;

procedure TPrePForm.AdjustPaintBoxPosition;
begin
ScrollBox1.VertScrollBar.Position:=0;
ScrollBox1.HorzScrollBar.Position:=0;
  If PaintBox1.Width < ScrollBox1.ClientWidth-16 Then
    begin
      PaintBox1.Left:=(ScrollBox1.ClientWidth-PaintBox1.Width) div 2;
    end
  Else PaintBox1.Left:=8;
end;

procedure TPrePForm.PaintBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
ScrollBox1.SetFocus;
    Case Button Of
      mbRight:
        begin
          If (ScaleCmbBox.ItemIndex>0) and (ScaleCmbBox.ItemIndex<8) Then
            begin
             ScaleCmbBox.ItemIndex:=ScaleCmbBox.ItemIndex-1;
             ScaleCmbBox.OnChange(ScaleCmbBox);
            end
          Else
            begin
             ScaleCmbBox.ItemIndex:=4;
             ScaleCmbBox.OnChange(ScaleCmbBox);
            end;
        end;
      mbLeft:
        begin
          If (ScaleCmbBox.ItemIndex<7) Then
            begin
             ScaleCmbBox.ItemIndex:=ScaleCmbBox.ItemIndex+1;
             ScaleCmbBox.OnChange(ScaleCmbBox);
            end
          Else
            begin
             ScaleCmbBox.ItemIndex:=4;
             ScaleCmbBox.OnChange(ScaleCmbBox);
            end;
        end;
    End;
end;

procedure TPrePForm.SpeedButton1Click(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TPrePForm.APrevPrnSetupExecute(Sender: TObject);
var
  PM:TPrintManager;
  Save_Cursor:TCursor;
begin

If MainForm.PrinterSetupDialog1.Execute Then
  BEGIN
    Save_Cursor := Screen.Cursor;
    Screen.Cursor := crHourglass;    { Show hourglass cursor }
    try
        { Do some lengthy operations }
        //If FPrintManager=nil Then begin ShowMessage('No print manager');exit;end;

        ScaleCmbBox.ItemIndex:=4;

        PM:=TPrintManager.Create;
        If PrintManager<>nil Then FreeAndNil(PrintManager);
        PrintManager:=PM;

        PrintManager.PrePrint(TCalcForm(MainForm.ActiveMDIChild).CalcProject);

        FDrawMetaFile.Assign(PrintManager.MetaFile);   // LoadFromFile('1.emf');
        AdjustPaintBoxSize;

    finally
    Screen.Cursor := Save_Cursor;  { Always restore to normal }
    end;

  END;
end;

procedure TPrePForm.APrevPrintExecute(Sender: TObject);
Var
    PM:TPrintManager;
begin

PM:=TPrintManager.Create;
try
  With MainForm.PrintDialog1 Do
    If Execute Then
      Begin
        Case PrintRange Of
          prAllPages:PM.PrintSheet(TCalcForm(MainForm.ActiveMDIChild).CalcProject);
        End;
      End;
finally
PM.Free;
end;

end;

procedure TPrePForm.AExpUpdate(Sender: TObject);
begin
  If PrintManager<>nil Then AExp.Enabled:=True
  Else AExp.Enabled:=False;

end;

procedure TPrePForm.ScrollBox1MouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
ScrollBox1.VertScrollBar.Position:=ScrollBox1.VertScrollBar.Position+35;
end;

procedure TPrePForm.ScrollBox1MouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
ScrollBox1.VertScrollBar.Position:=ScrollBox1.VertScrollBar.Position-35;
end;

procedure TPrePForm.AExpExecute(Sender: TObject);
Var Path:String;
begin
  SaveDialog1.FileName:=ExtractFileDir(Application.ExeName)+'\calc.emf';
  If SaveDialog1.Execute Then
    begin
      Path:=SaveDialog1.Filename;
      PrintManager.ExportEMF(Path);
    end;
end;

procedure TPrePForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Key = VK_ESCAPE Then
    ModalResult:=mrOk;
end;

procedure TPrePForm.APrevPrnSetupUpdate(Sender: TObject);
begin
APrevPrnSetup.Enabled:=(Printer.Printers.Count>0);
end;

procedure TPrePForm.APrevPrintUpdate(Sender: TObject);
begin
APrevPrint.Enabled:=(Printer.Printers.Count>0);
end;

initialization

begin
  Screen.Cursors[crMyZoom]:=LoadCursor(hInstance,PChar(CH_MYZOOM));

end;

end.
