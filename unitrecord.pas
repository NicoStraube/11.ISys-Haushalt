unit unitRecord;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, EditBtn,
  CheckLst, ComboEx, Spin;

type

  { TformRecord }

  TformRecord = class(TForm)
    buttonClose: TButton;
    buttonSubmit: TButton;
    comboBoxExBuyer: TComboBoxEx;
    dateEdit: TDateEdit;
    editDescription: TEdit;
    editNumber: TEdit;
    floatSpinEditPrice: TFloatSpinEdit;
    labelDescription: TLabel;
    labelPrice: TLabel;
    labelBuyer: TLabel;
    labelNumber: TLabel;
    labelDate: TLabel;
    procedure comboBoxExBuyerChange(Sender: TObject);
  private

  public
  var
    currentBuyer: integer;

  end;

var
  formRecord: TformRecord;

implementation

uses unitMain;

{$R *.lfm}

{ TformRecord }

procedure TformRecord.comboBoxExBuyerChange(Sender: TObject);



begin
  currentUser := comboBoxExBuyer.ItemIndex;
end;

end.
