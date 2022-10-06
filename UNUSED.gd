# ALSO OL CAPTURE CODE FOR PIECES >>>>>>>>>>>>>>>>>>>

#	if area.get_parent().pieceTEAM != pieceTEAM && isPicked == false && area.get_parent().canBeCaptured == true && area.get_parent().isPicked == true:
#		if capturePiece(pieceTYPE, startingPosition) == true:
#			position = area.global_position.snapped(Vector2(100,100))
#			scale = Vector2(0.5,0.5)
#			canBeCaptured = true
#			area.get_parent().queue_free()
#			isPicked = false
#			get_parent().turn = pieceTEAM * -1       # FIX YOUR CAPTURE CODE AND DELETE THIS CHUNK ( 9/17/22)		
#		else:
#			isPicked = false
#			canBeCaptured = true
#			scale = Vector2(0.5,0.5)
#			global_position = startingPosition	



 # OLD CAPTURE CODE FOR PIECES >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#func capturePiece(piece, posSTART):   
#	moveNEWHolder = get_global_mouse_position() - posSTART
#	NEWSQUARE = moveNEWHolder.snapped(Vector2(100,100))	
#
#
#	if piece == "PAWN":
#		if abs(NEWSQUARE.x) == 100 && abs(NEWSQUARE.y) == 100 && newSquarePIECE != 0:	
#
#			return true
#		else:
#			return false
#	else:
#		if newSquarePIECE != 0 && movePiece(pieceTYPE, startingPosition) == true:
#			print("THIS WORKS")
#			return true
#		else:
#			return false	



# THIS CODE BLOCK WAS USED TO TEST FOR POSSIBLE MOVES IN PIECESCRIPT ( 10/2/2022 )
#func possibleMoves(pieceTYPE):
#	var tempMove = 0
#	var skippedMoves = false # keeps track of moves that cannot be played due to limits
#	moveLIST = []
#
#	if pieceTYPE == "ROOK":
#		for i in range(8): # vertical test
#			# includes 0 because array does not hold 64, but 63 pieces
#			tempMove = pieceNUMBER - (8 * i) - 1 # counts in the up direction
#
#			if tempMove > 0 && tempMove <= pieceNUMBER && get_parent().GameBoard[tempMove] == 0: 
#				# runs if the tile checked is not at the top edge and there is no piece on either team on that tile
#				skippedMoves = false
#				moveLIST.append(tempMove)
#
#			elif tempMove <= 0 && get_parent().GameBoard[tempMove] == 0:
#				# runs if the tile checked is not at the bottom edge and there is no piece on either team on that tile
#				skippedMoves = false
#				tempMove = 8 + (8 * i) - 1
#				moveLIST.append(tempMove)
#			elif get_parent().GameBoard[tempMove] != 0 && get_parent().GameBoard[tempMove]/abs(get_parent().GameBoard[tempMove]) != pieceTEAM :
#				# runs if the tile checked has a piece on top of it and that piece is not on your team
#				if skippedMoves == false:
#					skippedMoves = true # does not count tiles ahead of the captured tile
#
#					if tempMove > 0 && tempMove <= pieceNUMBER: # smaller if block as the first one
#						moveLIST.append(tempMove)
#					elif tempMove <= 0:
#						tempMove = 8 + (8 * i) - 1
#						moveLIST.append(tempMove)
#
#	return moveLIST





	# FIGURE OUT WHY THIS SUBTRACTS / ADDS MORE THN IT SHOULD WHEN CAPTURING
	# 9/18/22 REASON, CAPTURE CODE PREVIOUSLY RAN movePiece A 2ND TIME, CAUSING DOUBLE CHECK
	
#	print(str(ARRAYupdatePOSITION) + " ARRAY ADDITION")
#	print(str(self.pieceNUMBER) + " OLD POSITION")
#	print(str(pieceTEAM) + " " + str(pieceNUMBER + ARRAYupdatePOSITION - 1) + " WHERE YOU ARE NOW")
#	print()
