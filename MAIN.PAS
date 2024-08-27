unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, Menus, ToolWin, ComCtrls, ImgList, AppEvnts, ExtCtrls,
  System.ImageList, System.Actions;

Const
     mnSaveAsk = 'Сохранить последние изменения?';

type
  TMainForm = class(TForm)
  
    ToolBar1: TToolBar;
    MainMenu1: TMainMenu;
    ActionList1: TActionList;
    ANewCalc: TAction;
    HotImageList: TImageList;
    ImageList1: TImageList;
    N1: TMenuItem;
    N2: TMenuItem;
    ASaveAs: TAction;
    AOpen: TAction;
    ASave: TAction;
    ACloseCalc: TAction;
    AOpen1: TMenuItem;
    ASave1: TMenuItem;
    ASaveAs1: TMenuItem;
    ACloseCalc1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    N5: TMenuItem;
    N6: TMenuItem;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    AAddArriveTrain: TAction;
    ARemoveArriveTrain: TAction;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    AAddDepartTrain: TAction;
    ARemoveDepartTrain: TAction;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton11: TToolButton;
    N11: TMenuItem;
    N12: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    ToolButton13: TToolButton;
    ACalc: TAction;
    ToolButton14: TToolButton;
    ACommon: TAction;
    N13: TMenuItem;
    N14: TMenuItem;
    AAbout: TAction;
    AEditArriveTrain: TAction;
    AEditDepartTrain: TAction;
    mnWin: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N22: TMenuItem;
    ToolButton10: TToolButton;
    PrinterSetupDialog1: TPrinterSetupDialog;
    PrintDialog1: TPrintDialog;
    APreview: TAction;
    ToolButton12: TToolButton;
    N23: TMenuItem;
    N24: TMenuItem;
    Image1: TImage;
    Image2: TImage;
    ImageA: TImage;
    ImageK: TImage;
    procedure N4Click(Sender: TObject);
    procedure AAddArriveTrainUpdate(Sender: TObject);
    procedure ANewCalcExecute(Sender: TObject);
    procedure AAddArriveTrainExecute(Sender: TObject);
    procedure ARemoveArriveTrainExecute(Sender: TObject);
    procedure ARemoveArriveTrainUpdate(Sender: TObject);
    procedure AAddDepartTrainUpdate(Sender: TObject);
    procedure ARemoveDepartTrainUpdate(Sender: TObject);
    procedure AAddDepartTrainExecute(Sender: TObject);
    procedure ARemoveDepartTrainExecute(Sender: TObject);
    procedure ASaveAsExecute(Sender: TObject);
    procedure AOpenExecute(Sender: TObject);
    procedure ACloseCalcUpdate(Sender: TObject);
    procedure ASaveAsUpdate(Sender: TObject);
    procedure ASaveUpdate(Sender: TObject);
    procedure ASaveExecute(Sender: TObject);
    procedure ACalcUpdate(Sender: TObject);
    procedure ACalcExecute(Sender: TObject);
    procedure ACommonUpdate(Sender: TObject);
    procedure ACommonExecute(Sender: TObject);
    procedure AAboutExecute(Sender: TObject);
    procedure ACloseCalcExecute(Sender: TObject);
    procedure AEditArriveTrainExecute(Sender: TObject);
    procedure AEditDepartTrainExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N16Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure APreviewUpdate(Sender: TObject);
    procedure APreviewExecute(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
  private
    { Private declarations }
    procedure Reciv(var Msg:TMessage);message WM_DROPFILES;
  public
    { Public declarations }
    procedure Open(FileName:String);
  end;

var
  MainForm: TMainForm;

implementation
Uses calcwin, shellapi, trains, addtrn, newprj, aboutbx, preprint, printers;
{$R *.DFM}

procedure TMainForm.N4Click(Sender: TObject);
begin
Close;
end;

procedure TMainForm.AAddArriveTrainUpdate(Sender: TObject);
begin
  If ActiveMDIChild <> nil Then
    begin

      AAddArriveTrain.Enabled:=True;
    end
  Else
    begin

      AAddArriveTrain.Enabled:=False;
    end;
end;

procedure TMainForm.ANewCalcExecute(Sender: TObject);
Var NewProjForm:TNewProjForm;
begin
  NewProjForm:=TNewProjForm.Create(MainForm);
  try
  If NewProjForm.ShowModal<>mrOk Then Exit;

  TCalcProject.Create(StrToInt(NewProjForm.Edit1.Text),NewProjForm.cbCalcKV.Checked);

  finally
    NewProjForm.Free;
  end;
end;

procedure TMainForm.AAddArriveTrainExecute(Sender: TObject);
Var AT:TArriveTrain;Tm:TDateTime;
begin
  AddTForm.TrainType:=ttArrive;
  AddTForm.ExcludeTrain:=nil;
  AddTForm.Caption:='Добавить поезд прибытия...';
  If AddTForm.ShowModal<>mrOk Then Exit;
  Tm:=EncodeTime(AddTForm.HourSE.Value,AddTForm.MinuteSE.Value,0,0);
  AT:=TArriveTrain.Create(TCalcForm(ActiveMDIChild).CalcProject,AddTForm.NumberSE.Value,Tm,AddtForm.VanCountSE.Value);
  TCalcForm(ActiveMDIChild).CalcProject.AddTrain(AT);
end;

procedure TMainForm.ARemoveArriveTrainExecute(Sender: TObject);
Var AT:TArriveTrain;CF:TCalcForm;
begin
  CF:=TCalcForm(ActiveMDIChild);
  AT:=(CF.ATListView.Selected.Data);
  Case MessageBox(Handle,PChar('Вы действительно хотите удалить поезд №'+AT.sNumber+' ?'),'Расчет вагоно-часов',MB_YESNO or MB_ICONQUESTION) Of
    IDYES:CF.CalcProject.RemoveTrain(AT);
    IDNO:Exit;
  End;
end;

procedure TMainForm.ARemoveArriveTrainUpdate(Sender: TObject);
begin
  If ActiveMDIChild <> nil Then
    begin
      If TCalcForm(ActiveMDIChild).ATListView.SelCount<>0 Then
        ARemoveArriveTrain.Enabled:=True
      Else
        ARemoveArriveTrain.Enabled:=False;
    end
  Else
    begin

      ARemoveArriveTrain.Enabled:=False;
    end;
end;

procedure TMainForm.AAddDepartTrainUpdate(Sender: TObject);
begin
  If ActiveMDIChild <> nil Then
    begin

      AAddDepartTrain.Enabled:=True;
    end
  Else
    begin

      AAddDepartTrain.Enabled:=False;
    end;
end;

procedure TMainForm.ARemoveDepartTrainUpdate(Sender: TObject);
begin
  If ActiveMDIChild <> nil Then
    begin
      If TCalcForm(ActiveMDIChild).DTListView.SelCount<>0 Then
        ARemoveDepartTrain.Enabled:=True
      Else
        ARemoveDepartTrain.Enabled:=False;
    end
  Else
    begin

      ARemoveDepartTrain.Enabled:=False;
    end;
end;

procedure TMainForm.AAddDepartTrainExecute(Sender: TObject);
Var AT:TDepartTrain;Tm:TDateTime;
begin
  AddTForm.TrainType:=ttDepart;
  AddTForm.ExcludeTrain:=nil;
  AddTForm.Caption:='Добавить поезд отправления...';
  If AddTForm.ShowModal<>mrOk Then Exit;
  Tm:=EncodeTime(AddTForm.HourSE.Value,AddTForm.MinuteSE.Value,0,0);
  AT:=TDepartTrain.Create(TCalcForm(ActiveMDIChild).CalcProject,AddTForm.NumberSE.Value,Tm,AddtForm.VanCountSE.Value);
  TCalcForm(ActiveMDIChild).CalcProject.AddTrain(AT);
end;

procedure TMainForm.ARemoveDepartTrainExecute(Sender: TObject);
Var DT:TDepartTrain;CF:TCalcForm;
begin
  CF:=TCalcForm(ActiveMDIChild);
  DT:=(CF.DTListView.Selected.Data);
  Case MessageBox(Handle,PChar('Вы действительно хотите удалить поезд №'+DT.sNumber+' ?'),'Расчет вагоно-часов',MB_YESNO or MB_ICONQUESTION) Of
    IDYES:CF.CalcProject.RemoveTrain(DT);
    IDNO:Exit;
  End;
end;

procedure TMainForm.ASaveAsExecute(Sender: TObject);
Label OpenAnother;
Var  Drv,DefPath:String;
     pFlNm:PChar;    CF:TCalcForm;
begin

GetMem(PFlNm,300);
try
GetModuleFileName(hInstance,PFlNm,300-1);
DefPath:=PFlNm;
finally
FreeMem(PFlNm,300);
end;
DefPath:=ExtractFilePath(DefPath);
Drv:=DefPath;
SetLength(Drv,1);

SaveDialog1.FileName:=DefPath+'Calcs\results.cvh';
SaveDialog1.Title:='Сохранить как...';
 If SaveDialog1.Execute Then
   begin
   CF:=TCalcForm(ActiveMDIChild);
// эдесь мы сохраняем проект под новым именем
         CF.CalcProject.FileName:=SaveDialog1.FileName;
         CF.CalcProject.FileName:=ChangeFileExt(CF.CalcProject.FileName,'.cvh');

         ASave.Enabled:=True;
         Cf.CalcProject.Save;
      //    StatusBar1.Panels[2].Text:=CF.CalcProject.FileName;

   end;

end;

procedure TMainForm.AOpenExecute(Sender: TObject);
Var
    FlNm:String;
    I:Integer;
begin
  OpenDialog1.FileName:=ProgramRoot+'calcs\results.cvh';
  If Not(OpenDialog1.Execute) Then Abort;
   For I:=0 To OpenDialog1.Files.Count-1 Do
     begin
       FlNm:=OpenDialog1.Files[I];
       try
         Open(FlNm);
       except
       end;
     end;
end;

procedure TMainForm.Open(FileName: String);
Var  CP:TCalcProject;
begin

      CP:=TCalcProject.Create(0,False);
      CP.FileName:=FileName;
      try
      CP.Load;

      except
        on E:ECalcProjectError do
          begin
            CP.FreeWindow;
            CP.Destroy;
            Case MessageBox(Handle,PChar(E.Message),'Расчет вагоно-часов',MB_OK or MB_ICONERROR) Of
              IDOK:;
            End;    
          raise;
          end;
      end;


end;

procedure TMainForm.ACloseCalcUpdate(Sender: TObject);
begin
ACloseCalc.Enabled := ActiveMDIChild <> nil;
end;

procedure TMainForm.ASaveAsUpdate(Sender: TObject);
begin
ASaveAs.Enabled := ActiveMDIChild <> nil;
end;

procedure TMainForm.ASaveUpdate(Sender: TObject);
begin
  If ActiveMDIChild <> nil Then
    begin
      If TCalcForm(ActiveMDIChild).CalcProject.Saved Then
        ASave.Enabled := False
      Else
        ASave.Enabled := True;
    end
  Else
   ASave.Enabled := False;//ActiveMDIChild <> nil;

end;

procedure TMainForm.ASaveExecute(Sender: TObject);
begin
  If TCalcForm(ActiveMDIChild).CalcProject.FileName='Unknown' Then begin ASaveAs.Execute; end Else
  TCalcForm(ActiveMDIChild).CalcProject.Save;
end;

procedure TMainForm.ACalcUpdate(Sender: TObject);
begin
ACalc.Enabled := ActiveMDIChild <> nil;
end;

procedure TMainForm.ACalcExecute(Sender: TObject);
Var VH:Single;AVP:Single;
begin
 VH:=TCalcForm(ActiveMDIChild).CalcProject.GetVanHours;
 ShowMessage('Вагоно-часы: '+FormatFloat('0.0',VH));
 AVP:=VH/TCalcForm(ActiveMDIChild).CalcProject.UsedVanCount;
 ShowMessage('Средний простой вагона: '+FormatFloat('0.00',AVP));
end;

procedure TMainForm.ACommonUpdate(Sender: TObject);
begin
ACommon.Enabled := ActiveMDIChild <> nil;
end;

procedure TMainForm.ACommonExecute(Sender: TObject);
Var NewProjForm:TNewProjForm;
begin
  NewProjForm:=TNewProjForm.Create(MainForm);
  try
  NewProjForm.Edit1.Text:=IntToStr(TCalcForm(ActiveMDIChild).CalcProject.ConstVanCount);
  NewProjForm.cbCalcKV.Checked:=TCalcForm(ActiveMDIChild).CalcProject.CalcKVDI;

  If NewProjForm.ShowModal<>mrOk Then Exit;

  TCalcForm(ActiveMDIChild).CalcProject.ConstVanCount:=StrToInt(NewProjForm.Edit1.Text);
  TCalcForm(ActiveMDIChild).CalcProject.CalcKVDI:=NewProjForm.cbCalcKV.Checked;

  finally
    NewProjForm.Free;
  end;

end;

procedure TMainForm.AAboutExecute(Sender: TObject);
begin
  With TAboutBox.Create(MainForm) Do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TMainForm.ACloseCalcExecute(Sender: TObject);
Var CP:TCalcProject;
begin
  CP:=TCalcForm(ActiveMDIChild).CalcProject;
  CP.FreeWindow;
  CP.Free;
end;

procedure TMainForm.AEditArriveTrainExecute(Sender: TObject);
Var AT:TArriveTrain;Tm:TDateTime;H,M,S,Ms:Word;SelI,SD:Integer;
begin
{$OPTIMIZATION ON}
  AT:=TCalcForm(ActiveMDIChild).ATListView.Selected.Data;
  SelI:=TCalcForm(ActiveMDIChild).ATListView.Selected.Index;

  DecodeTime(AT.Time,H,M,S,Ms);
  AddTForm.NumberSE.Value:=AT.iNumber;
  AddTForm.VanCountSE.Value:=AT.VanCount;
  AddTForm.HourSE.Value:=H;
  AddTForm.MinuteSE.Value:=M;
  AddTForm.ExcludeTrain:=AT;

  AddTForm.TrainType:=ttArrive;
  AddTForm.Caption:='Изменить поезд прибытия...';

  If AddTForm.ShowModal<>mrOk Then Exit;
  Tm:=EncodeTime(AddTForm.HourSE.Value,AddTForm.MinuteSE.Value,0,0);

  AT.Time:=Tm;
  AT.VanCount:=AddTForm.VanCountSE.Value;
  AT.iNumber:=AddTForm.NumberSE.Value;

  with TCalcForm(ActiveMDIChild).ATListView.Items.Item[SelI] do
    begin
      ImageIndex:=24;
      //Data := AT;
      Caption := AT.sNumber;
      SubItems.Clear;
      SubItems.Add(AT.sTime);
      SubItems.Add(AT.sVanCount);
    end;
  TCalcForm(ActiveMDIChild).CalcProject.SortTrainsList;
  SD:=TCalcForm(ActiveMDIChild).SortDirection;
  TCalcForm(ActiveMDIChild).SortDirection:=1;
  TCalcForm(ActiveMDIChild).ATListViewColumnClick(TCalcForm(ActiveMDIChild).ATListView,TCalcForm(ActiveMDIChild).ATListView.Columns[1]);
  TCalcForm(ActiveMDIChild).SortDirection:=SD;

  TCalcForm(ActiveMDIChild).CalcProject.UpdateInfoLabels;
//  TCalcForm(ActiveMDIChild).CalcProject.ReCreateArriveListView; //  obsolete
end;

procedure TMainForm.AEditDepartTrainExecute(Sender: TObject);
Var AT:TDepartTrain;Tm:TDateTime;H,M,S,Ms:Word;SelI,SD:Integer;
begin
{$OPTIMIZATION ON}
  AT:=TCalcForm(ActiveMDIChild).DTListView.Selected.Data;
  SelI:=TCalcForm(ActiveMDIChild).DTListView.Selected.Index;

  DecodeTime(AT.Time,H,M,S,Ms);
  AddTForm.NumberSE.Value:=AT.iNumber;
  AddTForm.VanCountSE.Value:=AT.VanCount;
  AddTForm.HourSE.Value:=H;
  AddTForm.MinuteSE.Value:=M;
  AddTForm.ExcludeTrain:=AT;

  AddTForm.TrainType:=ttDepart;
  AddTForm.Caption:='Изменить поезд отправления...';

  If AddTForm.ShowModal<>mrOk Then Exit;
  Tm:=EncodeTime(AddTForm.HourSE.Value,AddTForm.MinuteSE.Value,0,0);

  AT.Time:=Tm;
  AT.VanCount:=AddTForm.VanCountSE.Value;
  AT.iNumber:=AddTForm.NumberSE.Value;

  with TCalcForm(ActiveMDIChild).DTListView.Items[SelI] do
    begin
      ImageIndex:=26;
      //Data := AT;
      Caption := AT.sNumber;
      SubItems.Clear;
      SubItems.Add(AT.sTime);
      SubItems.Add(AT.sVanCount);
    end;

  TCalcForm(ActiveMDIChild).CalcProject.SortTrainsList;
  SD:=TCalcForm(ActiveMDIChild).SortDirection;
  TCalcForm(ActiveMDIChild).SortDirection:=1;
  TCalcForm(ActiveMDIChild).ATListViewColumnClick(TCalcForm(ActiveMDIChild).DTListView,TCalcForm(ActiveMDIChild).DTListView.Columns[1]);
  TCalcForm(ActiveMDIChild).SortDirection:=SD;

  TCalcForm(ActiveMDIChild).CalcProject.UpdateInfoLabels;
  //TCalcForm(ActiveMDIChild).CalcProject.ReCreateDepartListView; obsolete
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
Var I:Integer;                      
begin
 For I:=MDIChildCount-1 Downto 0 Do
    MDIChildren[I].Close;
CanClose:=False;
Application.ProcessMessages;
If MDIChildCount=0 Then CanClose:=True;
end;

procedure TMainForm.N16Click(Sender: TObject);
begin
Cascade;
end;

procedure TMainForm.N20Click(Sender: TObject);
begin
ArrangeIcons;
end;

procedure TMainForm.N18Click(Sender: TObject);
begin
TileMode:=tbHorizontal;
Tile;
end;

procedure TMainForm.N19Click(Sender: TObject);
begin
TileMode:=tbVertical;
Tile;
end;

procedure TMainForm.N22Click(Sender: TObject);
Var I:Integer;
begin
For I:=MDIChildCount-1 DownTo 0 Do                    {
  If MDIChildren[I].WindowState<>wsMinimized Then}
    MDIChildren[I].WindowState:=wsMinimized;
ArrangeIcons;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
DragAcceptFiles(Handle,True);
WindowMenu:=mnWin;
try
 CreateDir('Calcs');
except
end;
//WindowMenu:=N5;
end;

procedure TMainForm.Reciv(var Msg: TMessage);
Var
    F:PChar;
    Count,I:Integer;
Begin
GetMem(F,300);
  try
    Count:=DragQueryFile(Msg.WParam,$FFFFFFFF,nil,0);
    For I:=0 To Count-1 Do
      begin
        DragQueryFile(Msg.WParam,I,F,300);
        try
        Open(F);
        except
          //On E:Exception Do E.CreateFmt('Ошибка открытия %1',[F]);
        end;
      end;
  finally
    FreeMem(F);
    DragFinish(Msg.WParam);
  end;
end;

procedure TMainForm.APreviewUpdate(Sender: TObject);
begin
APreview.Enabled:=(MDIChildCount>0);
end;

procedure TMainForm.APreviewExecute(Sender: TObject);
begin
If TCalcForm(MainForm.ActiveMDIChild).CalcProject.GetIsVanCountCycled Then;
PrePForm.ShowModal;
end;

procedure TMainForm.FormDblClick(Sender: TObject);
begin
AOpenExecute(AOpen1);
end;

end.
