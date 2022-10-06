extends Node2D

var GameBoard = []

var Piece = preload("res://Piece.tscn")
var tempPnumber = 0

enum pieceWeight {
	KING = 0
	QUEEN = 1
	ROOK = 4
	BISHOP = 2
	KNIGHT = 3
	PAWN = 5
	
	NoSLOT = -1
}

var pieceTYPE

var sqcol = 0
var sqpos = Vector2(50,50)

var sqnum = 00
var Pnum = 00
var SQUARENUM = 00

var tempPnum = 00

var turn = 1 # 1 is whites turn, -1 is black turn

var bKingPOS
var wKingPOS

func _ready():
	
	createBoard()
	
func createBoard():	
	update()		
func _draw():
	for letter in range(8):
		for number in range(8):

			#print(str(letter) + str(number))
			sqnum = (str(letter) + str(number))
			sqcol = (letter + number) % 2 # returns 0 or 1, or white/black	
			
			if (sqnum == "00" || sqnum == "07" || sqnum == "70" || sqnum == "77"): #rook
				tempPnum = 4
				pieceTYPE = "ROOK"
			elif (sqnum == "01" || sqnum == "06" || sqnum == "71" || sqnum == "76"): #horse
				tempPnum = 3
				pieceTYPE = "KNIGHT"
			elif (sqnum == "02" || sqnum == "05" || sqnum == "72" || sqnum == "75"): #bishop
				tempPnum = 2
				pieceTYPE = "BISHOP"
			elif (sqnum == "03" || sqnum == "73"): #queen
				tempPnum = 1
				pieceTYPE = "QUEEN"
			elif (sqnum == "04" || sqnum == "74"): #king
				tempPnum = 6
				pieceTYPE = "KING"
			else:
				tempPnum = 5
				pieceTYPE = "PAWN"
			

			draw_rect(Rect2(Vector2(sqpos.x + (letter * 100), sqpos.y + (number * 100)), Vector2(100,100)),Color(sqcol + 0.5,sqcol -0.1,sqcol - 0.3,1))				

			addPieces(Vector2(sqpos.x + (number * 100), sqpos.y + (letter * 100)), tempPnum, pieceTYPE)
			
func addPieces(squarepos, piecetype, pieceNAME):
	if(squarepos.y > 600 || squarepos.y < 200): #only adds pieces on the first and last 2 rows
		
		var tempP = Piece.instance()
		var tempPcolor = 0
	
		tempP.position.x = squarepos.x + 50
		tempP.position.y = squarepos.y + 50
		tempPnumber += 1
		
		tempP.pieceValue = piecetype
		tempP.pieceTYPE = pieceNAME
		tempP.pieceTEAM = 1
		tempP.pieceNUMBER = tempPnumber
			# tempPcolor makes it easier to set piece types
		if(squarepos.y < 200):  # for black pieces (pieces are default as white)
			tempPcolor = 1
			tempP.pieceTEAM = -1
		
		if tempP.pieceTEAM == -1:            # assigns piece layers, but cant detect unless picked up
			tempP.get_node("piece_taker").set_collision_layer_bit(1, true)
		elif tempP.pieceTEAM == 1:
			tempP.get_node("piece_taker").set_collision_layer_bit(0, true)
		
		if(pieceNAME != "KING"):
			tempP.frame = tempPcolor * 6 + piecetype		# for this chunk, KING is exluded due to frame issues
		
		if(pieceNAME == "KING"):
			tempP.get_node("piece_taker").set_collision_layer_bit(2, true)
			tempP.frame = tempPcolor * 6 		

			
		if tempPcolor == 0: # for appending to array
			tempPcolor = -1
		GameBoard.append((piecetype * -tempPcolor))
		
		add_child(tempP)
		
	else:
		tempPnumber += 1
		GameBoard.append(0)
	
func _input(event):
	if event is InputEventKey:
		if event.is_pressed() && event.scancode == KEY_SPACE:
			$GameData.text = str(GameBoard)
