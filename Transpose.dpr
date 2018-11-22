program Transpose;

uses
  Forms,
  Sysutils,
  Dialogs,
  uTranspose in 'uTranspose.pas' {MainForm},
  System.UITypes,
  uError{,
  uProgramSettings in '..\..\Basisbestanden\Default\uProgramSettings.pas'};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Try
    Try
      if ParamCount = 2 then begin
        Mode := Batch;
        MainForm.LabeledEditFileName.Text := ParamStr( 1 );
        MainForm.SaveDialog1.FileName := ParamStr( 2 );
      end;
      if ( Mode = Interactive ) then begin
        Application.Run;
      end else begin
        MainForm.GoButton.Click;
      end;
    Except
      Try WriteToLogFileFmt( 'Error in application: [%s].', [Application.ExeName] ); except end;
      MessageDlg( Format( 'Error in application: [%s].', [Application.ExeName] ), mtError, [mbOk], 0);
    end;
  Finally
  end;

end.
