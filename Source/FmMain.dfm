object QueensForm: TQueensForm
  Left = 293
  Top = 147
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 405
  ClientWidth = 363
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lblSolutions: TLabel
    Left = 8
    Top = 208
    Width = 178
    Height = 16
    AutoSize = False
    Caption = 'lblSolutions'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object bvlBoard: TBevel
    Left = 8
    Top = 8
    Width = 194
    Height = 194
  end
  object lblAutoSpeedSel: TLabel
    Left = 210
    Top = 84
    Width = 145
    Height = 15
    Alignment = taCenter
    AutoSize = False
    Caption = 'Slide show spee&d:'
    FocusControl = tbAuto
  end
  object lblAutoSpeed: TLabel
    Left = 210
    Top = 130
    Width = 145
    Height = 15
    Alignment = taCenter
    AutoSize = False
    Caption = 'lblAutoSpeed'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsItalic]
    ParentFont = False
  end
  object hlblWebsite: TPJHotLabel
    Left = 208
    Top = 208
    Width = 147
    Height = 16
    Hint = 'Visit DelphiDabbler.com website'
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'www.delphidabbler.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentShowHint = False
    ShowHint = True
    CaptionIsURL = False
    HighlightFont.Charset = DEFAULT_CHARSET
    HighlightFont.Color = clPurple
    HighlightFont.Height = -11
    HighlightFont.Name = 'MS Sans Serif'
    HighlightFont.Style = [fsBold, fsUnderline]
    HighlightURL = True
    HintStyle = hsCustom
    URL = 'http://www.delphidabbler.com'
  end
  object btnNext: TButton
    Left = 210
    Top = 8
    Width = 145
    Height = 27
    Caption = 'btnNext'
    TabOrder = 0
    OnClick = btnNextClick
  end
  object btnExit: TButton
    Left = 202
    Top = 370
    Width = 153
    Height = 27
    Caption = 'E&xit'
    TabOrder = 5
    OnClick = btnExitClick
  end
  object btnAbout: TButton
    Left = 8
    Top = 370
    Width = 153
    Height = 27
    Caption = '&About...'
    TabOrder = 4
    OnClick = btnAboutClick
  end
  object btnAuto: TButton
    Left = 210
    Top = 51
    Width = 145
    Height = 27
    Caption = 'btnAuto'
    TabOrder = 1
    OnClick = btnAutoClick
  end
  object rePrompt: TRichEdit
    Left = 8
    Top = 230
    Width = 347
    Height = 131
    TabStop = False
    BevelInner = bvLowered
    BevelKind = bkFlat
    BorderStyle = bsNone
    BorderWidth = 1
    Color = clInfoBk
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 6
  end
  object btnReset: TButton
    Left = 210
    Top = 151
    Width = 145
    Height = 27
    Caption = '&Reset'
    TabOrder = 3
    OnClick = btnResetClick
  end
  object tbAuto: TTrackBar
    Left = 210
    Top = 103
    Width = 145
    Height = 25
    Max = 4
    PageSize = 1
    Position = 2
    TabOrder = 2
    OnChange = tbAutoChange
  end
  object dlgAbout: TPJAboutBoxDlg
    Title = 'About'
    ButtonPlacing = abpRight
    ButtonHeight = 27
    VersionInfo = viMain
    UseOwnerAsParent = True
    UseOSStdFonts = True
    Left = 16
    Top = 16
  end
  object viMain: TPJVersionInfo
    Left = 48
    Top = 16
  end
  object tiAuto: TTimer
    Enabled = False
    OnTimer = tiAutoTimer
    Left = 80
    Top = 16
  end
end
