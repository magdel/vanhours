unit newprj;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TNewProjForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    cbCalcKV: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
                                 {
var
  NewProjForm: TNewProjForm;      }

implementation

{$R *.DFM}

end.
