unit addtrn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, trains;

type
  TAddTForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    NumberSE: TSpinEdit;
    VanCountSE: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    HourSE: TSpinEdit;
    MinuteSE: TSpinEdit;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure NumberSEKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ExcludeTrain:TTrain;
    TrainType:Integer;
  end;

var
  AddTForm: TAddTForm;

implementation
Uses Main, calcwin;
{$R *.DFM}

var NTr:Integer=2001;

procedure TAddTForm.Button1Click(Sender: TObject);
Label IsNPresent,IsTPresent;
Var CF:TCalcForm;
begin
  CF:=TCalcForm(MainForm.ActiveMDIChild);
  If CF.CalcProject.IsNumberTrainPresent(NumberSE.Value,TrainType,ExcludeTrain) Then goto IsNPresent;
//  If CF.CalcProject.IsTrainTimePresent(HourSE.Value,MinuteSE.Value,TrainType,ExcludeTrain) Then goto IsTPresent;

  NTr:=NumberSE.Value;
  Inc(NTr,2);
  ModalResult:=mrOk;
  Exit;
IsNPresent:
  MessageBox(Handle,PChar('Повтор номера поезда!'),'Расчет вагоно-часов',MB_OK or MB_ICONASTERISK);
  Exit;
IsTPresent:
  MessageBox(Handle,PChar('Два поезда на одно время!'),'Расчет вагоно-часов',MB_OK or MB_ICONASTERISK);
  Exit;
end;

procedure TAddTForm.NumberSEKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Key = VK_RETURN Then Button1Click(Button1);
end;

procedure TAddTForm.FormShow(Sender: TObject);
begin
  NumberSE.Value:=NTr;
end;

end.
