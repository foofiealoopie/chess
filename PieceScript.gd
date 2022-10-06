extends Sprite

var pieceTEAM # 1 will be white, -1 will be black

var isPicked = false

var BlackisChecked = false
var WhiteisChecked = false


var M #Slope for movement calculation

var pieceTYPE # string value that holds the name of the piece

var firstTURN = true # exclusive to pawn

var pieceNUMBER = 0 # piece number 1-32

var pieceValue # -1, -2, -3, -4. -5 and the positive counterparts used to represent the piece on array

var moveLIST = [] # generates possible moves
var moveLISTchecked = []

var ARRAYupdatePOSITION = 0  # value added to current position in order to update array

var canBeCaptured = true # signifys whether or not the piece in question can be captured or not
var pieceCaptured = 0

var newSquarePIECE # tells you what piece is in the new location, if no piece, returns 0


var NEWSQUARE = Vector2(0,0)

var startingPosition = Vector2(0,0)
var moveNEWHolder = Vector2()

func _ready():
	if pieceTYPE == "KING":
		if pieceTEAM == 1:
			get_parent().wKingPOS = pieceNUMBER
		elif pieceTEAM == -1:
			get_parent().bKingPOS = pieceNUMBER

	startingPosition = global_position
	
	if get_parent().turn != pieceTEAM:
		modulate = Color(1,1,1,0.7)
	else:
		modulate = Color(1,1,1,1)
	
func _input(event):
		
	if event is InputEventMouseButton:
		if get_rect().has_point(get_local_mouse_position()):
			if pieceTEAM == get_parent().turn:
				
				if event.is_pressed():
					isPicked = true
								
					if pieceTEAM == -1:						

						$piece_taker.set_collision_mask_bit(1, true) # detects black

					elif pieceTEAM == 1:

						$piece_taker.set_collision_mask_bit(0, true) #detects white
					
						
					startingPosition = global_position
					scale = Vector2(0.8,0.8)
					
					get_tree().set_input_as_handled()  # important line: makes sure multiple pieces arent picked

				else:
					
					isPicked = false
					scale = Vector2(0.5,0.5)
					
					if pieceTEAM == -1: # black pieces
						$piece_taker.set_collision_mask_bit(1, false) # can no longer detect black pieces
						
					elif pieceTEAM == 1: # white pieces
						$piece_taker.set_collision_mask_bit(0, false) # can no longer detect white pieces

					
						
					if movePiece(pieceTYPE, startingPosition) == true  : #if legal move was made	
						position = position.snapped(Vector2(100,100))

						if pieceTEAM == -1: # ALLOWS FOR CAPTURING
							$piece_taker.set_collision_mask_bit(0, true)
						elif pieceTEAM == 1:
							$piece_taker.set_collision_mask_bit(1, true)
													
						updateMainBoardArray()				
						#test for king checks here somehow ( 10/5/22)
						
								
						
						yield(get_tree().create_timer(0.05),"timeout") # delayed to prevent instant fail code
						get_parent().get_node("moveList").text = str(pieceNUMBER - 1) + " piece, moves " +  str(possibleMoves(pieceTYPE)) # calls function and simultaneously sets text
						
						if pieceTEAM == 1:
							
							checked(pieceTEAM, "KING", get_parent().wKingPOS)
						elif pieceTEAM == -1:
							checked(pieceTEAM, "KING", get_parent().bKingPOS)
						
						canBeCaptured = true
						startingPosition = global_position
						
						if pieceTEAM == -1:  # RESETS COLLISIONS (so pieces dont "argue" on captures)
							$piece_taker.set_collision_mask_bit(0, false) 

						elif pieceTEAM == 1:
							$piece_taker.set_collision_mask_bit(1, false)

						
						get_parent().turn = pieceTEAM * -1 # if successful, swap turns
						
					else:
						global_position = startingPosition

func _process(_delta):
	if get_rect().has_point(get_local_mouse_position()):
		if pieceTEAM == get_parent().turn:
			if isPicked:
				
				canBeCaptured = false
				position = get_global_mouse_position()
	
	if get_parent().turn != pieceTEAM:
		modulate = Color(1,1,1,0.7)

		isPicked = false
	else:
		modulate = Color(1,1,1,1)

func _on_piece_taker_area_entered(area):  #tests for collisions
	
#	if !canBeCaptured:       test code delete later
#		print("I CANNOT BE CAPTURED" + str(pieceTYPE))
#	else:
#		print("I CAN BE CAPTURED " + str(pieceTYPE))
	
	if canBeCaptured == true && pieceTEAM != area.get_parent().pieceTEAM:
		queue_free()
		
		isPicked = false # THIS CODE BLOCK RUNS ON THE PIECE THAT SUCCESSFULLY CAPTURES
		canBeCaptured = true
		scale = Vector2(0.5,0.5)
		startingPosition = global_position
		 
		print(area.get_parent().get_parent().GameBoard[pieceNUMBER])	
		
	elif canBeCaptured == false && area.get_parent().pieceTEAM == pieceTEAM && pieceTYPE != "KNIGHT":
		isPicked = false
		canBeCaptured = true
		scale = Vector2(0.5,0.5)

		global_position = startingPosition # remove the area.get_parent() before startingPosition to implement castling

	
func movePiece(piece, posSTART):

	
	moveNEWHolder = get_global_mouse_position() - posSTART
	NEWSQUARE = moveNEWHolder.snapped(Vector2(100,100))    #CODE FOR UPDATING ARRAY


	ARRAYupdatePOSITION = 8 * (NEWSQUARE.y/100) + (NEWSQUARE.x/100)
	
	
	newSquarePIECE = get_parent().GameBoard[pieceNUMBER + ARRAYupdatePOSITION - 1]   # CODE USED TO TEST ARRAYS	


	
	if piece == "ROOK":
		if abs(moveNEWHolder.x) > 50 && abs(moveNEWHolder.y) > 50:
			return false 			
		else: #LEGAL
			return true	
	elif piece == "BISHOP":
		if(get_global_mouse_position().x - posSTART.x) != 0:
			M = (abs(get_global_mouse_position().y) - abs(posSTART.y))/(get_global_mouse_position().x - posSTART.x)
		else: # adds the slightest Off set to prevent division by 0
			M = (abs(get_global_mouse_position().y) - abs(posSTART.y))/(get_global_mouse_position().x + 0.0001 - posSTART.x)

		if abs(M) < 0.5 || abs(M) > 1.5  :
			return false
		else: #LEGAL
			return true
	elif piece == "KNIGHT":
		
		if(NEWSQUARE.x != 0) && abs(NEWSQUARE.y) < 300:
			if abs(NEWSQUARE.y) / abs(NEWSQUARE.x) == 2 || abs(NEWSQUARE.y) / abs(NEWSQUARE.x) == 0.5:

				return true
			else:
				return false
		else:
			return false
	elif piece == "PAWN":

		# MULTI CHECKS FOR TURNS AND DIRECTION
		if(NEWSQUARE.y) != 0 && NEWSQUARE.x == 0 && newSquarePIECE == 0: # ONLY MOVES FORWARD IF NO PIECE BLOCKS
			if firstTURN:				
				if abs((NEWSQUARE.y)) == 200:
					firstTURN = false

					return true
				elif abs((NEWSQUARE.y)) == 100:
					firstTURN = false

					return true
				else:
					return false
			elif (abs((moveNEWHolder.y)) >= 50 && abs((moveNEWHolder.y)) <= 150) && NEWSQUARE.y != 100 * pieceTEAM: #normal movement

				return true
			else:
				return false
				
		else:
			return false
	elif piece == "KING":
		if abs((NEWSQUARE.y)) == 100 || abs((NEWSQUARE.x)) == 100 && checked(pieceTEAM, pieceTYPE, pieceNUMBER) == false:
			if pieceTEAM == 1:
				get_parent().wKingPOS = pieceNUMBER
			elif pieceTEAM == -1:
				get_parent().bKingPOS = pieceNUMBER
			return true
		else:
			return false
			
	else: #QUEEN
		return true		
		
func updateMainBoardArray():         #JUST KEEPS GAMEBOARD UP TO DATE
	get_parent().GameBoard[pieceNUMBER - 1] = 0
	
	pieceNUMBER = pieceNUMBER + ARRAYupdatePOSITION
	
	pieceCaptured = get_parent().GameBoard[pieceNUMBER - 1]
	
	get_parent().GameBoard[pieceNUMBER - 1] = pieceValue * pieceTEAM

	#print(str(newSquarePIECE) + " THIS IS THE PIECE IN YOUR CURRENT SPOT " )
	#print(str(pieceNUMBER) + " THIS IS YOUR NEW POSITION") 

			
			
			
func possibleMoves(pieceobject): # computer calculations
	var tempMove = 0
	moveLIST = []
	
	var column = int(pieceNUMBER - 1) %8
	var row = int(pieceNUMBER - 1) / 8

	
	var endColumn = 63 - (column-7)
	get_parent().get_node("Checked").visible = false 
	
	if pieceobject == "ROOK" || pieceobject == "QUEEN":
		
		for i in range(7):            # VERTICAL TEST  NORTH
			tempMove = pieceNUMBER - (8 * (i + 1)) - 1
			
			if tempMove < column:
					
					break
			
			if tempMove >= column && get_parent().GameBoard[tempMove] == 0 : 
				
				moveLIST.append(tempMove)
			elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) != pieceTEAM :
				moveLIST.append(tempMove)
				break
			elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) == pieceTEAM :
				break
			else:				
				break

		for i in range(7):                # VERTICAL TEST SOUTH

			tempMove = pieceNUMBER + (8 * (i + 1)) - 1
			
			if tempMove > endColumn:
				
				break
				
			if tempMove <= endColumn && get_parent().GameBoard[tempMove] == 0:

				moveLIST.append(tempMove)
					
			elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) != pieceTEAM:
				moveLIST.append(tempMove)
				break
			elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) == pieceTEAM:
				break
			else:
				break	
				
				#   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SPLIT HERE				
		
		for i in range(7):				# HORIZONTAL TEST EAST
			tempMove = pieceNUMBER + (i + 1) - 1
			
			if int(tempMove)/8 > row:
					break
					
			if int(tempMove)/8 <= row && get_parent().GameBoard[tempMove] == 0: 				
				
				moveLIST.append(tempMove)
			elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) != pieceTEAM:
				moveLIST.append(tempMove)
				break
			elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) == pieceTEAM:
				break
			else:				
				break
		
		for i in range(7):                # HORIZONTAL TEST WEST

			tempMove = pieceNUMBER - (i + 1) - 1
			
			if int(tempMove)/8 < row:						
					break
					
			if int(tempMove)/8 >= row && get_parent().GameBoard[tempMove] == 0:
				
				moveLIST.append(tempMove)
			elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) != pieceTEAM:
				moveLIST.append(tempMove)
				break
			elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) == pieceTEAM :
				break
			else:
				break
	

	if pieceobject == "BISHOP" || pieceobject == "QUEEN":
		var direction = [1, -1, -1, 1, 1] # 1 is left, -1 is right
	
		var countDirection = [1, -1, 1, -1]
		var countDirection2 = [1, 1, -1, -1]
		

		var lim = [-1,8,-1,8] # 0 is leftmost column, 7 is rightmost column
		var limV = [-1, -1, 8, 8]
	
		for b in range(4):    
				
			column = int(pieceNUMBER - 1) %8 
			row = int(pieceNUMBER - 1) / 8
			
			for i in range(7): #  
				
				tempMove = (pieceNUMBER - 1) + direction[b + 1] * ( (8 + direction[b]) * (i+1)) # goes through all 4 directions
				
				
				column -= 1 * countDirection[b]

				row -= 1 * countDirection2[b]
			

				
				if int(tempMove)/8 >= 0 && int(tempMove)/8 <= 7 && int(tempMove) % 8 >= 0 && int(tempMove) % 8 <= 7 && column != lim[b] && row != limV[b]:

					if get_parent().GameBoard[tempMove] == 0:
						moveLIST.append(tempMove)
						
					elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) != pieceTEAM:
						moveLIST.append(tempMove)
						break
					elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) == pieceTEAM :
						break
					else:
						break
	
				else:
					break


		
	return moveLIST

func checked(team, piece, kingposition):
	var tempMove = 0
	moveLISTchecked = []
	
	var column = int(kingposition - 1) %8
	var row = int(kingposition - 1) / 8

	
	var endColumn = 63 - (column-7)
	get_parent().get_node("Checked").visible = false 
	get_parent().get_node("Checked2").visible = false 
	
	if piece == "KING":
		
		for i in range(7):            # VERTICAL TEST  NORTH
			tempMove = kingposition - (8 * (i + 1)) - 1
			
			if tempMove < column:
					
					break
			
			if tempMove >= column && get_parent().GameBoard[tempMove] == 0 : 
				
				moveLISTchecked.append(tempMove)
			elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) != pieceTEAM :
				moveLISTchecked.append(tempMove)
				break
			elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) == pieceTEAM :
				break
			else:				
				break

		for i in range(7):                # VERTICAL TEST SOUTH

			tempMove = kingposition + (8 * (i + 1)) - 1
			
			if tempMove > endColumn:
				
				break
				
			
			if tempMove <= endColumn && get_parent().GameBoard[tempMove] == 0:

				moveLISTchecked.append(tempMove)
					
			elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) != pieceTEAM:
				moveLISTchecked.append(tempMove)
				break
			elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) == pieceTEAM:
				break
			else:
				break	
				
				#   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SPLIT HERE				
		
		for i in range(7):				# HORIZONTAL TEST EAST
			tempMove = kingposition + (i + 1) - 1
			
			if int(tempMove)/8 > row:
					break
					
			if int(tempMove)/8 <= row && get_parent().GameBoard[tempMove] == 0: 				
				
				moveLISTchecked.append(tempMove)
				
				
			elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) != pieceTEAM:
				moveLISTchecked.append(tempMove)
				break
			elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) == pieceTEAM:
				break
			else:				
				break
		
		for i in range(7):                # HORIZONTAL TEST WEST

			tempMove = kingposition - (i + 1) - 1
			
			if int(tempMove)/8 < row:						
					break
					
			if int(tempMove)/8 >= row && get_parent().GameBoard[tempMove] == 0:
				
				moveLISTchecked.append(tempMove)
			elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) != pieceTEAM:
				moveLISTchecked.append(tempMove)
				break
			elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) == pieceTEAM :
				break
			else:
				break

		var direction = [1, -1, -1, 1, 1] # 1 is left, -1 is right
	
		var countDirection = [1, -1, 1, -1]
		var countDirection2 = [1, 1, -1, -1]
		

		var lim = [-1,8,-1,8] # 0 is leftmost column, 7 is rightmost column
		var limV = [-1, -1, 8, 8]
		
		
		for b in range(4):    
				
			column = int(kingposition - 1) %8 
			row = int(kingposition - 1) / 8
			
			for i in range(7): #  
				
				tempMove = (kingposition - 1) + direction[b + 1] * ( (8 + direction[b]) * (i+1)) # goes through all 4 directions
				
				
				column -= 1 * countDirection[b]

				row -= 1 * countDirection2[b]
			

				
				if int(tempMove)/8 >= 0 && int(tempMove)/8 <= 7 && int(tempMove) % 8 >= 0 && int(tempMove) % 8 <= 7 && column != lim[b] && row != limV[b]:

					if get_parent().GameBoard[tempMove] == 0:
						moveLISTchecked.append(tempMove)
						
					elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) != pieceTEAM:
						moveLISTchecked.append(tempMove)
						break
					elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) == pieceTEAM :
						break
					else:
						break
	
				else:
					break
	print(moveLISTchecked)
	
	for x in moveLISTchecked: # TESTS FOR CHECKS
		print(str(get_parent().GameBoard[x+ 1]) + str(pieceTEAM))
		if get_parent().GameBoard[x] != 0 && get_parent().GameBoard[x]/abs(get_parent().GameBoard[x]) != 1 && pieceTEAM == -1 && piece == "KING":
			
			get_parent().get_node("Checked").visible = true
			get_parent().get_node("Checked/King").frame = 0
			WhiteisChecked = true
			return true
		elif get_parent().GameBoard[x] != 0 && get_parent().GameBoard[x]/abs(get_parent().GameBoard[x]) != -1 && pieceTEAM == 1 && piece == "KING":
			get_parent().get_node("Checked2").visible = true
			get_parent().get_node("Checked2/King").frame = 6
			BlackisChecked = true
			return true
		else:
			return false
	
	

	
	
		
