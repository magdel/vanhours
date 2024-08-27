unit zastfrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TZastForm = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ZastForm: TZastForm;

implementation

{$R *.dfm}

procedure TZastForm.Timer1Timer(Sender: TObject);
begin
  Release;
  ZastForm:=nil;
end;

end.
