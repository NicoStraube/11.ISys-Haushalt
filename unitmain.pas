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
    procedure buttonLoadFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  var
    currentRow: string;

  public
  var
    fileToOpen, fileToSave: TextFile;


  end;

var
  formMain: TformMain;

implementation

{$R *.lfm}

{ TformMain }


procedure TformMain.FormCreate(Sender: TObject);
begin
  stringGrid.AutoSizeColumns();
end;

procedure TformMain.buttonLoadFileClick(Sender: TObject);
var
  cellIndexX, cellIndexY, currentPosition: integer;

begin
  cellIndexY := 1;

  try
    if (openDialog.Execute) then
    begin
      AssignFile(fileToOpen, openDialog.FileName);
      reset(fileToOpen);

      repeat
        if (cellIndexY > stringGrid.RowCount - 1) then
          stringGrid.RowCount := stringGrid.RowCount + 1;
        ReadLn(fileToOpen, currentRow);

        for cellIndexX := 0 to stringGrid.ColCount do
        begin
          if (cellIndexX <= stringGrid.ColCount - 1) then
          begin
            currentPosition := Pos(';', currentRow);
            stringGrid.cells[cellIndexX, cellIndexY] :=
              Copy(currentRow, 1, currentPosition - 1);
            Delete(currentRow, 1, currentPosition);
          end;

          if (cellIndexX - 1 = stringGrid.ColCount) then
            stringGrid.cells[cellIndexX - 1, cellIndexY] := currentRow;
        end;

        cellIndexY := cellIndexY + 1;
      until EOF(fileToOpen);

      CloseFile(fileToOpen);
      stringGrid.AutoSizeColumns();
      ShowMessage(IntToStr(stringGrid.RowCount - 1) + ' Datensätze geladen.');

    end;
  except
    CloseFile(fileToOpen);
    ShowMessage('Es trat ein Fehler beim Einlesen der Datei aus.');
  end;
end;

end.
