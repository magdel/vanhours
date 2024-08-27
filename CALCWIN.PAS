unit calcwin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, trains, ComCtrls;

type
  TCalcForm = class(TForm)
    Panel1: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    LTimer: TTimer;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel3: TPanel;
    Label2: TLabel;
    DTListView: TListView;
    Panel4: TPanel;
    Label1: TLabel;
    ATListView: TListView;
    lbKVDI: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Label4Click(Sender: TObject);
    procedure LTimerTimer(Sender: TObject);
    procedure Label4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ATListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DTListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ATListViewDblClick(Sender: TObject);
    procedure DTListViewDblClick(Sender: TObject);
    procedure ATListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure LVNumCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure LVTimeCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure LVVanCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FSortDirection:Integer;
    FActive1:Boolean;
  public
    { Public declarations }
    CalcProject:TCalcProject;
    property SortDirection:Integer read FSortDirection write FSortDirection;

  end;
                       {
var
  CalcForm: TCalcForm;}

implementation
Uses main;

{$R *.DFM}

procedure TCalcForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
If Not(CalcProject.Saved) Then                                                                    

 Case MessageBox(Handle,PChar('Расчет не сохранен ['+Caption+']. Сохранить?'),'Расчет вагоно-часов',MB_YESNOCANCEL or MB_ICONQUESTION) Of
   IDYES:begin
           Action := caNone;
           Activate;
           MainForm.ASave.Execute;
           CalcProject.Free;
           Action := caFree;
         End;
   IDNO:begin Action := caFree; CalcProject.Free;end;
   IDCANCEL:Action := caNone;
    End;
end;

procedure TCalcForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 CanClose:=True;
end;

procedure TCalcForm.Label4Click(Sender: TObject);
begin
MainForm.ACommon.Execute;
end;

procedure TCalcForm.LTimerTimer(Sender: TObject);
Var P,pt1,pt2:TPoint;R:TRect;
begin
Windows.GetCursorPos(P);
pt1.x:=0;pt1.y:=0;
pt1:=Label4.ClientToScreen(pt1);
pt2.x:=Label4.Width;pt2.y:=Label4.Height;
pt2:=Label4.ClientToScreen(pt2);
R:=Rect(pt1.x,pt1.y,pt2.x,pt2.y);

If Not(PtInRect(R,P)) and FActive1 Then
   Begin
      FActive1:=False;
      If not(FActive1) Then LTimer.Enabled:=False;
      Label4.Font.Color:=clWindowText;
   End;
end;

procedure TCalcForm.Label4MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
Label4.Font.Color:=clBlue;
LTimer.Enabled:=True;
FActive1:=True;
end;

procedure TCalcForm.ATListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Case Key Of
    VK_RETURN: //edit this train
      begin
        MainForm.AEditArriveTrain.Execute;
      end;
    VK_INSERT:  //add one more train
      begin
        MainForm.AAddArriveTrain.Execute;
      end;
    VK_DELETE:  //delete selected train
      begin
        MainForm.ARemoveArriveTrain.Execute;

      end;
  End;
end;

procedure TCalcForm.DTListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Case Key Of
    VK_RETURN: //edit this train
      begin
        MainForm.AEditDepartTrain.Execute;
      end;
    VK_INSERT:  //add one more train
      begin
        MainForm.AAddDepartTrain.Execute;
      end;
    VK_DELETE:  //delete selected train
      begin
        MainForm.ARemoveDepartTrain.Execute;

      end;
  End;
end;

procedure TCalcForm.ATListViewDblClick(Sender: TObject);
begin
    If ATListView.Selected<>nil Then MainForm.AEditArriveTrain.Execute;
end;

procedure TCalcForm.DTListViewDblClick(Sender: TObject);
begin
    If DTListView.Selected<>nil Then MainForm.AEditDepartTrain.Execute;
end;

procedure TCalcForm.ATListViewColumnClick(Sender: TObject; Column: TListColumn);
Var LV:TListView;
begin
LV:=TListView(Sender);
FSortDirection:=-FSortDirection;
  Case Column.Index Of
    0:
      begin
        LV.OnCompare:=LVNumCompare;
      end;
    1:
      begin
        LV.OnCompare:=LVTimeCompare;
      end;
    2:
      begin
        LV.OnCompare:=LVVanCompare;
      end;
  End;
LV.CustomSort(nil,0);
//FSortDirection:=-FSortDirection;
//LV.CustomSort(nil,0);
end;

procedure TCalcForm.LVNumCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
Var T1,T2:TTrain;
begin
{$OPTIMIZATION ON}
 T1:=TTrain(Item1.Data);T2:=TTrain(Item2.Data);
 Compare:=0;
 If T1.iNumber<T2.iNumber Then Compare:=FSortDirection
 Else If T1.iNumber>T2.iNumber Then Compare:=-FSortDirection;
end;

procedure TCalcForm.LVTimeCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
Var T1,T2:TTrain;
begin
{$OPTIMIZATION ON}
 T1:=TTrain(Item1.Data);T2:=TTrain(Item2.Data);
 Compare:=0;
 If T1.BaseTime<T2.BaseTime Then Compare:=FSortDirection
 Else If T1.BaseTime>T2.BaseTime Then Compare:=-FSortDirection;
end;

procedure TCalcForm.LVVanCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
Var T1,T2:TTrain;
begin
{$OPTIMIZATION ON}
 T1:=TTrain(Item1.Data);T2:=TTrain(Item2.Data);
 Compare:=0;
 If T1.VanCount<T2.VanCount Then Compare:=FSortDirection
 Else If T1.VanCount>T2.VanCount Then Compare:=-FSortDirection;
end;

procedure TCalcForm.FormCreate(Sender: TObject);
begin
FSortDirection:=1;
end;

end.
