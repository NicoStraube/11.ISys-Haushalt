unit unitStatistics;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComboEx;

type

  { TformStatistics }

  TformStatistics = class(TForm)
    comboBoxExUsers: TComboBoxEx;
    editOutgoings: TEdit;
    editDifference: TEdit;
    labelDebug: TLabel;
    labelOutgoings: TLabel;
    labelBuyer: TLabel;
    labelDifference: TLabel;
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

end.
