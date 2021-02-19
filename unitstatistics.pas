unit unitStatistics;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComboEx;

type

  { TformStatistics }

  TformStatistics = class(TForm)
    buttonClose: TButton;
    comboBoxExUsers: TComboBoxEx;
    editOutgoings: TEdit;
    editDifference: TEdit;
    labelOutgoings: TLabel;
    labelBuyer: TLabel;
    labelDifference: TLabel;
    procedure buttonCloseClick(Sender: TObject);
    procedure comboBoxExUsersChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
  var
    possibleUsers: TStringList;

  end;

var
  formStatistics: TformStatistics;

implementation

uses unitMain;

{$R *.lfm}

{ TformStatistics }


procedure TformStatistics.FormCreate(Sender: TObject);
begin
  possibleUsers := TStringList.Create;
end;


function getPriceSumOfCurrentUser(user: string): currency;
var
  cellIndexX, cellIndexY: integer;
  possibleUser: string;
  tmp: currency = 0.0;
begin
  cellIndexX := 2;
  for cellIndexY := 1 to formMain.stringGrid.RowCount - 1 do
  begin
    if (cellIndexY <= formMain.stringGrid.RowCount) then
    begin
      possibleUser := formMain.stringGrid.Cells[cellIndexX, cellIndexY];
      if (possibleUser = user) then
      begin
        tmp := tmp + StrToCurr(formMain.stringGrid.Cells[cellIndexX +
          1, cellIndexY].Replace(' €', '').Replace('.', ''));
      end;
    end;
  end;

  Result := tmp;
end;

procedure TformStatistics.comboBoxExUsersChange(Sender: TObject);
var
  difference, subtract: currency;
begin
  // sum all prices based on the current user
  subtract := getPriceSumOfCurrentUser(
    comboBoxExUsers.ItemsEx.Items[comboBoxExUsers.ItemIndex].Caption);

  editOutgoings.Caption := currToStrF(subtract, ffCurrency, 2);

  difference := StrToCurr(formMain.stringGrid.Cells[formMain.stringGrid.ColCount -
    1, formMain.stringGrid.RowCount - 1].Replace(' €', '').Replace('.', '')) /
    FloatToCurr(possibleUsers.Count);

  editDifference.Caption := CurrToStrF(difference - subtract, ffCurrency, 2);
end;


procedure TformStatistics.buttonCloseClick(Sender: TObject);
begin
  Close();
end;

end.
