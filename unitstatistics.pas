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
    currentUser: integer;

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


procedure TformStatistics.comboBoxExUsersChange(Sender: TObject);
begin

end;


procedure TformStatistics.buttonCloseClick(Sender: TObject);
begin
  Close();
end;

end.
