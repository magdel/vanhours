program vanhours;

uses
  Forms,
  MAIN in 'MAIN.PAS' {MainForm},
  calcwin in 'calcwin.pas' {CalcForm},
  trains in 'trains.pas',
  addtrn in 'addtrn.pas' {AddTForm},
  newprj in 'newprj.pas' {NewProjForm},
  Aboutbx in 'Aboutbx.pas' {AboutBox},
  preprint in 'preprint.pas' {PrePForm},
  prntmng in 'prntmng.pas',
  prninfo in 'prninfo.pas' {PrnPForm},
  zastfrm in 'zastfrm.pas' {ZastForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.UpdateFormatSettings:=False;
  Application.Title := 'VanHours';
  ZastForm:=TZastForm.Create(Application);
  ZastForm.Show;
  ZastForm.Repaint;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAddTForm, AddTForm);
  Application.CreateForm(TPrePForm, PrePForm);
  Application.Run;
end.
