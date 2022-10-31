{
 * Distributed under the MIT license.
 * See the accompanying LICENSE file or go to
 * http://delphidabbler.mit-license.org/1991-2016/
 *
 * $Rev: 66 $
 * $Date: 2016-02-14 02:15:25 +0000 (Sun, 14 Feb 2016) $
 *
 * Custom component that displays chess board and its contents.
}


unit UChessBoardCmp;


interface


uses
  // Delphi
  Classes, Controls, Windows, Graphics,
  // Project
  UCalc;

type
  ///  <summary>Range of permitted sizes of chessboard squares.</summary>
  TSquareSize = 20..36;

type
  ///  <summary>Control that displays chessboard, queens and lines of queens
  ///  influence.</summary>
  TChessBoardCmp = class(TCustomControl)
  strict private
    ///  <summary>Records state of solution engine.</summary>
    fEngineState: TEngineState;
    ///  <summary>Bitmap storing image of queen.</summary>
    fQueenBmp: TBitmap;
    ///  <summary>Flag indicating if lines showing influences of square recorded
    ///  in fInfluencesSquare are to be displayed.</summary>
    fShowInfluences: Boolean;
    ///  <summary>Square for which influence lines are to be displayed.
    ///  </summary>
    ///  <remarks>Value is undefined if fShowInfluences is False.</remarks>
    fInfluencesSquare: TSquare;
    ///  <summary>Value of SquareSize property.</summary>
    fSquareSize: TSquareSize;
    ///  <summary>Returns coordinates of chessboard square under mouse
    ///  cursor at client coordinates (X,Y).</summary>
    function SquareCoordsAt(const X, Y: Integer): TPoint;
    ///  <summary>Paints chessboard squares on control's canvas.</summary>
    procedure PaintBoard;
    ///  <summary>Paints queens onto control's canvas.</summary>
    procedure PaintQueens;
    ///  <summary>Paints lines of influence of square stored in
    ///  fInfluencesSquare.</summary>
    ///  <remarks>Must not be called if fShowInfluences is False.</remarks>
    procedure PaintInfluences;
    ///  <summary>Write accessor for SquareSize property.</summary>
    ///  <remarks>Redraws display if value changed.</remarks>
    procedure SetSquareSize(const Value: TSquareSize);
    ///  <summary>Gets size of one side of the chessboard in pixels.</summary>
    function BoardSize: Integer;
  protected
    ///  <summary>Paints control onto its canvas.</summary>
    procedure Paint; override;
  public
    ///  <summary>Constructs and initialises control.</summary>
    constructor Create(AOwner: TComponent); override;
    ///  <summary>Tears down control and tidies up.</summary>
    destructor Destroy; override;
    ///  <summary>Sets bounds of control, ignoring AWidth and AHeight and
    ///  preserving board size.</summary>
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    ///  <summary>Updates display to reflect given solution engine state.
    ///  </summary>
    procedure UpdateBoard(const EngineState: TEngineState);
    ///  <summary>Displays influence lines for given square.</summary>
    procedure ShowInfluences(const Square: TSquare);
    ///  <summary>Hides any displayed influence lines.</summary>
    procedure HideInfluences;
    ///  <summary>Returns chessboard square under mouse cursor at client
    ///  coordinates (X,Y).</summary>
    ///  <remarks>Requires that there is a square under the mouse.</remarks>
    function GetSquareAt(const X, Y: Integer): TSquare;
    ///  <summary>Checks if there is a chessboard square under the mouse.
    ///  </summary>
    function IsSquareAt(const X, Y: Integer): Boolean;
  published
    ///  <summary>OnMouseDown event made public.</summary>
    property OnMouseDown;
    ///  <summary>OnMouseUp event made public.</summary>
    property OnMouseUp;
    ///  <summary>Size of a chessboard square in pixels.</summary>
    ///  <remarks>Setting this property changes the size of the control.
    ///  </remarks>
    property SquareSize: TSquareSize read fSquareSize write SetSquareSize
      default 22;
  end;

implementation


uses
  // Delphi
  Types;


{ TChessBoardCmp }

function TChessBoardCmp.BoardSize: Integer;
begin
  Result := (High(TBoardCoord) - Low(TBoardCoord) + 1) * fSquareSize;
end;

constructor TChessBoardCmp.Create(AOwner: TComponent);
begin
  inherited;
  fQueenBmp := TBitmap.Create;
  fQueenBmp.Handle := LoadBitmap(HInstance, 'QUEEN');
  fSquareSize := 22;
  Width := BoardSize;
  Height := BoardSize;
  DoubleBuffered := True;
end;

destructor TChessBoardCmp.Destroy;
begin
  fQueenBmp.Free;
  inherited;
end;

function TChessBoardCmp.GetSquareAt(const X, Y: Integer): TSquare;
var
  Coords: TPoint; // coordinates of square under mouse cursor
begin
  Assert(IsSquareAt(X, Y));
  Coords := SquareCoordsAt(X, Y);
  Result := TSquare.Create(Coords.X, Coords.Y);
end;

procedure TChessBoardCmp.HideInfluences;
begin
  if fShowInfluences then
  begin
    fShowInfluences := False;
    Invalidate;
  end;
end;

function TChessBoardCmp.IsSquareAt(const X, Y: Integer): Boolean;
var
  Coords: TPoint; // coordinates of square under mouse cursor
begin
  Coords := SquareCoordsAt(X, Y);
  Result := (Coords.X in [Low(TColCoord)..High(TColCoord)])
    and (Coords.Y in [Low(TRowCoord)..High(TRowCoord)]);
end;

procedure TChessBoardCmp.Paint;
begin
  inherited;
  PaintBoard;
  PaintQueens;
  if fShowInfluences then
    PaintInfluences;
end;

procedure TChessBoardCmp.PaintBoard;
var
  TopLeft: TPoint;  // coordinates of top left of square being drawn
  Col: TColCoord;   // loops thru each column of chessboard
  Row: TRowCoord;   // loops thru each row of chessboard
begin
  // Draw grid
  Canvas.Brush.Style := bsSolid;
  Canvas.Pen.Style := psClear;
  for Col := Low(TColCoord) to High(TColCoord) do
  begin
    for Row := Low(TRowCoord) to High(TRowCoord) do
    begin
      if Odd(Col) = Odd(Row) then
        Canvas.Brush.Color := clBlack
      else
        Canvas.Brush.Color := clWhite;
      TopLeft := Point(SquareSize * (Col - 1), SquareSize * (Row - 1));
      Canvas.Rectangle(Bounds(TopLeft.X, TopLeft.Y, SquareSize, SquareSize));
    end;
  end;
end;

procedure TChessBoardCmp.PaintInfluences;
var
  Square: TInfluencedSquare;  // each influenced square
  TopLeft: TPoint;            // coordinate of top left corner of each square
begin
  Canvas.Brush.Style := bsClear;
  Canvas.Pen.Color := clRed;
  Canvas.Pen.Style := psDot;
  for Square in fEngineState.InfluencedSquares(
    fInfluencesSquare.Col, fInfluencesSquare.Row
  ) do
  begin
    TopLeft := Point(
      SquareSize * (Square.Square.Col - 1), SquareSize * (Square.Square.Row - 1)
    );
    if siColumn in Square.Influences then
    begin
      Canvas.MoveTo(TopLeft.X + SquareSize div 2, TopLeft.Y);
      Canvas.LineTo(TopLeft.X + SquareSize div 2, TopLeft.Y + SquareSize);
    end;
    if siRow in Square.Influences then
    begin
      Canvas.MoveTo(TopLeft.X, TopLeft.Y + SquareSize div 2);
      Canvas.LineTo(TopLeft.X + SquareSize, TopLeft.Y + SquareSize div 2);
    end;
    if siUpDiag in Square.Influences then
    begin
      Canvas.MoveTo(TopLeft.X + SquareSize, TopLeft.Y);
      Canvas.LineTo(TopLeft.X, TopLeft.Y + SquareSize);
    end;
    if siDownDiag in Square.Influences then
    begin
      Canvas.MoveTo(TopLeft.X + SquareSize, TopLeft.Y + SquareSize);
      Canvas.LineTo(TopLeft.X, TopLeft.Y);
    end;
  end;
end;

procedure TChessBoardCmp.PaintQueens;
var
  QueenOffset: TPoint;  // offset of queen image in a square
  QueenRect: TRect;     // bounding rectangle of queen bitmap
  Square: TSquare;      // each queen square on board
  TopLeft: TPoint;      // top left corner of each queen square
begin
  QueenOffset := Point(
    (SquareSize - fQueenBmp.Width) div 2,
    (SquareSize - fQueenBmp.Height) div 2
  );
  QueenRect := Rect(0, 0, fQueenBmp.Width, fQueenBmp.Height);
  Canvas.Brush.Style := bsClear;
  for Square in fEngineState.Queens do
  begin
    TopLeft := Point(
      SquareSize * (Square.Col - 1),
      SquareSize * (Square.Row - 1)
    );
    Canvas.BrushCopy(
      Bounds(
        TopLeft.X + QueenOffset.X, TopLeft.Y + QueenOffset.Y,
        fQueenBmp.Width, fQueenBmp.Height
      ),
      fQueenBmp,
      QueenRect,
      clSilver  // makes silver background of queen bmp transparent
    );
  end;
end;

procedure TChessBoardCmp.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  // ignore AWidth and AHeight: size of control is determined by size of a
  // chessboard square and can't be changed any other way
  inherited SetBounds(ALeft, ATop, BoardSize, BoardSize);
end;

procedure TChessBoardCmp.SetSquareSize(const Value: TSquareSize);
begin
  if fSquareSize = Value then
    Exit;
  fSquareSize := Value;
  Invalidate;
end;

procedure TChessBoardCmp.ShowInfluences(const Square: TSquare);
begin
  fInfluencesSquare := Square;
  fShowInfluences := True;
  Invalidate;
end;

function TChessBoardCmp.SquareCoordsAt(const X, Y: Integer): TPoint;
begin
  Result.X := X div SquareSize + Low(TColCoord);
  Result.Y := Y div SquareSize + Low(TRowCoord);
end;

procedure TChessBoardCmp.UpdateBoard(const EngineState: TEngineState);
begin
  fEngineState := EngineState;
  Invalidate;
end;

end.

