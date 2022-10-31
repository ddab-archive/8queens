{
 * Distributed under the MIT license.
 * See the accompanying LICENSE file or go to
 * http://delphidabbler.mit-license.org/1991-2016/
 *
 * $Rev: 66 $
 * $Date: 2016-02-14 02:15:25 +0000 (Sun, 14 Feb 2016) $
 *
 * Project file.
}


program Queens;



uses
  Forms,
  FmMain in 'FmMain.pas' {QueensForm},
  UCalc in 'UCalc.pas',
  UPlatform in 'UPlatform.pas',
  UChessBoardCmp in 'UChessBoardCmp.pas';

{$RESOURCE VersionInfo.res}   // Contains version information
{$RESOURCE Resource.res}      // All other resources including icon

begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  Application.MainFormOnTaskBar := True;
  Application.ModalPopupMode := pmAuto;
  Application.Title := '8 Queens Problem Solver';
  Application.CreateForm(TQueensForm, QueensForm);
  Application.Run;
end.

