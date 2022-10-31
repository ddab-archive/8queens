# ------------------------------------------------------------------------------
# Distributed under the MIT license.
# See the accompanying LICENSE file or go to
# http://delphidabbler.mit-license.org/1991-2016/
#
# $Rev: 76 $
# $Date: 2016-02-14 03:22:37 +0000 (Sun, 14 Feb 2016) $
#
# Project makefile.
# ------------------------------------------------------------------------------


# Required macros
# ---------------
#
# Make will fail if any of the following macros are not defined externally to
# this makefile.
#
# DELPHIROOT
#   DELPHIROOT must address the installation directory of the required Delphi
#   compiler: Delphi XE is preferred. Compilation with other versions may
#   fail without source code changes.
#
# DELPHIDABLIB
#   DELPHIDABLIB must address the directory where the required DelphiDabbler
#   components have been installed. They must have been compiled with the same
#   version of Delphi being used to compile this project.
#
# Optional macros
# ---------------
#
# The following macros are optional. They specify the install paths of various
# programs required by this makefile.
#
# VIEDROOT
#   Install path of Version Information Editor (VIEd) used to process version
#   information (.vi) files. If not set then VIEd must be on the system path.
#
# INNOSETUP
#   Install path of Inno Setup used to create the install program. This should
#   be the Unicode version of the program. If not set then the Unicode version
#   of Inno Setup must be on the system path.
#
# ZIPROOT
#   Install path of INFO-ZIP's ZIP.exe program used to create the release zip
#   file. If not set then ZIP.exe must be on the system path.
#
# RELEASEFILENAME
#   Specifies the name, without path or extension, of the zip file used to
#   contain the 8 queens program when released. If not set then the default name
#   hard wired into this file is used.
#
# Supported targets
# -----------------
#
# make config
#   Configures the source tree ready for the build: the Bin, Exe and Release
#   directories are created.
#
# make resources
#   Compiles the resource files required to build the program. Files are placed
#   in the Bin directory, which must exist.
#
# make pascal
#   Compiles the pascal source using the required version of Delphi. Required
#   resource files must be present in the Bin directory. The executable file is
#   placed in the Exe directory.
#
# make setup
#   Compiles the setup program and places the setup file in the Exe directory.
#   The setup compiler expects to find the 8 queens executable in the Exe
#   directory.
#
# make release
#   Creates a zip file containing the required release files. The zip file is
#   placed in the Release directory.
#
# make everything
#   This is the default option used when make is run with no targets. It
#   configures the source tree, builds the 8 Queens executable and the creates
#   the release zip file.
#
# make clean
#   Deletes unwanted and temporary files and directories. Does not delete the
#   Bin, Exe or Release directories.
#
# make deepclean
#   Deletes unwanted and temporary files and directories as "make clean" and
#   then removes the Bin, Exe and Release directories created by "make config".


# Set bin output path
BIN = ..\Bin
# Set various paths

SOURCE = Source
DOCS = Docs
BUILD = Build
BIN = Bin
EXE = Exe
RELEASE = Release
!ifndef RELEASEFILENAME
RELEASEFILENAME = 8queens
!endif
OUTFILE = $(RELEASE)\$(RELEASEFILENAME).zip


# Check for required macros
!ifndef DELPHIROOT
!error DELPHIROOT environment variable required.
!endif
!ifndef DELPHIDABLIB
!error DELPHIDABLIB environment variable required.
!endif

# Define common macros that access required build tools
MAKE = "$(MAKEDIR)\Make.exe" -$(MAKEFLAGS)
DCC32 = "$(DELPHIROOT)\Bin\DCC32.exe"
RC = "$(DELPHIROOT)\Bin\RC.exe"
BRCC32 = "$(DELPHIROOT)\Bin\BRCC32.exe"
!ifdef VIEDROOT
VIED = "$(VIEDROOT)\VIEd.exe" -makerc
!else
VIED = VIEd.exe -makerc
!endif
!ifdef INNOSETUP
ISCC = "$(INNOSETUP)\ISCC.exe"
!else
ISCC = ISCC.exe
!endif
!ifdef ZIPROOT
ZIP = "$(ZIPROOT)\Zip.exe"
!else
ZIP = Zip.exe
!endif

# Implicit rules

# Delphi projects are assumed to contain required output and search path
# locations in the project options .cfg file.
.dpr.exe:
  @echo +++ Compiling Delphi Project $< +++
  @$(DCC32) $< -B -U"$(DELPHIDABLIB)"

# Resource files are compiled to the Bin directory using RC
.rc.res:
  @echo +++ Compiling Resource file $< to $(@F) +++
  @$(RC) -fo..\$(BIN)\$(@F) $<

# Temporary resource files with special extension .tmp-rcx are compiled to the
# Bin directory using BRCC32
.tmp-rcx.res:
  @echo +++ Compiling Resource file $< to $(@F) +++
  @$(BRCC32) -fo..\$(BIN)\$(@F) $<
  -@del $(<B).tmp-rcx

# Version info files are compiled by VIEd to a temporary .tmp-rcx resource file
.vi.tmp-rcx:
  @echo +++ Compiling Version Info file $< to $(@F) +++
  @$(VIED) .\$<
  -@ren $(@B).rc $(@F)

# Targets

# Default target is to configure, build everything and release
everything: config resources pascal setup release

# Configure source folders
config:
  @echo Configuring 8 Queens
  # Create build folders
  @cd ..
  @if exist $(BIN) rmdir /S /Q $(BIN)
  @if exist $(EXE) rmdir /S /Q $(EXE)
  @if exist $(RELEASE) rmdir /S /Q $(RELEASE)
  @mkdir $(BIN)
  @mkdir $(EXE)
  @mkdir $(RELEASE)
  @cd $(SOURCE)

# Compiles the resources and deletes intermediate file created by VIED
resources: VersionInfo.res Resource.res

# Builds 8 Queens pascal files and links program
pascal: Queens.exe

# Builds setup program
setup:
  @del ..\$(EXE)\Queens-Setup-*
  @$(ISCC) Install.iss

# Build release files (.zip)
release:
  @echo.
  @echo Creating Release File
  @echo ---------------------
  @cd ..
  -@if exist $(OUTFILE) del $(OUTFILE)
  @$(ZIP) -j -9 $(OUTFILE) Exe\Queens-Setup-*.exe README.md
  @cd $(SOURCE)

# Clean up unwanted files
clean:
  @cd ..
  # remove unwanted files: temps (~ or .~*), .dsk, .local, .identcache
  -@del /S *.~* 2>nul
  -@del /S ~* 2>nul
  -@del /S *.dsk 2>nul
  -@del /S *.local 2>nul
  -@del /S *.identcache 2>nul
  # remove __history folders
  -@for /F "usebackq" %i in (`dir /S /B /A:D ..\__history`) do @rmdir /S /Q %i
  @cd $(SOURCE)

# Clean up unwanted files and remove the binary build directories
deepclean: clean
  @echo +++ Removing binary build and its subdirectories +++
  # remove build directories created by config
  @cd ..
  @if exist $(BIN) rmdir /S /Q $(BIN)
  @if exist $(EXE) rmdir /S /Q $(EXE)
  @if exist $(RELEASE) rmdir /S /Q $(RELEASE)
  @cd $(SOURCE)
