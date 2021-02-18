program haushalt;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, unitMain, unitRecord, unitStatistics
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TformMain, formMain);
  Application.CreateForm(TformRecord, formRecord);
  Application.CreateForm(TformStatistics, formStatistics);
  Application.Run;
end.

