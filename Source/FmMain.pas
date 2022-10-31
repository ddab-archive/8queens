{
 * Distributed under the MIT license.
 * See the accompanying LICENSE file or go to
 * http://delphidabbler.mit-license.org/1991-2016/
 *
 * $Rev: 66 $
 * $Date: 2016-02-14 02:15:25 +0000 (Sun, 14 Feb 2016) $
 *
 * 8 Queens application's main form.
}


unit FmMain;


interface


uses
  // Delphi
  ExtCtrls, ComCtrls, StdCtrls, Controls, Classes, Forms,
  // DelphiDabbler library
  PJVersionInfo, PJAbout, PJHotLabel,
  // Project
  UCalc, UChessBoardCmp;

type

  ///  <summary>Application's main form. Handles main window UI and interacts
  ///  with problem solving engine, displaying results.</summary>
  TQueensForm = class(TForm)
    btnAbout: TButton;
    btnAuto: TButton;
    btnExit: TButton;
    btnNext: TButton;
    btnReset: TButton;
    bvlBoard: TBevel;
    dlgAbout: TPJAboutBoxDlg;
    hlblWebsite: TPJHotLabel;
    lblAutoSpeed: TLabel;
    lblAutoSpeedSel: TLabel;
    lblSolutions: TLabel;
    rePrompt: TRichEdit;
    tbAuto: TTrackBar;
    tiAuto: TTimer;
    viMain: TPJVersionInfo;
    ///  <summary>Responds to About button click. Displays About box.</summary>
    procedure btnAboutClick(Sender: TObject);
    ///  <summary>Responds to Slideshow button click. Toggles slideshow on and
    ///  off.</summary>
    procedure btnAutoClick(Sender: TObject);
    ///  <summary>Responds to Exit button click. Closes program.</summary>
    procedure btnExitClick(Sender: TObject);
    ///  <summary>Responds to Next Solution button click. Displays next solution
    ///  or "finished" message.</summary>
    procedure btnNextClick(Sender: TObject);
    ///  <summary>Responds to Reset button click. Re-initialize program to
    ///  start-up state.</summary>
    procedure btnResetClick(Sender: TObject);
    ///  <summary>Initialises form's components and creates solution engine
    ///  object.</summary>
    procedure FormCreate(Sender: TObject);
    ///  <summary>Tears down solution engone object.</summary>
    procedure FormDestroy(Sender: TObject);
    ///  <summary>Updates slide show speed in reponse to change in associated
    ///  track bar.</summary>
    procedure tbAutoChange(Sender: TObject);
    ///  <summary>Handles slide show timer events by getting next solution from
    ///  solution engine.</summary>
    procedure tiAutoTimer(Sender: TObject);
  private
    ///  <summary>Component used to display chessboard and contents.</summary>
    fChessBoardCmp: TChessBoardCmp;
    ///  <summary>Problem solving engine.</summary>
    fEngine: TEngine;
    ///  <summary>Code giving current mode or state of program: waiting to start
    ///  (reset), manual mode, auto (slideshow) mode or finished (all solutions
    ///  displayed)</summary>
    fMode: Integer;
    ///  <summary>Gets next solution and displays it.</summary>
    procedure NextSolution;
    ///  <summary>Stops automatic generation of solutions ("slide show").
    ///  </summary>
    procedure AutoStop;
    ///  <summary>Starts automatic generation of solutions ("slide show").
    ///  </summary>
    procedure AutoStart;
    ///  <summary>Initialises display and solution engine.</summary>
    procedure Initialize;
    ///  <summary>Extracts rich text message from resource with given ID and
    ///  loads it into rich edit control.</summary>
    procedure LoadMessage(const ID: Integer);
    ///  <summary>Sets diaplay mode to given value and updates display and
    ///  solution engine accordingly.</summary>
    procedure SetMode(Mode: Integer);
    ///  <summary>Updates speed of "slide shows" and displays new speed.
    ///  </summary>
    procedure UpdateAutoCalcSpeed;
    ///  <summary>Updates chessboard to display current solution state.
    ///  </summary>
    procedure UpdateBoard;
    ///  <summary>Handles chessboard control's OnMouseDown event to display
    ///  influence lines of any square under mouse cursor.</summary>
    procedure BoardMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    ///  <summary>Handles chessboard control's OnMouseUp event to switch off
    ///  display of any influence lines.</summary>
    procedure BoardMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  end;

var
  QueensForm: TQueensForm;


implementation


uses
  // Delphi
  SysUtils, Windows,
  // Project
  UPlatform;

{$R *.DFM}

const
  // Programs modes (all used as IDs for help RTF messages displayed for each
  // mode)
  cModeReset    = 1;  // waiting to start finding solutions
  cModeManual   = 2;  // manual mode: user triggers finding solutions
  cModeAuto     = 3;  // auto mode: slide show triggers finding solutions
  cModeFinished = 4;  // finished: all solutions found

  // Map of slide show speed track bar's values onto description of speed and
  // time interval between display of solutions
  cAutoSpeeds: array[0..4] of record
    Desc: string;     // description of selected speed
    Delay: Integer;   // time interval for slide show timer
  end =
  (
    (Desc: 'Very Slow'; Delay: 2400;),
    (Desc: 'Slow';      Delay: 1800;),
    (Desc: 'Medium';    Delay: 1000;),
    (Desc: 'Fast';      Delay: 500;),
    (Desc: 'Very Fast'; Delay: 200;)
  );

resourcestring
  // Button captions
  sAutoStart = 'Start &Slide Show';
  sAutoStop = 'Stop &Slide Show';
  sManualStart = '&First Solution';
  sManualNext = '&Next Solution';
  // Solution label captions
  sSolutionStart = 'Ready';
  sSolutionStop = 'Finished';
  sSolutionCounter = 'Solution #%d';


{ TQueensForm }

procedure TQueensForm.AutoStart;
begin
  NextSolution;
  tiAuto.Enabled := True;
  btnAuto.Caption := sAutoStop;
end;

procedure TQueensForm.AutoStop;
begin
  tiAuto.Enabled := False;
  btnAuto.Caption := sAutoStart;
end;

procedure TQueensForm.BoardMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not fChessBoardCmp.IsSquareAt(X, Y) then
    Exit;
  fChessBoardCmp.ShowInfluences(fChessBoardCmp.GetSquareAt(X, Y));
end;

procedure TQueensForm.BoardMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fChessBoardCmp.HideInfluences;
end;

procedure TQueensForm.btnAboutClick(Sender: TObject);
begin
  dlgAbout.Execute;
end;

procedure TQueensForm.btnAutoClick(Sender: TObject);
begin
  if fMode = cModeFinished then
    Exit;
  if fMode <> cModeAuto then
    SetMode(cModeAuto)    // start slideshow
  else
    SetMode(cModeManual); // stop slideshow
end;

procedure TQueensForm.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TQueensForm.btnNextClick(Sender: TObject);
begin
  if fMode = cModeFinished then
    Exit;
  if fMode <> cModeAuto then
    SetMode(cModeManual);
  NextSolution;
end;

procedure TQueensForm.btnResetClick(Sender: TObject);
begin
  Initialize;
end;

procedure TQueensForm.FormCreate(Sender: TObject);
begin
  // Make use OSs default font
  SetDefaultFormFont(Self);
  // adjust hot label to use system font for highlighting
  hlblWebsite.HighlightFont.Name := hlblWebsite.Font.Name;
  hlblWebsite.HighlightFont.Size := hlblWebsite.Font.Size;
  // ensure hot label large enough and realign right
  hlblWebsite.AutoSize := True;
  hlblWebsite.Left := btnReset.Left + btnReset.Width - hlblWebsite.Width;

  // Window caption is application title
  Caption := Application.Title;

  // Create chessboard display
  fChessBoardCmp := TChessBoardCmp.Create(Self);
  fChessBoardCmp.Parent := Self;
  fChessBoardCmp.SquareSize := 24;
  fChessBoardCmp.Top := bvlBoard.Top + 1;
  fChessBoardCmp.Left := bvlBoard.Left + 1;
  fChessBoardCmp.OnMouseDown := BoardMouseDown;
  fChessBoardCmp.OnMouseUp := BoardMouseUp;

  // Create calculation engine
  fEngine := TEngine.Create;

  // Initialize engine and display
  Initialize;

  // Set default slide show speed
  UpdateAutoCalcSpeed;
end;

procedure TQueensForm.FormDestroy(Sender: TObject);
begin
  // Free objects
  fEngine.Free;
end;

procedure TQueensForm.Initialize;
begin
  SetMode(cModeReset);
end;

procedure TQueensForm.LoadMessage(const ID: Integer);
var
  Stm: TResourceStream; // stream onto required resource
begin
  // Help messages are stored in RCDATA resource with a numeric ID
  Stm := TResourceStream.CreateFromID(HInstance, ID, RT_RCDATA);
  try
    rePrompt.Lines.LoadFromStream(Stm);
  finally
    Stm.Free;
  end;
end;

procedure TQueensForm.NextSolution;
begin
  // Try to generate next solution
  if fEngine.NextSolution then
  begin
    // Solution found: update display
    lblSolutions.Caption := Format(sSolutionCounter, [fEngine.SolutionCount]);
    UpdateBoard;
  end
  else
    // No solution found: we have finished
    SetMode(cModeFinished);
end;

procedure TQueensForm.SetMode(Mode: Integer);
begin
  // Only proceed if mode has changed
  if fMode <> Mode then
  begin
    // Record new mode
    fMode := Mode;
    // Load help message with same ID as mode
    LoadMessage(Mode);
    // Update display according to mode
    case Mode of
      cModeReset:
      begin
        // Reset the program
        // halt any slide show
        AutoStop;
        // update buttons
        btnNext.Caption := sManualStart;
        btnNext.Enabled := True;
        btnAuto.Enabled := True;
        btnReset.Enabled := False;
        // update solution label to indicate ready to start
        lblSolutions.Caption := sSolutionStart;
        // reset solution engine and redraw (blank) chessboard
        fEngine.Initialize;
        UpdateBoard;
      end;
      cModeManual:
      begin
        // Change to manual mode
        // halt any slide show
        AutoStop;
        // update buttons
        btnNext.Caption := sManualNext;
        btnReset.Enabled := True;
      end;
      cModeAuto:
      begin
        // Change to auto (slide show) mode
        // update buttons
        btnNext.Caption := sManualNext;
        btnReset.Enabled := True;
        // start the slide show
        AutoStart;
      end;
      cModeFinished:
      begin
        // Change to finished mode (all solutions found)
        // halt any slide show
        AutoStop;
        // update buttons
        btnNext.Enabled := False;
        btnAuto.Enabled := False;
        btnReset.Enabled := True;
        // update solution label to indicate finished
        lblSolutions.Caption := sSolutionStop;
        // redraw (blank) chess board
        UpdateBoard;
      end;
    end;
  end;
end;

procedure TQueensForm.tbAutoChange(Sender: TObject);
begin
  UpdateAutoCalcSpeed;
end;

procedure TQueensForm.tiAutoTimer(Sender: TObject);
begin
  NextSolution; // this method will switch modes if no more solutions
end;

procedure TQueensForm.UpdateAutoCalcSpeed;
begin
  lblAutoSpeed.Caption := cAutoSpeeds[tbAuto.Position].Desc;
  tiAuto.Interval := cAutoSpeeds[tbAuto.Position].Delay;
end;

procedure TQueensForm.UpdateBoard;
begin
  fChessBoardCmp.UpdateBoard(fEngine.EngineState);
end;

end.

