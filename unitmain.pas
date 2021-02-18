unit unitMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls, unitRecord;

type

  { TformMain }

  TformMain = class(TForm)
    buttonClose: TButton;
    buttonCalculateOne: TButton;
    buttonCalculate: TButton;
    buttonRecord: TButton;
    buttonLoadFile: TButton;
    buttonSaveFile: TButton;
    labelDebug: TLabel;
    openDialog: TOpenDialog;
    saveDialog: TSaveDialog;
    stringGrid: TStringGrid;
    procedure buttonCalculateClick(Sender: TObject);
    procedure buttonCloseClick(Sender: TObject);
    procedure buttonLoadFileClick(Sender: TObject);
    procedure buttonRecordClick(Sender: TObject);
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

      labelDebug.Font.Color := clGreen;
      labelDebug.Caption := TimeToStr(Time()) + ' » ' +
        IntToStr(stringGrid.RowCount - 1) + ' Datensätze aus Datei ' +
        openDialog.FileName + ' geladen.';

    end;
  except
    CloseFile(fileToOpen);
    labelDebug.Font.Color := clRed;
    labelDebug.Caption := TimeToStr(Time()) +
      ' » Es trat ein Fehler beim Einlesen der Datei auf.';
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
      labelDebug.Font.Color := clGreen;
      labelDebug.Caption := TimeToStr(Time()) + ' » ' +
        IntToStr(stringGrid.RowCount - 1) + ' Datensätze in Datei ' +
        saveDialog.FileName + ' gespeichert.';
    end;
  except
    CloseFile(fileToSave);
    labelDebug.Font.Color := clRed;
    labelDebug.Caption := TimeToStr(Time()) +
      ' » Es trat ein Fehler beim Speichern der Datei auf.';
  end;
end;


procedure TformMain.buttonRecordClick(Sender: TObject);
begin
  formRecord.editNumber.Caption := IntToStr(stringGrid.RowCount);
  formRecord.dateEdit.Caption := dateToStr(Date());
  formRecord.comboBoxExBuyer.ItemIndex := -1;
  formRecord.currentBuyer := -1;
  formRecord.floatSpinEditPrice.Caption := IntToStr(0);
  formRecord.editDescription.Caption := '';

  formRecord.ShowModal;
end;


procedure TformMain.buttonCalculateClick(Sender: TObject);
var
  cellIndexX, cellIndexY: integer;
  tmp: currency;

begin
  if (stringGrid.RowCount >= 3) then
    for cellIndexY := 1 to stringGrid.RowCount do
    begin
      if (cellIndexY = 1) then
      begin
        cellIndexX := stringGrid.ColCount - 3;
        tmp := StrToCurr(stringGrid.Cells[cellIndexX, cellIndexY]);
        stringGrid.cells[cellIndexX + 2, cellIndexY] := CurrToStrF(tmp, ffCurrency, 2);
      end
      else if (cellIndexY = stringGrid.RowCount) then
      begin
        labelDebug.Font.Color := clGreen;
        labelDebug.Caption := TimeToStr(Time()) + ' » Operation beendet.';
      end
      else if (cellIndexY > 1) then
      begin
        cellIndexX := stringGrid.ColCount;
        tmp := (StrToCurr(stringGrid.Cells[5, cellIndexY - 1].Replace(' €', '')) +
          StrToCurr(stringGrid.Cells[cellIndexX - 3, cellIndexY]));
        stringGrid.cells[cellIndexX - 1, cellIndexY] := CurrToStrF(tmp, ffCurrency, 2);
      end;
    end
  else
  begin
    labelDebug.Font.Color := clRed;
    labelDebug.Caption := TimeToStr(Time()) +
      ' » Summen können nicht berechnet werden - zu wenig Datensätze. ';
  end;
end;


procedure TformMain.buttonCloseClick(Sender: TObject);
begin
  Close();
end;

end.
