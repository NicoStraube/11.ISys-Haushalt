unit unitMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  unitRecord, unitStatistics;

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
    procedure buttonCalculateOneClick(Sender: TObject);
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
        // read all lines from the file & add another in the stringGrid if needed
        if (cellIndexY > stringGrid.RowCount - 1) then
          stringGrid.RowCount := stringGrid.RowCount + 1;
        ReadLn(fileToOpen, currentRow);

        // loop through each col -> 'x'
        for cellIndexX := 0 to stringGrid.ColCount do
        begin
          if (cellIndexX <= stringGrid.ColCount - 1) then
          begin
            currentPosition := Pos(';', currentRow);
            if (cellIndexX = 3) then
              stringGrid.cells[cellIndexX, cellIndexY] :=
                Copy(currentRow, 1, currentPosition - 1) + ' €'
            else
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

      // loop through all rows -> 'y'
      for cellIndexY := 1 to stringGrid.RowCount - 1 do
      begin
        // loop through all cols -> 'x'
        for cellIndexX := 0 to stringGrid.ColCount - 1 do
        begin
          // prevent saving custom calculations
          if (cellIndexX <> (stringGrid.ColCount - 1)) then
            // write each cell one after one
            Write(fileToSave, stringGrid.cells[cellIndexX,
              cellIndexY].Replace(' €', '') + ';');
        end;
        // jump to the next line
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

  formRecord.labelDebug.Font.Color := clSilver;
  formRecord.labelDebug.Caption := '-';

  formRecord.ShowModal();
end;

procedure calculateAll(stringGrid: TStringGrid; labelDebug: TLabel);
var
  cellIndexX, cellIndexY: integer;
  tmp: currency;

begin
  // check, if there are at least 2 datasets
  if (stringGrid.RowCount >= 3) then
    // loop through all rows -> 'y'
    for cellIndexY := 1 to stringGrid.RowCount do
    begin
      // get first dataset seperated to prevent 'null' calculation errors
      if (cellIndexY = 1) then
      begin
        cellIndexX := stringGrid.ColCount - 3;
        tmp := StrToCurr(stringGrid.Cells[cellIndexX, cellIndexY].Replace(' €',
          '').Replace('.', ''));
        stringGrid.cells[cellIndexX + 2, cellIndexY] := CurrToStrF(tmp, ffCurrency, 2);
      end
      // stop operation if loop iterated through all datasets
      else if (cellIndexY = stringGrid.RowCount) then
      begin
        labelDebug.Font.Color := clGreen;
        labelDebug.Caption := TimeToStr(Time()) + ' » Operation beendet.';
      end
      // get each dataset and do calculations
      else if (cellIndexY > 1) then
      begin
        cellIndexX := stringGrid.ColCount;
        tmp := (StrToCurr(stringGrid.Cells[5, cellIndexY - 1].Replace(' €',
          '').Replace('.', '')) +
          StrToCurr(stringGrid.Cells[cellIndexX - 3, cellIndexY].Replace(' €',
          '').Replace('.', '')));
        stringGrid.cells[cellIndexX - 1, cellIndexY] := CurrToStrF(tmp, ffCurrency, 2);
      end;
    end
  else
  begin
    labelDebug.Font.Color := clRed;
    labelDebug.Caption := TimeToStr(Time()) +
      ' » Summen können nicht berechnet werden - zu wenig Datensätze vorhanden. ';
  end;
end;

procedure TformMain.buttonCalculateClick(Sender: TObject);
begin
  calculateAll(stringGrid, labelDebug);
end;

procedure TformMain.buttonCalculateOneClick(Sender: TObject);
var
  index, listResult: integer;
  cellIndexX, cellIndexY: integer;
  possibleUser: string;

begin
  // check, if there is at least 1 dataset
  if (stringGrid.RowCount >= 3) then
  begin
    formStatistics.comboBoxExUsers.ItemIndex := -1;

    formStatistics.possibleUsers.Clear;
    formStatistics.comboBoxExUsers.Clear;

    // get possible users
    cellIndexX := 2;
    for cellIndexY := 1 to stringGrid.RowCount - 1 do
    begin
      if (cellIndexY <= stringGrid.RowCount) then
      begin
        possibleUser := stringGrid.Cells[cellIndexX, cellIndexY];
        listResult := formStatistics.possibleUsers.IndexOf(possibleUser);
        if (listResult = -1) then
        begin
          formStatistics.possibleUsers.Add(possibleUser);
          formStatistics.comboBoxExUsers.Add(possibleUser);
        end;
      end;
    end;

    formStatistics.editOutgoings.Caption := '';
    formStatistics.editDifference.Caption := '';

    calculateAll(stringGrid, labelDebug);
    formStatistics.ShowModal();
  end
  else
  begin
    labelDebug.Font.Color := clRed;
    labelDebug.Caption := TimeToStr(Time()) +
      ' » Statistiken können nicht geöffnet werden - zu wenig Datensätze vorhanden. ';
  end;
end;


procedure TformMain.buttonCloseClick(Sender: TObject);
begin
  Close();
end;

end.
