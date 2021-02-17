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
    procedure buttonCloseClick(Sender: TObject);
    procedure buttonLoadFileClick(Sender: TObject);
    procedure buttonSaveFileClick(Sender: TObject);
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
      ShowMessage(IntToStr(stringGrid.RowCount - 1) + ' Datensätze aus Datei ' +
        openDialog.FileName + ' geladen.');
    end;
  except
    CloseFile(fileToOpen);
    ShowMessage('Es trat ein Fehler beim Einlesen der Datei aus.');
  end;
end;

procedure TformMain.buttonSaveFileClick(Sender: TObject);
var
  cellIndexX, cellIndexY: integer;

begin
  try
    if (saveDialog.Execute) then
    begin
      AssignFile(fileToSave, saveDialog.FileName);
      Rewrite(fileToSave);

      for cellIndexY := 1 to stringGrid.RowCount - 1 do
      begin
        for cellIndexX := 0 to stringGrid.ColCount - 1 do
        begin
          if (cellIndexX <> (stringGrid.ColCount - 1)) then
            Write(fileToSave, stringGrid.cells[cellIndexX, cellIndexY] + ';');
        end;
        WriteLn(fileToSave);
      end;

      CloseFile(fileToSave);
      ShowMessage(IntToStr(stringGrid.RowCount - 1) + ' Datensätze in Datei ' +
        saveDialog.FileName + ' gespeichert.');
    end;
  except
    CloseFile(fileToSave);
    ShowMessage('Es trat ein Fehler beim Speichern der Datei auf.');
  end;
end;


procedure TformMain.buttonCloseClick(Sender: TObject);
begin
  Close();
end;

end.
