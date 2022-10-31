;===============================================================================
; Distributed under the MIT license.
; See the accompanying LICENSE file or go to
; http://delphidabbler.mit-license.org/1991-2016/
;
; $Rev: 68 $
; $Date: 2016-02-14 02:21:36 +0000 (Sun, 14 Feb 2016) $
;
; 8 Queens install file generation script for use with Inno Setup 5.
;===============================================================================


; Deletes "Release " from beginning of S
#define DeleteToVerStart(str S) \
  /* assumes S begins with "Release " followed by version as x.x.x */ \
  Local[0] = Copy(S, Len("Release ") + 1, 99), \
  Local[0]

; The following defines use these macros that are predefined by ISPP:
;   SourcePath - path where this script is located
;   GetStringFileInfo - gets requested version info string from an executable
;   GetFileProductVersion - gets product version info string from an executable

#define ExeFile "Queens.exe"
#define LicenseRTFFile "License.rtf"
#define LicenseFile "LICENSE"
#define ReadmeFile "README.md"
#define UserGuide "UserGuide.pdf"
#define InstUninstDir "Uninst"
#define RootPath SourcePath + "..\"
#define OutDir RootPath + "Exe"
#define SrcExePath RootPath + "Exe\"
#define SrcDocsPath RootPath + "Docs\"
#define ExeProg SrcExePath + ExeFile
#define Company "DelphiDabbler.com"
#define AppPublisher "DelphiDabbler"
#define AppName "8 Queens"
#define AppVersion DeleteToVerStart(GetFileProductVersion(ExeProg))
#define Copyright GetStringFileInfo(ExeProg, LEGAL_COPYRIGHT)
#define WebAddress "www.delphidabbler.com"
#define WebURL "http://" + WebAddress + "/"
#define AppURL WebURL + "/software/queens"


[Setup]
AppID={{0FA3F400-3CBD-473E-966B-CF27EBBBE374}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppPublisher} {#AppName} {#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#WebURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}
AppReadmeFile={app}\{#ReadmeFile}
AppCopyright={#Copyright} ({#WebAddress})
AppComments=
AppContact=
DefaultDirName={pf}\{#AppPublisher}\8Queens
DefaultGroupName={#AppName}
AllowNoIcons=false
LicenseFile={#SrcDocsPath}{#LicenseRTFFile}
Compression=lzma/ultra
SolidCompression=true
InternalCompressLevel=ultra
OutputDir={#OutDir}
OutputBaseFilename=Queens-Setup-{#AppVersion}
VersionInfoVersion={#AppVersion}
VersionInfoCompany={#Company}
VersionInfoDescription=Installer for {#AppName}
VersionInfoTextVersion={#AppVersion}
VersionInfoCopyright={#Copyright}
MinVersion=0,5.0.2195
TimeStampsInUTC=true
ShowLanguageDialog=no
UninstallFilesDir={app}\{#InstUninstDir}
UninstallDisplayIcon={app}\{#ExeFile}
PrivilegesRequired=admin
MergeDuplicateFiles=false
UserInfoPage=false

[Files]
Source: {#SrcExePath}{#ExeFile}; DestDir: {app}; Flags: uninsrestartdelete
Source: {#RootPath}{#LicenseFile}; DestDir: {app}; Flags: ignoreversion
Source: {#RootPath}{#ReadmeFile}; DestDir: {app}; Flags: ignoreversion
Source: {#SrcDocsPath}{#UserGuide}; DestDir: {app}; Flags: ignoreversion

[Icons]
Name: {group}\{#AppName}; Filename: {app}\{#ExeFile}
Name: {group}\User Guide; Filename: {app}\{#UserGuide}
Name: {group}\{cm:UninstallProgram,{#AppName}}; Filename: {uninstallexe}

[Run]
Filename: {app}\{#ExeFile}; Description: {cm:LaunchProgram,DelphiDabbler 8 Queens}; Flags: nowait postinstall skipifsilent

[Dirs]
Name: {app}\{#InstUninstDir}; Flags: uninsalwaysuninstall

[Messages]
; Brand installer
BeveledLabel={#Company}

