{
 * Distributed under the MIT license.
 * See the accompanying LICENSE file or go to
 * http://delphidabbler.mit-license.org/1991-2016/
 *
 * $Rev: 66 $
 * $Date: 2016-02-14 02:15:25 +0000 (Sun, 14 Feb 2016) $
 *
 * Performs calculations required to solve the 8 queens problem and to report
 * results.
}


unit UCalc;


interface


type
  ///  <summary>Range of co-ordinate values of chess board squares.</summary>
  TBoardCoord = 1 .. 8;

type
  ///  <summary>Range of co-ordinate values of chess board columns.</summary>
  TColCoord = type TBoardCoord;

type
  ///  <summary>Range of co-ordinate values of chess board rows.</summary>
  TRowCoord = type TBoardCoord;

type
  ///  <summary>Ranges of indexes of chess board diagonals.</summary>
  TDiagonal = -(High(TBoardCoord) - 1) .. +(High(TBoardCoord) - 1);

type
  ///  <summary>Provides information about a chessboard square.</summary>
  TSquare = record
  strict private
    var
      ///  <summary>Value of Col property.</summary>
      fCol: TColCoord;
      ///  <summary>Value of Row property.</summary>
      fRow: TRowCoord;
  public
    ///  <summary>Constructs an initialised record representing the square at
    ///  the given column and row.</summary>
    constructor Create(ACol: TColCoord; ARow: TRowCoord);
    ///  <summary>Column containing square on chessboard.</summary>
    property Col: TColCoord read fCol;
    ///  <summary>Row containing square on chessboard.</summary>
    property Row: TRowCoord read fRow;
    ///  <summary>Up diagonal containing square on chessboard.</summary>
    function UpDiagonal: TDiagonal;
    ///  <summary>Down diagonal containing square on chessboard.</summary>
    function DownDiagonal: TDiagonal;
  end;

type
  ///  <summary>Records which rows and diagonals are occupied by queens.
  ///  </summary>
  ///  <remarks>Requires that only one queen will ever occupy the same row or
  ///  diagonal.</remarks>
  TOccupancy = record
  strict private
    var
      ///  <summary>Array of flags recording occupied rows.</summary>
      fRows: array[TRowCoord] of Boolean;
      ///  <summary>Array of flags recording occupied up diagonals.</summary>
      fUpDiags: array[TDiagonal] of Boolean;
      ///  <summary>Array of flags recording occupied down diagonals.</summary>
      fDownDiags: array[TDiagonal] of Boolean;
    ///  <summary>Sets or clears occupancy flags for the row and diagonals of
    ///  given square to value of given flag.</summary>
    procedure SetOccupancy(const Square: TSquare; Flag: Boolean); inline;
  public
    ///  <summary>Clears all row and diagonal occupancy flags.</summary>
    ///  <remarks>Chess board must be empty after Clear is called.</remarks>
    procedure Clear;
    ///  <summary>Checks if a queen can occupy given chessboard square.
    ///  </summary>
    ///  <remarks>For this to happen its row and both its diagonals must be
    ///  unoccupied.</remarks>
    function CanOccupy(const Square: TSquare): Boolean;
    ///  <summary>Marks given square's rows and diagonals as occupied.</summary>
    procedure Occupy(const Square: TSquare);
    ///  <summary>Marks given square's rows and diagonals as unoccupied.
    ///  </summary>
    procedure Vacate(const Square: TSquare);
  end;

type
  ///  <summary>Records location on chessboard, if any, of a queen.</summary>
  TQueen = record
  strict private
    var
      ///  <summary>Value of IsOnBoard property.</summary>
      fIsOnBoard: Boolean;
      ///  <summary>Value of Square property.</summary>
      fSquare: TSquare;
    ///  <summary>Read accessor for Square property.</summary>
    ///  <remarks>Enforces that queen is on chessboard.</remarks>
    function GetSquare: TSquare;
  public
    ///  <summary>Indicates if the queen has been placed on the chessboard.
    ///  </summary>
    property IsOnBoard: Boolean read fIsOnBoard;
    ///  <summary>Chessboard square occupied by queen.</summary>
    ///  <remarks>Must not be read if IsOnBoard is False.</remarks>
    property Square: TSquare read GetSquare;
    ///  <summary>Removes queen from chessboard.</summary>
    ///  <remarks>Must only be called if queen is on the board.</remarks>
    procedure Remove;
    ///  <summary>Places queen on the given chessboard square.</summary>
    ///  <remarks>Must only be called if queen in not on the board.</remarks>
    procedure Place(const Square: TSquare);
    ///  <summary>Ensures that queen is removed from board.</summary>
    ///  <remarks>Can be called regardless of whether queen is on the board
    ///  already.</remarks>
    procedure Clear;
  end;

type
  ///  <summary>Records state of chessboard.</summary>
  TChessBoard = record
  strict private
    var
      ///  <summary>Records state of queens that can be placed on the columns of
      ///  the chessboard.</summary>
      ///  <remarks>One queen is associated with each chessboard column and is
      ///  either on one of its rows or off the board.</remarks>
      fQueens: array[TColCoord] of TQueen;
      ///  <summary>Records which rows and diagonals of the chessboard are
      ///  occupied by a queen.</summary>
      ///  <remarks>A row or diagonal is "occupied" a queen is placed on a
      ///  square on the row or diagonal.</remarks>
      fOccupancy: TOccupancy;
  public
    const
      ///  <summary>Coordinate of first column of chessboard.</summary>
      FirstColumn = Low(TColCoord);
      ///  <summary>Coordinate of last column of chessboard.</summary>
      LastColumn = High(TColCoord);
      ///  <summary>Coordinate of first row of chessboard.</summary>
      FirstRow = Low(TRowCoord);
      ///  <summary>Coordinate of last row of chessboard.</summary>
      LastRow = High(TRowCoord);
      ///  <summary>Total number of squares on chessboard.</summary>
      SquareCount = (High(TColCoord) - Low(TColCoord) + 1)
        * (High(TRowCoord) - Low(TRowCoord) + 1);
  public
    ///  <summary>Clears all queens from chessboard.</summary>
    procedure Clear;
    ///  <summary>Checks if queen associated with a chessboard column is placed
    ///  on the board.</summary>
    function IsQueenOnBoard(const Col: TColCoord): Boolean;
    ///  <summary>Removes the queen from the given chessboard column.</summary>
    procedure RemoveQueen(const Col: TColCoord);
    ///  <summary>Places a queen on the given chessboard square.</summary>
    procedure PlaceQueen(const Square: TSquare);
    ///  <summary>Checks if the square at coordinates (Col, Row) contains a
    ///  queen.</summary>
    function ContainsQueen(Col: TColCoord; Row: TRowCoord): Boolean;
    ///  <summary>Gets the square containing the queen in the given column.
    ///  </summary>
    ///  <remarks>There must be a queen on the given column.</remarks>
    function GetQueenSquare(Col: TColCoord): TSquare;
    ///  <summary>Checks if the given square can be occupied by a queen.
    ///  </summary>
    function CanOccupy(const Square: TSquare): Boolean;
  end;

type
  ///  <summary>Enumerates the different directions in which a square can be
  ///  influenced by a queen.</summary>
  ///  <remarks>To be "influenced" by a queen a square has to share a row,
  ///  column or diagonal with it.</remarks>
  TSquareInfluence = (siUpDiag, siDownDiag, siColumn, siRow);

type
  ///  <summary>Set of directions in which a square can be influenced by a
  ///  queen.</summary>
  TSquareInfluences = set of TSquareInfluence;

type
  ///  <summary>Associates a square with the set of directions it is influenced
  ///  by a queen.</summary>
  TInfluencedSquare = record
    ///  <summary>The square.</summary>
    Square: TSquare;
    ///  <summary>Set of influences.</summary>
    ///  <remarks>If set to [] then the square is not influenced by any queen.
    ///  </remarks>
    Influences: TSquareInfluences;
    ///  <summary>Constructs a record for the given square, with no influences.
    ///  </summary>
    constructor Create(const ASquare: TSquare);
  end;

type
  ///  <summary>Encapsulates the state of solution engine.</summary>
  ///  <remarks>Used for passing the state to using code to enable it to update
  ///  its output.</remarks>
  TEngineState = record
  strict private
    var
      ///  <summary>Array of squares currently containing queens.</summary>
      fQueens: TArray<TSquare>;
  public
    ///  <summary>Constructs a record representing the given array of squares
    ///  containing queens.</summary>
    constructor Create(const Queens: TArray<TSquare>);
    ///  <summary>Returns an array of squares that currently contain queens.
    ///  </summary>
    ///  <remarks>This is the array that was passed to the constructor.
    ///  </remarks>
    function Queens: TArray<TSquare>;
    ///  <summary>Returns an array of all squares that are currently influenced
    ///  by one or more queens.</summary>
    function InfluencedSquares(ACol: TColCoord; ARow: TRowCoord):
      TArray<TInfluencedSquare>;
  end;

type
  ///  <summary>8 queen problem solution engine.</summary>
  TEngine = class(TObject)
  strict private
    type
      ///  <summary>Possible states solution engine can be in.</summary>
      TMode = (
        emInitialized,  // initialized: no solutions found yet
        emInProgress,   // has found solutions but not yet finished
        emFinished      // has found all solutions and has finished
      );
  strict private
    var
      ///  <summary>Value of SolutionCount property.</summary>
      fSolutionCount: Integer;
      ///  <summary>Current mode of operation of the solution engine.</summary>
      fMode: TMode;
      ///  <summary>Current state of the chessboard.</summary>
      ///  <remarks>Updated as queens are added and removed.</remarks>
      fChessBoard: TChessBoard;
    ///  <summary>Read accessor for EngineState property.</summary>
    function GetEngineState: TEngineState;
    ///  <summary>Removes queen from given chessboard column.</summary>
    ///  <remarks>Does nothing if queen is not on board.</remarks>
    procedure RemoveQueen(const Col: TColCoord);
    ///  <summary>Attempts to place a queen at the next available row in a
    ///  column.</summary>
    ///  <param name="Col">TColCoord [in] Column in which to place queen.
    ///  </param>
    ///  <param name="StartRow">TRowCoord [in] Row at which to begin search for
    ///  square.</param>
    ///  <returns>Boolean. True if a queen was placed successfully, False if
    ///  not.</returns>
    ///  <remarks>We don't always start the search at the first row because a
    ///  queen may already have been placed in the column and removed. In these
    ///  cases the search starts in the row after the one where the queen was
    ///  originally placed.</remarks>
    function PlaceQueen(const Col: TColCoord; StartRow: TRowCoord): Boolean;
    ///  <summary>Attempts to find a square where a queen may be placed in a
    ///  column.</summary>
    ///  <param name="Col">TColCoord [in] Column in which queen may be placed.
    ///  </param>
    ///  <param name="StartRow">TRowCoord [in] Row at which to begin search for
    ///  a square to place queen.</param>
    ///  <param name="Square">TSquare [out] Set to found square if one was
    ///  found. Undefined if no suitable square found.</param>
    ///  <returns>Boolean. True if a suitable square was found, False if not.
    ///  </returns>
    function FindQueenSquare(const Col: TColCoord; StartRow: TRowCoord;
      out Square: TSquare): Boolean;
    ///  <summary>Finds next row on which to begin search for a queen in a
    ///  column.</summary>
    ///  <param name="Col">TColCoord [in] Column to be searched.</param>
    ///  <param name="StartRow">TRowCoord [out] Row on which search is to begin.
    ///  Not set if no suitable row is found.</param>
    ///  <returns>True if a search row is found, False if not.</returns>
    function FindNextSearchRow(Col: TColCoord; out StartRow: TRowCoord):
      Boolean;
  public
    ///  <summary>Constructs object and initialises solution engine.</summary>
    constructor Create;
    ///  <summary>Initialises solution engine to its starting state.</summary>
    ///  <remarks>There are no queens on chessboard in starting state.</remarks>
    procedure Initialize;
    ///  <summary>Finds next solution and updates chessboard accordingly.
    ///  </summary>
    ///  <returns>True if a solution is found, False if not.</returns>
    function NextSolution: Boolean;
    ///  <summary>Number of solutions found to date.</summary>
    property SolutionCount: Integer read fSolutionCount;
    ///  <summary>Current state of solution engine, in form suitable for output
    ///  by using code.</summary>
    property EngineState: TEngineState read GetEngineState;
  end;

{
  Labelling of chess board rows, columns, squares and diagonals
  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
  Each row of the chess booard is labelled by a number in the range 1..8, the
  top row being row 1. Columns are also numbered from 1..8 with column 1 being
  the left most. Squares are addressed by a co-ordinate pair of form (C,R) where
  C is the column number and R is the row number. The following diagrams show
  the row and column numbering and square addressing and which squares are black
  and which white:

        Column and row addressing           Black (B) & white (space) squares
      1   2   3   4   5   6   7   8          1   2   3   4   5   6   7   8
    |---|---|---|---|---|---|---|---|      |---|---|---|---|---|---|---|---|
  1 |1,1|2,1|3,1|4,1|5,1|6,1|7,1|8.1|    1 | B |   | B |   | B |   | B |   |
    |---|---|---|---|---|---|---|---|      |---|---|---|---|---|---|---|---|
  2 |1,2|2,2|3,2|4,2|5,2|6,2|7,2|8,2|    2 |   | B |   | B |   | B |   | B |
    |---|---|---|---|---|---|---|---|      |---|---|---|---|---|---|---|---|
  3 |1,3|2,3|3,3|4,3|5,3|6,3|7,3|8,3|    3 | B |   | B |   | B |   | B |   |
    |---|---|---|---|---|---|---|---|      |---|---|---|---|---|---|---|---|
  4 |1,4|2,4|3,4|4,4|5,4|6,4|7,4|8,4|    4 |   | B |   | B |   | B |   | B |
    |---|---|---|---|---|---|---|---|      |---|---|---|---|---|---|---|---|
  5 |1,5|2,5|3,5|4,5|5,5|6,5|7,5|8,5|    5 | B |   | B |   | B |   | B |   |
    |---|---|---|---|---|---|---|---|      |---|---|---|---|---|---|---|---|
  6 |1,6|2,6|3,6|4,6|5,6|6,6|7,6|8,6|    6 |   | B |   | B |   | B |   | B |
    |---|---|---|---|---|---|---|---|      |---|---|---|---|---|---|---|---|
  7 |1,7|2,7|3,7|4,7|5,7|6,7|7,7|8,7|    7 | B |   | B |   | B |   | B |   |
    |---|---|---|---|---|---|---|---|      |---|---|---|---|---|---|---|---|
  8 |1,8|2,8|3,8|4,8|5,8|6,8|7,8|8,8|    8 |   | B |   | B |   | B |   | B |
    |---|---|---|---|---|---|---|---|      |---|---|---|---|---|---|---|---|

  It can be seen that squares are black if the row and column numbers are both
  odd or they are both even, otherwise the square is white.

  We will also be numbering the diagonals - there are two types of diagonals on
  the board - up and down. Up diagonals slope upwards from left to right while
  down diagonals slope down from left to right. The following diagram shows how
  we number the diagonals:

             "Up" diagonals                        "Down" diagonals
    |---|---|---|---|---|---|---|---|      |---|---|---|---|---|---|---|---|
    | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |      | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
    |---|---|---|---|---|---|---|---|      |---|---|---|---|---|---|---|---|
    | 6 | 5 | 4 | 3 | 2 | 1 | 0 |-1 |      |-1 | 0 | 1 | 2 | 3 | 4 | 5 | 6 |
    |---|---|---|---|---|---|---|---|      |---|---|---|---|---|---|---|---|
    | 5 | 4 | 3 | 2 | 1 | 0 |-1 |-2 |      |-2 |-1 | 0 | 1 | 2 | 3 | 4 | 5 |
    |---|---|---|---|---|---|---|---|      |---|---|---|---|---|---|---|---|
    | 4 | 3 | 2 | 1 | 0 |-1 |-2 |-3 |      |-3 |-2 |-1 | 0 | 1 | 2 | 3 | 4 |
    |---|---|---|---|---|---|---|---|      |---|---|---|---|---|---|---|---|
    | 3 | 2 | 1 | 0 |-1 |-2 |-3 |-4 |      |-4 |-3 |-2 |-1 | 0 | 1 | 2 | 3 |
    |---|---|---|---|---|---|---|---|      |---|---|---|---|---|---|---|---|
    | 2 | 1 | 0 |-1 |-2 |-3 |-4 |-5 |      |-5 |-4 |-3 |-2 |-1 | 0 | 1 | 2 |
    |---|---|---|---|---|---|---|---|      |---|---|---|---|---|---|---|---|
    | 1 | 0 |-1 |-2 |-3 |-4 |-5 |-6 |      |-6 |-5 |-4 |-3 |-2 |-1 | 0 | 1 |
    |---|---|---|---|---|---|---|---|      |---|---|---|---|---|---|---|---|
    | 0 |-1 |-2 |-3 |-4 |-5 |-6 |-7 |      |-7 |-6 |-5 |-4 |-3 |-2 |-1 | 0 |
    |---|---|---|---|---|---|---|---|      |---|---|---|---|---|---|---|---|

  Note that we class the corner squares (numbered 7 and -7) above as diagonals
  of length one.

  Checking the correspondence between a square's co-ordinates and the diagonals
  that run through it we see that the diagonal numbers can be derived from the
  co-ordinates as follows:

      U = 9 - C - R
      D = C - R

  Where U and D are the up and down diagonal numbers respectively and (C,R) are
  the square's co-ordinates.
}


implementation

{ TEngine }

constructor TEngine.Create;
begin
  inherited;
  Initialize;
end;

function TEngine.FindNextSearchRow(Col: TColCoord; out StartRow: TRowCoord):
  Boolean;
begin
  Result := True;
  if not fChessBoard.IsQueenOnBoard(Col) then
    StartRow := TChessBoard.FirstRow
  else if fChessBoard.GetQueenSquare(Col).Row = TChessBoard.LastRow then
    Result := False
  else
    StartRow := Succ(fChessBoard.GetQueenSquare(Col).Row);
end;

function TEngine.FindQueenSquare(const Col: TColCoord; StartRow: TRowCoord;
  out Square: TSquare): Boolean;
var
  Row: TRowCoord; // loops through rows on chessboard
begin
  Row := StartRow;
  repeat
    Square := TSquare.Create(Col, Row);
    if fChessBoard.CanOccupy(Square) then
      Exit(True);
    if Row = TChessBoard.LastRow then
      Exit(False);
    Inc(Row);
  until False;
end;

function TEngine.GetEngineState: TEngineState;
var
  Col: TColCoord;                 // loops thru columns of chessboard
  Count: Integer;                 // counts queens on chessboard
  QueenSquares: TArray<TSquare>;  // array of squares containing queens?
begin
  SetLength(QueenSquares, High(TColCoord) - Low(TColCoord) + 1);
  Count := 0;
  for Col := TChessBoard.FirstColumn to TChessBoard.LastColumn do
    if fChessBoard.IsQueenOnBoard(Col) then
    begin
      QueenSquares[Count] := fChessBoard.GetQueenSquare(Col);
      Inc(Count);
    end;
  SetLength(QueenSquares, Count);
  Result := TEngineState.Create(QueenSquares);
end;

procedure TEngine.Initialize;
begin
  fSolutionCount := 0;
  fChessBoard.Clear;
  fMode := emInitialized;
end;

function TEngine.NextSolution: Boolean;
var
  Col: TColCoord;             // column of chess board being processed
  SearchStartRow: TRowCoord;  // 1st row searched for suitable square for queen
  ColumnCompleted: Boolean;   // flag indicating if fininshed searching a column
begin
  Assert(fMode <> emFinished, 'TEngine.NextSolution: fMode = emFinished');
  if fMode = emInitialized then
  begin
    // Not yet started to place queens: begin on column 1
    Col := TChessBoard.FirstColumn;
    fMode := emInProgress;
  end
  else // fMode = emInProgress
  begin
    // In progress => we have already found a solution so last processed column
    // must be colum 8. Remove queen from that column and rewind to column 7
    Col := Pred(TChessBoard.LastColumn);
    RemoveQueen(TChessBoard.LastColumn);
  end;
  // Assume no solution found
  Result := False;
  // Repeatedly search for solutions until one found or all possibilities tried
  repeat
    ColumnCompleted := not FindNextSearchRow(Col, SearchStartRow);
    RemoveQueen(Col);
    // Try to place queen on current column
    if not ColumnCompleted and PlaceQueen(Col, SearchStartRow) then
      if Col < TChessBoard.LastColumn then
        // Move on to next column
        Inc(Col)
      else
      begin
        // We are on last column and we've placed queen => we've found a
        // solution. Increment count of solutions and record we've succeeded
        Inc(fSolutionCount);
        Result := True;
      end
    else
      // Couldn't place queen, reduce current column and go round again. If
      // we are on first column then we are finished.
      if Col > TChessBoard.FirstColumn then
        Dec(Col)
      else
        fMode := emFinished;
  // Keep trying until we've succeeded or we've reduced the current column below
  // one which means there are no more options to try (we've finished)
  until Result or (fMode = emFinished);
end;

function TEngine.PlaceQueen(const Col: TColCoord; StartRow: TRowCoord): Boolean;
var
  Square: TSquare; // represents each row to search for queen
begin
  Result := FindQueenSquare(Col, StartRow, Square);
  if Result then
    fChessBoard.PlaceQueen(Square);
end;

procedure TEngine.RemoveQueen(const Col: TColCoord);
begin
  if fChessBoard.IsQueenOnBoard(Col) then
    fChessBoard.RemoveQueen(Col);
end;

{ TOccupancy }

function TOccupancy.CanOccupy(const Square: TSquare): Boolean;
begin
  Result := not fRows[Square.Row]
    and not fUpDiags[Square.UpDiagonal]
    and not fDownDiags[Square.DownDiagonal];
end;

procedure TOccupancy.Clear;
var
  Row: TRowCoord;   // loops thru all rows on chessboard
  Diag: TDiagonal;  // loops thru all diagonals on chessboard
begin
  for Row := Low(fRows) to High(fRows) do
    fRows[Row] := False;
  for Diag := Low(TDiagonal) to High(TDiagonal) do
  begin
    fUpDiags[Diag] := False;
    fDownDiags[Diag] := False;
  end;
end;

procedure TOccupancy.Occupy(const Square: TSquare);
begin
  SetOccupancy(Square, True);
end;

procedure TOccupancy.SetOccupancy(const Square: TSquare;
  Flag: Boolean);
begin
  Assert(fRows[Square.Row] <> Flag);
  Assert(fUpDiags[Square.UpDiagonal] <> Flag);
  Assert(fDownDiags[Square.DownDiagonal] <> Flag);
  fRows[Square.Row] := Flag;
  fUpDiags[Square.UpDiagonal] := Flag;
  fDownDiags[Square.DownDiagonal] := Flag;
end;

procedure TOccupancy.Vacate(const Square: TSquare);
begin
  SetOccupancy(Square, False);
end;

{ TSquare }

constructor TSquare.Create(ACol: TColCoord; ARow: TRowCoord);
begin
  fCol := ACol;
  fRow := ARow;
end;

function TSquare.DownDiagonal: TDiagonal;
begin
  Result := fCol - fRow;
end;

function TSquare.UpDiagonal: TDiagonal;
begin
  Result := High(TBoardCoord) + 1 - fCol - fRow;
end;

{ TChessBoard }

procedure TChessBoard.PlaceQueen(const Square: TSquare);
begin
  fQueens[Square.Col].Place(Square);
  fOccupancy.Occupy(Square);
end;

function TChessBoard.CanOccupy(const Square: TSquare): Boolean;
begin
  Result := fOccupancy.CanOccupy(Square);
end;

procedure TChessBoard.Clear;
var
  Col: TColCoord; // loops thru all columns of chessboard
begin
  for Col := Low(fQueens) to High(fQueens) do
    fQueens[Col].Clear;
  fOccupancy.Clear;
end;

function TChessBoard.ContainsQueen(Col: TColCoord; Row: TRowCoord): Boolean;
begin
  Result := fQueens[Col].Square.Row = Row;
end;

function TChessBoard.GetQueenSquare(Col: TColCoord): TSquare;
begin
  Result := fQueens[Col].Square;
end;

function TChessBoard.IsQueenOnBoard(const Col: TColCoord): Boolean;
begin
  Result := fQueens[Col].IsOnBoard;
end;

procedure TChessBoard.RemoveQueen(const Col: TColCoord);
begin
  fOccupancy.Vacate(fQueens[Col].Square);
  fQueens[Col].Remove;
end;

{ TQueen }

procedure TQueen.Clear;
begin
  fIsOnBoard := False;
end;

function TQueen.GetSquare: TSquare;
begin
  Assert(fIsOnBoard);
  Result := fSquare;
end;

procedure TQueen.Place(const Square: TSquare);
begin
  Assert(not fIsOnBoard);
  fSquare := Square;
  fIsOnBoard := True;
end;

procedure TQueen.Remove;
begin
  Assert(fIsOnBoard);
  fIsOnBoard := False;
end;

{ TEngineState }

constructor TEngineState.Create(const Queens: TArray<TSquare>);
begin
  fQueens := Copy(Queens);
end;

function TEngineState.InfluencedSquares(ACol: TColCoord; ARow: TRowCoord):
  TArray<TInfluencedSquare>;
var
  Col: TColCoord;           // loops thru columns of chessboard
  Row: TRowCoord;           // loops thru rows of chessboard
  S: TSquare;               // square defined by ACol and ARow
  Count: Integer;           // number of influenced squares
  InfSq: TInfluencedSquare; // records influences of each square on board
begin
  // Prepare result array
  SetLength(Result, TChessBoard.SquareCount);
  Count := 0;
  // Find squares influenced by square at given row and column
  S := TSquare.Create(ACol, ARow);
  for Col := Low(TColCoord) to High(TColCoord) do
  begin
    for Row := Low(TRowCoord) to High(TRowCoord) do
    begin
      InfSq := TInfluencedSquare.Create(TSquare.Create(Col, Row));
      if InfSq.Square.Row = S.Row then
        Include(InfSq.Influences, siRow);
      if InfSq.Square.Col = S.Col then
        Include(InfSq.Influences, siColumn);
      if InfSq.Square.UpDiagonal = S.UpDiagonal then
        Include(InfSq.Influences, siUpDiag);
      if InfSq.Square.DownDiagonal = S.DownDiagonal then
        Include(InfSq.Influences, siDownDiag);
      if InfSq.Influences <> [] then
      begin
        // found an influenced square: add it
        Result[Count] := InfSq;
        Inc(Count);
      end;
    end;
  end;
  // Correct length of result array
  SetLength(Result, Count);
end;

function TEngineState.Queens: TArray<TSquare>;
begin
  Result := fQueens;
end;

{ TInfluencedSquare }

constructor TInfluencedSquare.Create(const ASquare: TSquare);
begin
  Square := ASquare;
  Influences := [];
end;

end.
