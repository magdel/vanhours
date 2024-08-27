{******************************************************************************}
{    GruzVag 1.0  Copyright 2000,2001 KGRLab                                   }
{    filename:  aboutbx.pas                                                    }
{    Borland Delphi 5.                                                         }
{******************************************************************************}

unit aboutbx;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
   TAboutBox = class;

   TAniThread = class(TThread)
   private
     FAniBmp:TBitmap;
     FAboutBox:TAboutBox;
     FFrmN:Integer;
     procedure Draw;
   public
     destructor Destroy;override;
     procedure Execute;override;
     property AboutBox:TAboutBox read FAboutBox write FAboutBox;
   End;

  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIco_: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    Label1: TLabel;
    Timer1: TTimer;
    Label2: TLabel;
    Label3: TLabel;
    AniTimer: TTimer;
    Label4: TLabel;
    procedure Label1Click(Sender: TObject);
    procedure Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label3Click(Sender: TObject);
    procedure AniTimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FBmp:TBitmap;
    FXP1:Integer;
    FActive1,FActive2:Boolean;
    FS:Integer;
//    FAniThread:TAniThread;
  public
    { Public declarations }
  end;

//var
//  AboutBox: TAboutBox;

implementation
uses ShellApi, registry;

{$R *.DFM}

procedure TAboutBox.Label1Click(Sender: TObject);
Var Url:String;
begin
     Url:=Label1.Caption;
     ShellExecute(Handle, 'open', pchar(Url), Nil, Nil, SW_SHOWNORMAL);
end;

procedure TAboutBox.Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
Label1.Font.Color:=clAqua;
Timer1.Enabled:=True;
FActive1:=True;
end;

procedure TAboutBox.Timer1Timer(Sender: TObject);
Var P:TPoint;R:TRect;
begin
Windows.GetCursorPos(P);
R:=Bounds(Left+Panel1.Left+Label1.Left,
Top+Panel1.Top+Label1.Top+19,
Label1.Width+3,
Label1.Height+3);
If Not(PtInRect(R,P)) and FActive1 Then
   Begin
      FActive1:=False;
      If not(FActive1) and not(FActive2) Then Timer1.Enabled:=False;
      Label1.Font.Color:=clBlue;
   End;

R:=Bounds(Left+Panel1.Left+Label3.Left,
Top+Panel1.Top+Label3.Top+19,
Label3.Width+3,
Label3.Height+3);
If Not(PtInRect(R,P)) and FActive2 Then
   Begin
      FActive2:=False;
      If not(FActive1) and not(FActive2) Then Timer1.Enabled:=False;
      Timer1.Enabled:=False;
      Label3.Font.Color:=clBlue;
   End;

end;

procedure TAboutBox.FormPaint(Sender: TObject);
//Var LF:tagLogFonta;DC:THandle;P:PChar;
begin
{    LF.lfHeight:=10;
    LF.lfWidth:=0;
    LF.lfEscapement:=300;
    LF.lfFaceName:='Arial';
    DC:=GetDC(Handle);
    DeleteObject(SelectObject(DC,CreateFontIndirect(LF)));
    SetTextColor(DC,0);
    P:='HERE IT IS    ';
    TextOut(DC,20,200,P,10);
    ReleaseDC(DC,Handle);}
end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
//  ProgramIco_.Picture.Bitmap.LoadFromResourceID(hInstance,101);

  FBmp:=GetFormImage;
  //FBmp.SaveToFile('1.bmp');
  Panel1.Visible:=False;
  FXP1:=0;
  FS:=0;
//  FAniThread:=TAniThread.Create(True);
//  FAniThread.AboutBox:=Self;
end;

procedure TAboutBox.Label3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
Label3.Font.Color:=clAqua;
Timer1.Enabled:=True;
FActive2:=True;
end;

procedure TAboutBox.Label3Click(Sender: TObject);
Var Url,User:String;
  R:TRegistry;
begin
     R:=TRegistry.Create;
try
     R.RootKey:=HKEY_LOCAL_MACHINE;
     R.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion',False);
     User:='';

     If R.ValueExists('RegisteredOwner') Then
       begin
         User:=R.ReadString('RegisteredOwner');
         User:=' from '+User;
       end;
     Url:='mailto:'+Label3.Caption+'?subject=Questions about calc vanhours'+User;
     ShellExecute(Handle, 'open', pchar(Url), Nil, Nil, SW_SHOWNORMAL);
finally
     R.Free;
end;

end;

procedure TAboutBox.AniTimerTimer(Sender: TObject);
Var H,W:Integer;sR:TRect;
begin
   For H:=0 To Height div 20 Do
     For W:=0 To Width div 20 Do
       begin
         sR.Top:=H*20;
         sR.Bottom:=H*20+FS;
         sR.Left:=W*20+FS;
         sR.Right:=W*20+FS+4;

         Canvas.CopyRect(sR,FBmp.Canvas,sR);

       end;

      Inc(FS,4);
      If FS>24 Then
    begin
      FBmp.Free;
      AniTimer.Enabled:=False;
      Panel1.Visible:=True;
      Timer1.Enabled:=True;
   //   FAniThread.Resume;
    end;
{
  If FXP1>FBmp.Width div 2 Then
    begin
      FBmp.Free;
      AniTimer.Enabled:=False;
      Panel1.Visible:=True;
      Timer1.Enabled:=True;
    end
   Else
    begin
      Canvas.CopyRect(Rect(FBmp.Width div 2 +FXP1,0,FBmp.Width div 2 +FXP1+10,FBmp.Height),FBmp.Canvas,
                      Rect(FBmp.Width div 2 +FXP1,0,FBmp.Width div 2 +FXP1+10,FBmp.Height));
      Canvas.CopyRect(Rect(FXP1,0,FXP1+10,FBmp.Height),FBmp.Canvas,Rect(FXP1,0,FXP1+10,FBmp.Height));
      Inc(FXP1,10);
    end;}
end;

procedure TAboutBox.FormShow(Sender: TObject);
begin
    AniTimer.Enabled:=True;
end;

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
    ModalResult:=mrOk;
end;

procedure TAboutBox.FormDestroy(Sender: TObject);
begin
//  FAniThread.Terminate;
  AniTimer.Enabled:=False;
  Timer1.Enabled:=False;
end;

{ TAniThread }

destructor TAniThread.Destroy;
begin
  FAniBmp.Free;
  inherited;
end;

procedure TAniThread.Draw;
Var sR:TRect;
begin
  sR.Left:=FFrmN*121;
  sR.Right:=sR.Left+121;
  sR.Top:=0;
  sR.Bottom:=89;
  If Terminated Then Exit;
 // FAboutBox.ProgramIco_.Canvas.CopyRect(FAboutBox.ProgramIco_.BoundsRect,FAniBmp.Canvas,sR);
  FAboutBox.ProgramIco_.Canvas.Draw(-FFrmN*121,0,FAniBmp);
 Inc(FFrmN);
 If FFrmN=33 Then FFrmN:=0;
end;

procedure TAniThread.Execute;
Var H,M,S,mS,mS1:Word;
begin
  FreeOnTerminate:=True;
  FFrmN:=0;
  FAniBmp:=TBitmap.Create;
  FAniBmp.LoadFromResourceID(hInstance,104);
  While True Do
    begin
     If Terminated Then Exit;
        DecodeTime(Time,H,M,S,mS1);
        mS:=mS1;
        While Abs(mS mod 1000 - mS1 mod 1000)<150 Do
           DecodeTime(Time,H,M,S,mS1);
     If Terminated Then Exit;
       Synchronize(Draw);
    end;
end;

end.
