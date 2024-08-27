unit trains;

interface

Uses Windows, Messages, SysUtils, Classes, Graphics, contnrs, Forms, Controls;

Const
  FileSign1=Integer(Ord('U')+256*Ord('E')+256*256*Ord('R')+256*256*256*Ord(' '));
  FileSign2=Integer(Ord('2')+256*Ord('0')+256*256*Ord('0')+256*256*256*Ord('1'));
  FileSign3=Integer(Ord(' ')+256*Ord(' ')+256*256*Ord(' ')+256*256*256*Ord(' '));
  FileSign4=Integer(Ord(' ')+256*Ord(' ')+256*256*Ord('0')+256*256*256*Ord('1'));

  ttArrive=1;
  ttDepart=2;

type
  //our exception classes for correct handling possible errors
  ECalcProjectError=class(Exception);
  ETrainError=class(ECalcProjectError);

  TCalcProject=class;

  TTrain=class(TObject)
  private
    FCalcProject: TCalcProject;
    FNumber: Integer;
    FTime: TDateTime;
    FVanCount: Integer;
    function GetsNumber: String;
    function GetsTime: String;
    function GetsVanCount: String;
    function GetBaseTime: TDateTime;
    procedure SetNumber(const Value: Integer);
    procedure SetTime(const Value: TDateTime);
    procedure SetVanCount(const Value: Integer);
  public

    function ApplyVanCount(CurrentVanCount: Integer): Integer; virtual; abstract;
    procedure LoadFromStream(Stream: TMemoryStream);
    procedure SaveToStream(Stream: TMemoryStream);

    property BaseTime: TDateTime read GetBaseTime;
    property iNumber: Integer read FNumber write SetNumber;
    property sNumber: String read GetsNumber;
    property sTime: String read GetsTime;
    property sVanCount: String read GetsVanCount;
    property Time: TDateTime read FTime write SetTime;
    property VanCount: Integer read FVanCount write SetVanCount;
  End;

  TArriveTrain=class(TTrain)
  private

  public
    Constructor Create(CP: TCalcProject; TrainNumber: Integer; ArriveTime: TDateTime; VanCount: Integer);

    function ApplyVanCount(CurrentVanCount: Integer): Integer; override;

  End;

  TDepartTrain=class(TTrain)
  private

  public
    Constructor Create(CP: TCalcProject; TrainNumber: Integer; DepartTime: TDateTime; VanCount: Integer);

    function ApplyVanCount(CurrentVanCount: Integer): Integer; override;

  End;

  TCalcProject=class(TObject)
  private
    FArriveTrainList: TObjectList;
    FConstVanCount: Integer;
    FDepartTrainList: TObjectList;
    FForm: TForm;
    FFileName: String;
    FSaved: Boolean;
    FLoading: Boolean; //is in loading data state
    FCalcKVDI: Boolean; //расчет для КВДИ (с 8:00 до 12:00)

    function GetArriveTrains(Index: Integer): TArriveTrain;
    function GetArriveTrainsCount: Integer;
    function GetDepartTrains(Index: Integer): TDepartTrain;
    function GetDepartTrainsCount: Integer;
    function GetUsedVanCount: Integer;
    procedure LoadFromStream(Stream: TMemoryStream);
    procedure SaveToStream(Stream: TMemoryStream);
    procedure SetConstVanCount(const Value: Integer);
    procedure SetFileName(const Value: String);
    procedure SetCalcKVDI(const Value: Boolean);
    function GetArrivedVansCount: Integer;
    function GetDepartedVansCount: Integer;
  public
    Constructor Create(ConstVanCount: Integer;ACalcKVDI:Boolean);
    Destructor Destroy; override;

    function GetIsVanCountCycled: Boolean; //---van count at end is the same at begin
    function GetSortedAllTrainList: TObjectList; //-----you responsible for freeing after using this list!!!
    function GetVanHours: Single; //-----result--------------------------------
    function IsNumberTrainPresent(Number, TrainType: Integer; ExcludeTrain: TTrain): Boolean;
    function IsTrainTimePresent(H, M: Integer; TrainType: Integer; ExcludeTrain: TTrain): Boolean;

    procedure AddTrain(Train: TTrain);
    procedure FreeWindow;
    procedure Load;
    procedure ReCreateArriveListView;
    procedure ReCreateDepartListView;
    procedure RemoveTrain(Train: TTrain);
    procedure Save;
    procedure SortTrainsList;
    procedure UpdateInfoLabels;

    property ArriveTrains[Index: Integer]: TArriveTrain read GetArriveTrains;
    property ArriveTrainsCount: Integer read GetArriveTrainsCount;
    property ArrivedVansCount: Integer read GetArrivedVansCount;
    property CalcKVDI: Boolean read FCalcKVDI write SetCalcKVDI;
    property ConstVanCount: Integer read FConstVanCount write SetConstVanCount;
    property DepartTrains[Index: Integer]: TDepartTrain read GetDepartTrains;
    property DepartTrainsCount: Integer read GetDepartTrainsCount;
    property DepartedVansCount: Integer read GetDepartedVansCount;
    property FileName: String read FFileName write SetFileName;
    property Saved: Boolean read FSaved write FSaved;
    property UsedVanCount: Integer read GetUsedVanCount;
  End;

procedure StreamToStr(Stream: TMemoryStream; var S: String);
procedure StrToStream(S: String; Stream: TMemoryStream);

Var
  ProgramRoot: String;

implementation
Uses main, calcwin, registry;

{ TTrain }

function TTrain.GetBaseTime: TDateTime;
Var
  T: TDateTime;
begin
{$OPTIMIZATION ON}
  If FCalcProject.FCalcKVDI Then
  begin
    T:=FTime;
    If T<8/24 Then T:=8/24;
    If T>12/24 Then T:=12/24;
    T:=T-1/24*18+1;
  end
  Else
  begin
    T:=FTime;
    If T<18/24 Then T:=T+1;
    T:=T-1/24*18;

  end;
  Result:=T;
end;

function TTrain.GetsNumber: String;
begin
  Result:=IntToStr(FNumber);
end;

function TTrain.GetsTime: String;
begin
  Result:=TimeToStr(FTime);
end;

function TTrain.GetsVanCount: String;
begin
  Result:=IntToStr(FVanCount);
end;

procedure TTrain.LoadFromStream(Stream: TMemoryStream);
begin
  Stream.Read(FNumber, SizeOf(FNumber));
  Stream.Read(FTime, SizeOf(FTime));
  Stream.Read(FVanCount, SizeOf(FVanCount));
end;

procedure TTrain.SaveToStream(Stream: TMemoryStream);
begin
  Stream.Write(FNumber, SizeOf(FNumber));
  Stream.Write(FTime, SizeOf(FTime));
  Stream.Write(FVanCount, SizeOf(FVanCount));
end;

procedure TTrain.SetNumber(const Value: Integer);
begin
  FNumber:=Value;
  FCalcProject.Saved:=False;
end;

procedure TTrain.SetTime(const Value: TDateTime);
begin
  FTime:=Value;
  FCalcProject.Saved:=False;
end;

procedure TTrain.SetVanCount(const Value: Integer);
begin
  FVanCount:=Value;
  FCalcProject.Saved:=False;
end;

{ TArriveTrain }

function TArriveTrain.ApplyVanCount(CurrentVanCount: Integer): Integer;
begin
  Result:=CurrentVanCount+FVanCount;
end;

constructor TArriveTrain.Create(CP: TCalcProject; TrainNumber: Integer; ArriveTime: TDateTime; VanCount: Integer);
begin
  FCalcProject:=CP;
  FNumber:=TrainNumber;
  FTime:=ArriveTime;
  FVanCount:=VanCount;
end;

{ TDepartTrain }

function TDepartTrain.ApplyVanCount(CurrentVanCount: Integer): Integer;
begin
  Result:=CurrentVanCount-FVanCount;
  If Result<0 Then
  Begin
      //MessageBox(MainForm.Handle,PChar('Недостаточно вагонов для отправления поезда №'+sNumber+'!'),'Расчет вагоно-часов',MB_OK or MB_ICONERROR);
    raise ETrainError.Create('Недостаточно вагонов для отправления поезда №'+sNumber+'!'); //Abort;
  End;
end;

constructor TDepartTrain.Create(CP: TCalcProject; TrainNumber: Integer; DepartTime: TDateTime; VanCount: Integer);
begin
  FCalcProject:=CP;
  FNumber:=TrainNumber;
  FTime:=DepartTime;
  FVanCount:=VanCount;
end;

{ TCalcProject }

procedure TCalcProject.AddTrain(Train: TTrain);
begin
  If Train is TArriveTrain Then
  begin
    FArriveTrainList.Add(Train);
    Saved:=False;
    If not FLoading Then ReCreateArriveListView;
    Exit;
  end;
  If Train is TDepartTrain Then
  begin
    FDepartTrainList.Add(Train);
    Saved:=False;
    If not FLoading Then ReCreateDepartListView;
    Exit;
  end;
end;

constructor TCalcProject.Create(ConstVanCount: Integer;ACalcKVDI:Boolean);
Var
  CF: TCalcForm;
begin
  //LongTimeFormat:=ShortTimeFormat;
  FConstVanCount:=ConstVanCount;
  FCalcKVDI:=ACalcKVDI;
  FArriveTrainList:=TObjectList.Create(True); //auto object freeing managment
  FDepartTrainList:=TObjectList.Create(True); //auto object freeing managment

  CF:=TCalcForm.Create(MainForm);
  CF.CalcProject:=Self;
  FFileName:='Unknown';
  CF.Caption:=FFileName;
  FForm:=CF;
  Application.ProcessMessages;
  try
    UpdateInfoLabels;
  except
  end;
end;

destructor TCalcProject.Destroy;
begin
  FArriveTrainList.Free;
  FDepartTrainList.Free;

  inherited;
end;

procedure TCalcProject.FreeWindow;
begin
  FForm.Free;
end;

function TimeSort(Item1, Item2: Pointer): Integer;
Var
  T1, T2: TTrain;
begin
{$OPTIMIZATION ON}
  T1:=Item1; T2:=Item2; Result:=0;
  If T1.BaseTime>T2.BaseTime Then
    Result:=1
  Else If T1.BaseTime<T2.BaseTime Then
    Result:=-1
  Else{// if they are at same time then TArriveTrain go first !!!} If not(T1 is T2.ClassType) Then
    If T1 is TArriveTrain Then
      Result:=1
    Else
      Result:=-1;
end;

function TCalcProject.GetArrivedVansCount: Integer;
Var
  I: Integer;
begin
  Result:=0;
  For I:=0 To FArriveTrainList.Count-1 Do
  begin
    Result:=Result+TTrain(FArriveTrainList[I]).VanCount;
  end;
end;

function TCalcProject.GetArriveTrains(Index: Integer): TArriveTrain;
begin
  Result:=TArriveTrain(FArriveTrainList.Items[Index]);
end;

function TCalcProject.GetArriveTrainsCount: Integer;
begin
  Result:=FArriveTrainList.Count;
end;

function TCalcProject.GetDepartedVansCount: Integer;
Var
  I: Integer;
begin
  Result:=0;
  For I:=0 To FDepartTrainList.Count-1 Do
  begin
    Result:=Result+TTrain(FDepartTrainList[I]).VanCount;
  end;
end;

function TCalcProject.GetDepartTrains(Index: Integer): TDepartTrain;
begin
  Result:=TDepartTrain(FDepartTrainList.Items[Index]);
end;

function TCalcProject.GetDepartTrainsCount: Integer;
begin
  Result:=FDepartTrainList.Count;
end;

function TCalcProject.GetIsVanCountCycled: Boolean;
Var
  TL: TObjectList; Tr: TTrain;
  I, CVC: Integer;
begin
{$OPTIMIZATION ON}
  If FCalcKVDI Then
  begin Result:=True; Exit; End;
  CVC:=FConstVanCount;

  TL:=GetSortedAllTrainList;
  try

    For I:=0 To TL.Count-1 Do
    begin
      Tr:=TTrain(TL.Items[I]);

      If Tr.BaseTime=0 Then
      begin
        CVC:=Tr.ApplyVanCount(CVC);
        Continue;
      end;

      CVC:=TR.ApplyVanCount(CVC);
    end;
  finally
    TL.Free;
  end;

  Result:=CVC=FConstVanCount;
end;

function TCalcProject.GetSortedAllTrainList: TObjectList;
Var
  TL: TObjectList; I: Integer;
begin
{$OPTIMIZATION ON}
  TL:=TObjectList.Create(False);

  For I:=0 To FArriveTrainList.Count-1 Do
    TL.Add(FArriveTrainList.Items[I]);

  For I:=0 To FDepartTrainList.Count-1 Do
    TL.Add(FDepartTrainList.Items[I]);

  TL.Sort(TimeSort);
  Result:=TL;
end;

function TCalcProject.GetUsedVanCount: Integer;
//Var
 // I: Integer;
begin
  Result:=FConstVanCount+ArrivedVansCount;
  {For I:=0 To FArriveTrainList.Count-1 Do
  begin
    Result:=Result+TTrain(FArriveTrainList.Items[I]).VanCount;
  end;}
end;

   { DONE 1 -oRayev Pavel -cCommon : Look for more trains for one time!!! }

function TCalcProject.GetVanHours: Single;
Var
  CT: TDateTime; CVH: Single;
  TL: TObjectList; Tr: TTrain;
  I, CVC: Integer;
begin
{$OPTIMIZATION ON}
  CVH:=0; CT:=0; CVC:=FConstVanCount;

  TL:=GetSortedAllTrainList;
  try

    For I:=0 To TL.Count-1 Do
    begin
      Tr:=TTrain(TL.Items[I]);

      If Tr.BaseTime=0 Then
      begin
        CVC:=Tr.ApplyVanCount(CVC);
        Continue;
      end;

     { TODO : for KVDI!!! }
      CVH:=CVH+CVC*(Tr.BaseTime-CT);

      CT:=Tr.BaseTime;
      CVC:=Tr.ApplyVanCount(CVC);
    end;
    CVH:=CVH+CVC*(1-CT);
  finally
    TL.Free;
  end;
  //If FCalcKVDI Then
   // Result:=CVH*4
  //Else
  Result:=CVH*4;
end;

function TCalcProject.IsNumberTrainPresent(Number, TrainType: Integer; ExcludeTrain: TTrain): Boolean;
Var
  I: Integer; //TL:TObjectList;
begin
{$OPTIMIZATION ON}
  Result:=True;

//------------------------------------------------------------------------------
//           separate arrival and departural train numbers check
//------------------------------------------------------------------------------

  Case TrainType Of
//------------------------------------------------------------------------------
//       on arrive
//------------------------------------------------------------------------------
    ttArrive:
      For I:=0 To FArriveTrainList.Count-1 Do
        If TTrain(FArriveTrainList.Items[I])<>ExcludeTrain Then
          If TTrain(FArriveTrainList.Items[I]).iNumber=Number Then Exit;

//------------------------------------------------------------------------------
//       on depart
//------------------------------------------------------------------------------
    ttDepart:
      For I:=0 To FDepartTrainList.Count-1 Do
        If TTrain(FDepartTrainList.Items[I])<>ExcludeTrain Then
          If TTrain(FDepartTrainList.Items[I]).iNumber=Number Then Exit;
  End;
  Result:=False;
//------------------------------------------------------------------------------
//    total check
//------------------------------------------------------------------------------
{TL:=GetSortedAllTrainList;
try

  For I:=0 To TL.Count-1 Do
    If TTrain(TL.Items[I])<>ExcludeTrain Then If TTrain(TL.Items[I]).iNumber = Number Then Exit;

    Result:=False;
finally
  TL.Free;
end;}
end;

function TCalcProject.IsTrainTimePresent(H, M, TrainType: Integer; ExcludeTrain: TTrain): Boolean;
Var
  Time: TDateTime; I: Integer;
begin
{$OPTIMIZATION ON}
  Result:=True;
  Time:=EncodeTime(H, M, 0, 0);
  Case TrainType Of
    ttArrive:
      begin
        For I:=0 To FArriveTrainList.Count-1 Do
          If TTrain(FArriveTrainList.Items[I])<>ExcludeTrain Then
            If TTrain(FArriveTrainList.Items[I]).Time=Time Then Exit;
        Result:=False;
      end;
    ttDepart:
      begin
        For I:=0 To FDepartTrainList.Count-1 Do
          If TTrain(FDepartTrainList.Items[I])<>ExcludeTrain Then
            If TTrain(FDepartTrainList.Items[I]).Time=Time Then Exit;
        Result:=False;
      end;
  End;
end;

procedure TCalcProject.Load;
var
  Save_Cursor: TCursor;
  Stream: TMemoryStream;
begin
  Save_Cursor:=Screen.Cursor;
  Screen.Cursor:=crHourglass; { Show hourglass cursor }
  try
    { Do some lengthy operations }
    Stream:=TMemoryStream.Create;
    try
      try
        Stream.LoadFromFile(FFileName);
      except
        Saved:=True;
        raise;
      end;
      FLoading:=True;
      LoadFromStream(Stream);
    finally
      FLoading:=False;
      Stream.Free;
    end;

  finally
    Screen.Cursor:=Save_Cursor; { Always restore to normal }
  end;

  FForm.Caption:=FFileName;
  ReCreateArriveListView;
  ReCreateDepartListView;
  try
    UpdateInfoLabels;
  except
    on ETrainError Do ;
  end;
  Saved:=True;
end;

procedure TCalcProject.LoadFromStream(Stream: TMemoryStream);
Var{Tp,}
  N, N1, N2, N3, N4, I: Integer;
   // P:TProgressBar;
    //SI:TSaveInfo;
    //Element:TElement;
  sUser: String; Train: TTrain;
Begin

//   P:=TProgressBar.Create(MainForm);
  try
//   P.Height:=MainForm.StatusBar1.Height-4;
//   With MainForm.StatusBar1.Panels Do
 //  P.Width:=MainForm.StatusBar1.ClientWidth-Items[0].Width-Items[1].Width;
 //  With MainForm.StatusBar1.Panels Do
 //  P.Left:=Items[0].Width+Items[1].Width;
 //  P.Top:=2;
 //  P.Parent:=MainForm.StatusBar1;
//   P.Min:=0;P.Step:=1;P.Max:=10;
    Stream.Read(N1, SizeOf(N1));
    Stream.Read(N2, SizeOf(N2));
    Stream.Read(N3, SizeOf(N3));
    Stream.Read(N4, SizeOf(N4));

    If (N1<>FileSign1)or(N2<>FileSign2)or(N3<>FileSign3)or(N4<>FileSign4) Then
    begin
      raise ECalcProjectError.CreateFmt('Файл %s не явлется расчетом или поврежден', [FFileName]);
    end;

   //Stream.Read(SI,SizeOf(SI));

  // FVanPresent:=SI.SomeReserv[srVanPresent]=255;
  // FOwnerDataPresent:=SI.SomeReserv[srGruzOwnerDataPresent]=255;

    StreamToStr(Stream, sUser);
    StreamToStr(Stream, sUser);
    StreamToStr(Stream, sUser);
    sUser:=sUser+sUser;

    Stream.Read(FConstVanCount, SizeOf(FConstVanCount));

    Stream.Read(N, SizeOf(N)); //читаем кол-во ArriveTrain
  // P.Max:=N;
    For I:=0 To N-1 Do
    begin
      Train:=TArriveTrain.Create(Self, 0, 0, 0);
      Train.LoadFromStream(Stream);
      AddTrain(Train);
    end;

    Stream.Read(N, SizeOf(N)); //читаем кол-во DepartTrain
  // P.Max:=N;
    For I:=0 To N-1 Do
    begin
      Train:=TDepartTrain.Create(Self, 0, 0, 0);
      Train.LoadFromStream(Stream);
      try
        AddTrain(Train);
      except
        on ETrainError Do ;
      end;
    end;

    Stream.Read(FCalcKVDI, SizeOf(FCalcKVDI));

  finally
//P.Free;
  end;

end;

procedure TCalcProject.ReCreateArriveListView;
Var
  CF: TCalcForm; I: Integer; T: TTrain;
begin
  CF:=TCalcForm(FForm);
  CF.ATListView.Items.Clear;

  FArriveTrainList.Sort(TimeSort);
  CF.ATListView.Items.BeginUpdate;
  For I:=0 To FArriveTrainList.Count-1 Do
  begin
    T:=TTrain(FArriveTrainList.Items[I]);
    with CF.ATListView.Items.Add do
    begin
      Data:=T;
      ImageIndex:=24;
      Caption:=T.sNumber;
      SubItems.Add(T.sTime);
      SubItems.Add(T.sVanCount);
              //ImageIndex := ImageMap[ResType];
    end;
  end;
  CF.ATListView.Items.EndUpdate;
  UpdateInfoLabels;
end;

procedure TCalcProject.ReCreateDepartListView;
Var
  CF: TCalcForm; I: Integer; T: TTrain;
begin
  CF:=TCalcForm(FForm);
  CF.DTListView.Items.Clear;

  FDepartTrainList.Sort(TimeSort);
  CF.DTListView.Items.BeginUpdate;
  For I:=0 To FDepartTrainList.Count-1 Do
  begin
    T:=TTrain(FDepartTrainList.Items[I]);
    with CF.DTListView.Items.Add do
    begin
      Data:=T;
      ImageIndex:=26;
      Caption:=T.sNumber;
      SubItems.Add(T.sTime);
      SubItems.Add(T.sVanCount);
              //ImageIndex := ImageMap[ResType];
    end;
  end;
  CF.DTListView.Items.EndUpdate;
  UpdateInfoLabels;
end;

procedure TCalcProject.RemoveTrain(Train: TTrain);
begin
  If Train is TArriveTrain Then
  begin
    FArriveTrainList.Remove(Train);
    ReCreateArriveListView;
    Saved:=False;
    Exit;
  end;
  If Train is TDepartTrain Then
  begin
    FDepartTrainList.Remove(Train);
    ReCreateDepartListView;
    Saved:=False;
    Exit;
  end;
end;

procedure TCalcProject.Save;
var
  Save_Cursor: TCursor;
  Stream: TMemoryStream;
begin
  Save_Cursor:=Screen.Cursor;
  Screen.Cursor:=crHourglass; { Show hourglass cursor }
  try
    { Do some lengthy operations }
    Stream:=TMemoryStream.Create;
    try
      SaveToStream(Stream);
      Stream.SaveToFile(FFileName);
    finally
      Stream.Free;
    end;

  finally
    Screen.Cursor:=Save_Cursor; { Always restore to normal }
  end;
  Saved:=True;
end;

procedure TCalcProject.SaveToStream(Stream: TMemoryStream);
Var
  N, I: Integer;
//    P:TProgressBar;
//    SI:TSaveInfo;
//    Element:TElement;
  sUser: String;
  R: TRegistry;
  Train: TTrain;
Begin

//   P:=TProgressBar.Create(MainForm);
  try
//   P.Height:=MainForm.StatusBar1.Height-4;
//   With MainForm.StatusBar1.Panels Do
//   P.Width:=MainForm.StatusBar1.ClientWidth-Items[0].Width-Items[1].Width;
//   With MainForm.StatusBar1.Panels Do
//   P.Left:=Items[0].Width+Items[1].Width;
//   P.Top:=2;
//   P.Parent:=MainForm.StatusBar1;
//   P.Min:=0;P.Max:=18;P.Step:=1;

 //   P.StepIt;
    N:=FileSign1; //сохраняем заголовок для идентификации
    Stream.Write(N, SizeOf(N));
    N:=FileSign2; Stream.Write(N, SizeOf(N));
    N:=FileSign3; Stream.Write(N, SizeOf(N));
    N:=FileSign4; Stream.Write(N, SizeOf(N));
                              //сохраняем имя пользователя

//    P.StepIt;
//      SI.LastSaveDate:=Now;
//      SI.CreateDate:=Now;
//      SI.ElementsCount:=ElementsCount;

//      For I:=0 To 15 Do SI.SomeReserv[I]:=0;
// save flag about van presence
//      If FVanPresent Then SI.SomeReserv[srVanPresent]:=255;
//      If FOwnerDataPresent Then SI.SomeReserv[srGruzOwnerDataPresent]:=255;

//      Stream.Write(SI,SizeOf(SI));
  // сохраняем имя владельца компа
    R:=TRegistry.Create;
    TRY
      R.RootKey:=HKEY_LOCAL_MACHINE; R.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion', False);
      sUser:='';
      If R.ValueExists('RegisteredOwner') Then
      begin
        sUser:=R.ReadString('RegisteredOwner');
      end;
      StrToStream(sUser, Stream); sUser:='';
      If R.ValueExists('ProductName') Then
      begin
        sUser:=R.ReadString('ProductName');
      end;
      StrToStream(sUser, Stream); sUser:='';
      If R.ValueExists('VersionNumber') Then
      begin
        sUser:=R.ReadString('VersionNumber');
      end;
      StrToStream(sUser, Stream);
    FINALLY
      R.Free;
    END;

//    P.StepIt;

    // сохраняем элементы расчета   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    Stream.Write(FConstVanCount, SizeOf(FConstVanCount));

      //кол-во arrivetrain
    Stream.Write(FArriveTrainList.Count, SizeOf(FArriveTrainList.Count));

    For I:=0 To FArriveTrainList.Count-1 Do
    begin
      Train:=TTrain(FArriveTrainList.Items[I]);
      Train.SaveToStream(Stream);
    end;

      //кол-во departtrain
    Stream.Write(FDepartTrainList.Count, SizeOf(FDepartTrainList.Count));

    For I:=0 To FDepartTrainList.Count-1 Do
    begin
      Train:=TTrain(FDepartTrainList.Items[I]);
      Train.SaveToStream(Stream);
    end;
    Stream.Write(FCalcKVDI, SizeOf(FCalcKVDI));

  finally
//P.Free;
  end;
end;

procedure StreamToStr(Stream: TMemoryStream; var S: String);
Var
  L: Integer;
begin
  Stream.Read(L, SizeOf(L));
// if there is some large string then abort it!!!
  If L>10000 Then raise ECalcProjectError.Create('Файл не явлется расчетом или поврежден');
  SetLength(S, L);
  Stream.Read(Pointer(S)^, L);
end;

procedure StrToStream(S: String; Stream: TMemoryStream);
Var
  L: Integer;
begin
  L:=Length(S);
  Stream.Write(L, SizeOf(L));
  Stream.Write(Pointer(S)^, Length(S));
end;

function GetProgPath: String;
var
  pFlNm: PChar;
begin
  GetMem(PFlNm, 300);
  try
    GetModuleFileName(hInstance, PFlNm, 300-1);
    Result:=PFlNm;
    Result:=ExtractFilePath(Result);
  finally
    FreeMem(PFlNm, 300);
  end;
end;

procedure TCalcProject.SetCalcKVDI(const Value: Boolean);
begin
  FCalcKVDI:=Value;
  FSaved:=False;
  UpdateInfoLabels;
end;

procedure TCalcProject.SetConstVanCount(const Value: Integer);
begin
  FConstVanCount:=Value;
  FSaved:=False;
  UpdateInfoLabels;
end;

procedure TCalcProject.SetFileName(const Value: String);
begin
  FFileName:=Value;
  FForm.Caption:=FFileName;
end;

procedure TCalcProject.SortTrainsList;
begin
  FArriveTrainList.Sort(TimeSort);
  FDepartTrainList.Sort(TimeSort);
end;

procedure TCalcProject.UpdateInfoLabels;
begin
//  SortTrainsList;
  TCalcForm(FForm).Label9.Caption:=' недоступно ';
  TCalcForm(FForm).Label10.Caption:=' недоступно ';
  TCalcForm(FForm).Label12.Font.Color:=clWindowText;
  TCalcForm(FForm).Label12.Caption:=' недоступно ';

  TCalcForm(FForm).lbKVDI.Caption:='';
  If FLoading Then Exit;

  try

    TCalcForm(FForm).Label4.Caption:=IntToStr(FConstVanCount)+' вагонов';
//  TCalcForm(FForm).Label6.Caption:=IntToStr(UsedVanCount)+' вагонов';
    TCalcForm(FForm).Label9.Caption:=FormatFloat('0.0', GetVanHours)+' вагоно-часов';

    If FCalcKVDI Then
    begin
      If ArrivedVansCount=0 Then
        TCalcForm(FForm).Label10.Caption:=''
      Else
        TCalcForm(FForm).Label10.Caption:=FormatFloat('0.00', 2*GetVanHours/(ArrivedVansCount+DepartedVansCount))+' часов';
    end
    Else
    begin
      If UsedVanCount=0 Then
        TCalcForm(FForm).Label10.Caption:=''
      Else
        TCalcForm(FForm).Label10.Caption:=FormatFloat('0.00', GetVanHours/UsedVanCount)+' часов';

    end;
    If GetIsVanCountCycled Then
    begin
      TCalcForm(FForm).Label12.Caption:=' Да ';
      TCalcForm(FForm).Label12.Font.Color:=clGreen;
    end
    Else
    begin
      TCalcForm(FForm).Label12.Caption:=' Нет ';
      TCalcForm(FForm).Label12.Font.Color:=clRed;
    end;
    If FCalcKVDI Then TCalcForm(FForm).Label12.Font.Color:=clGrayText;
    If FCalcKVDI Then TCalcForm(FForm).lbKVDI.Caption:='Расчет для КВДИ!';

    TCalcForm(FForm).Label9.Font.Color:=clGreen;
    TCalcForm(FForm).Label10.Font.Color:=clGreen;
  except
    on E: ETrainError Do
    begin
      TCalcForm(FForm).Label9.Font.Color:=clRed;
      TCalcForm(FForm).Label10.Font.Color:=clRed;
      TCalcForm(FForm).Label9.Caption:=E.Message;
      TCalcForm(FForm).Label10.Caption:=E.Message;
      raise;
    end;
  end;

end;

initialization
  begin
    ProgramRoot:=GetProgPath;

  end;

end.

