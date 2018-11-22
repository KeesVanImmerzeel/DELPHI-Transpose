unit uTranspose;

interface

uses
  Windows, Forms, SysUtils, StdCtrls, Controls, Classes{, uProgramSettings},
  LargeArrays, Vcl.Dialogs, Vcl.ExtCtrls, uError, Dutils, OpWstring;

type
  TMainForm = class(TForm)
    LabeledEditFileName: TLabeledEdit;
    OpenDialog1: TOpenDialog;
    GoButton: TButton;
    SaveDialog1: TSaveDialog;
    DoubleMatrix1: TDoubleMatrix;
    procedure FormCreate(Sender: TObject);
    procedure LabeledEditFileNameClick(Sender: TObject);
    procedure GoButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation
{$R *.DFM}


procedure TMainForm.FormDestroy(Sender: TObject);
begin
FinaliseLogFile;
end;

procedure TMainForm.GoButtonClick(Sender: TObject);
Const
  WordDelims: CharSet = [' ',','];
var
  f, g: TextFile;
  i, j, m, n: Integer;
begin
  if ( Mode = Interactive ) and ( not SaveDialog1.Execute ) then
    Exit;

  Try
    Try
      if not fileExists( LabeledEditFileName.Text ) then
        Exception.CreateFmt( 'File [%s] does not exist.', [LabeledEditFileName.Text] );

      AssignFile( f, LabeledEditFileName.Text ); Reset( f );
      AssignFile( g, SaveDialog1.FileName ); Rewrite( g );
      DoubleMatrix1 := TDoubleMatrix.InitialiseFromTextFile( f, WordDelims, 0, self );

      with DoubleMatrix1 do begin
        m := GetNRows; n := GetNCols;
        for j := 1 to n do begin
          for i := 1 to m do begin
            Write( g, DoubleMatrix1[ i, j ], #9 );
          end;
          Writeln( g );
        end;
      end;
    Except
      On E: Exception do begin
        HandleError( E.Message, true );
      end;
    End;
  Finally
    {$I-} CloseFile( f ); CloseFile( g ); {$I+}
    Try DoubleMatrix1.Free; except end;
  End;

end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  InitialiseLogFile;
  Caption :=  ChangeFileExt( ExtractFileName( Application.ExeName ), '' );
  
end;

procedure TMainForm.LabeledEditFileNameClick(Sender: TObject);
begin
  with OpenDialog1 do begin
    if execute then begin
      LabeledEditFileName.Text := ExpandFileName( FileName );
    end
  end;
end;

end.
