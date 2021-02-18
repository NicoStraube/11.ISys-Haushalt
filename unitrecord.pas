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
    labelDebug: TLabel;
    labelDescription: TLabel;
    labelPrice: TLabel;
    labelBuyer: TLabel;
    labelNumber: TLabel;
    labelDate: TLabel;
    procedure buttonCloseClick(Sender: TObject);
    procedure buttonSubmitClick(Sender: TObject);
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
  currentBuyer := comboBoxExBuyer.ItemIndex;
end;


procedure TformRecord.buttonSubmitClick(Sender: TObject);
var
  index: integer;
  dataArray: array [0..4] of string;
  // [0] - number
  // [1] - date
  // [2] - user
  // [3] - price
  // [4] - description

begin
  dataArray[0] := editNumber.Caption;
  dataArray[1] := DateToStr(dateEdit.Date);

  case currentBuyer of
    0: dataArray[2] := 'Anika';
    1: dataArray[2] := 'Florian';
    2: dataArray[2] := 'Julia';
    3: dataArray[2] := 'Sten';
  end;

  dataArray[3] := floatSpinEditPrice.Caption;
  dataArray[4] := editDescription.Caption;

  if (currentBuyer <> -1) then
  begin
    if (StrToFloat(dataArray[3]) <> 0) then
    begin
      formMain.stringGrid.RowCount := formMain.stringGrid.RowCount + 1;

      for index := 0 to 4 do
        formMain.stringGrid.cells[index, StrToInt(dataArray[0])] := dataArray[index];

      editNumber.Caption := IntToStr(formMain.stringGrid.RowCount);
      formMain.stringGrid.AutoSizeColumns();
    end
    else
    begin
      labelDebug.Font.Color := clRed;
      labelDebug.Caption := TimeToStr(Time()) +
        ' » Ungültiger Kaufbetrag. {> 0}';
    end;
  end
  else
  begin
    labelDebug.Font.Color := clRed;
    labelDebug.Caption := TimeToStr(Time()) + ' » Ungültiger Benutzer.';
  end;


end;


procedure TformRecord.buttonCloseClick(Sender: TObject);
begin
  Close();
end;

end.
