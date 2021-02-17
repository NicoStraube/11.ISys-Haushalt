unit unitMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls;

type

  { TformMain }

  TformMain = class(TForm)
    buttonClose: TButton;
    buttonCalculateOne: TButton;
    buttonCalculate: TButton;
    buttonRecord: TButton;
    buttonLoadFile: TButton;
    buttonSaveFile: TButton;
    openDialog: TOpenDialog;
    saveDialog: TSaveDialog;
    stringGrid: TStringGrid;
  private

  public

  end;

var
  formMain: TformMain;

implementation

{$R *.lfm}

{ TformMain }


end.

