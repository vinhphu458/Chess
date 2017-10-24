//
//  GameController.m
//  MyChess
//
//  Created by Admin on 10/4/17.
//  Copyright © 2017 dvphu. All rights reserved.
//
//
//#import "GameController.h"
//
//@interface GameController(){
//    NSMutableArray* _listChess;
//    int origin;
//    int destination;
//    OnMoveState _state;
//    Location* upperKingLocation;
//    Location* belowKingLocation;
//}
//@end
//@implementation GameController
//
//-(void)addListChess:(NSMutableArray *)listChess{
//    _listChess = listChess;
//    [self saveKingPosition];
//}
//
//-(void) saveKingPosition{
//    for(int i=0;i<CHESS_BOARD_SIZE;i++){
//        ChessModel* chess = [_listChess objectAtIndex:i];
//        if(chess.tag == King && chess.type == UPPER_TEAM){
//            upperKingLocation = chess.location;
//        }
//        if(chess.tag == King && chess.type == BELOW_TEAM){
//            belowKingLocation = chess.location;
//        }
//    }
//}
//
//-(void) setStateChangedListener:(OnMoveState)state{
//    _state = state;
//}
//
//-(void)move:(int)from toPosition:(int)position{
//    origin = from;
//    destination = position;
//    ChessModel* chess = ((ChessModel*)[_listChess objectAtIndex:from]);
//    MoveState state = Keep;
//    NSLog(@"Move: %@ from %d to %d", chess.icon, from, position);
//    switch (chess.tag) {
//        case King:
//            state = [self KingTile];
//            if(state&Move){
//                if(chess.type == UPPER_TEAM){
//                    upperKingLocation = chess.location;
//                }else{
//                    belowKingLocation = chess.location;
//                }
//            }
//            break;
//        case Queen:
//            state = [self QueenTile];
//            break;
//        case Bishop:
//            state = [self BishopTile];
//            break;
//        case Knight:
//            state = [self KnightTile];
//            break;
//        case Rook:
//            state = [self RookTile];
//            break;
//        case Pawn:
//            state = [self PawnTile:chess.type];
//            break;
//        default:
//            _state(state);
//            break;
//    }
//    //emit move state
//    _state(state);
//}
//
//-(void) changeGameTurn{
//    _game_turn++;
//    NSLog(@"Game Turns: %d", _game_turn);
//    if([self isCheckmate]){
//        NSLog(@"CheckMate");
//        _state(Checkmate);
//    }
//}
//
////for pawn
//-(bool) moveStraightUp1{
//    int value = origin - destination;
//    return value>0 && value==VERTICAL_UP;
//}
//-(bool) moveStraightDown1{
//    int value = origin - destination;
//    return value<0 && value==VERTICAL_DOWN;
//}
//-(bool) moveDiagonalUp1{
//    int value = origin - destination;
//    return value>0 && (abs(value)==DIAGONAL_R_U_L_D || abs(value)==DIAGONAL_L_U_R_D);
//}
//-(bool) moveDiagonalDown1{
//    int value = origin - destination;
//    return value<0 && (abs(value)==DIAGONAL_R_U_L_D || abs(value)==DIAGONAL_L_U_R_D);
//}
//-(bool) isFirstMove:(int) type{
//    if(type == UPPER_TEAM){
//        for(int i = 8;i<16;i++){//pawns's row
//            if(origin == i) return true;
//        }
//    }
//    if(type == BELOW_TEAM){
//        for(int i = 48;i<56;i++){//pawns's row
//            if(origin == i) return true;
//        }
//    }
//    return false;
//}
////Other
//-(bool) moveHorizontal_1{
//    int value = abs(origin - destination);
//    int rowOrigin = origin/COLLUMN_SIZE;
//    int rowDestination = destination/COLLUMN_SIZE;
//    return value == HORIZONTAL_RIGHT && rowOrigin == rowDestination;
//}
//-(bool) moveVertical_1{
//    int value = origin - destination;
//    return abs(value)==abs(VERTICAL_DOWN);
//}
//-(bool) moveDiagonal_1{
//    int value = origin - destination;
//    return (abs(value)==DIAGONAL_R_U_L_D || abs(value)==DIAGONAL_L_U_R_D);
//}
//
//-(bool) moveDiagonal{
//    int value = abs(origin - destination);
//    return value%DIAGONAL_R_U_L_D == 0 || value%DIAGONAL_L_U_R_D == 0;
//}
//-(bool) moveStraightVertical{
//    int value = abs(origin - destination);
//    return value%VERTICAL_UP == 0;
//}
//-(bool) moveStraightHorizontal{
//    int rowOrigin = origin/COLLUMN_SIZE;
//    int rowDestination = destination/COLLUMN_SIZE;
//    return rowOrigin == rowDestination;
//}
//-(bool) moveLShape{
//    int value = abs(origin - destination);
//    return value == 6 || value == 10 || value == 15 || value == 17 || value == 19;
//}
//
//-(bool) isEatAction{
//    int one = ((ChessModel*)[_listChess objectAtIndex: origin]).type;
//    int two = ((ChessModel*)[_listChess objectAtIndex: destination]).type;
//    return one!=two && two!=CHESS_EMPTY;
//}
//
//-(bool) isMove{
//    return ((ChessModel*)[_listChess objectAtIndex: destination]).tag == Empty;
//}
//
//-(bool) hasPieceAtPosition:(int) position{
//    ChessModel* chess = [_listChess objectAtIndex:position];
//    return chess.tag != Empty;
//}
//
//-(bool) hasPiecesOnStraightVerticalWay{
//    int value = origin - destination;
//    int increament = value>0 ? VERTICAL_UP : VERTICAL_DOWN;
//    int index = origin - increament;
//    while (index>destination) {
//        if([self hasPieceAtPosition:index])
//            return true;
//        index-=increament;
//    }
//    return false;
//}
//
//-(bool) hasPiecesOnStraightHorizontalWay{
//    if(![self moveStraightHorizontal]) return false;
//    int value = origin - destination;
//    int increament = value > 0 ? HORIZONTAL_LEFT : HORIZONTAL_RIGHT;
//    int index = origin + increament;
//    while (index!=destination) {
//        if([self hasPieceAtPosition:index])
//            return true;
//        index+=increament;
//    }
//    return false;
//}
//
//-(bool) hasPiecesOnDiaglonalWay{
//    int value = origin - destination;
//    if(abs(value)%DIAGONAL_R_U_L_D == 0){ //move diagonal right up - left down
//        int increament = value > 0 ? -DIAGONAL_R_U_L_D : DIAGONAL_R_U_L_D;
//        int index = origin + increament;
//        while (index!=destination) {
//            if([self hasPieceAtPosition:index])
//                return true;
//            index+=increament;
//        }
//    }else{//move diagonal left up - right down
//        int increament = value > 0 ? -DIAGONAL_L_U_R_D : DIAGONAL_L_U_R_D;
//        int index = origin + increament;
//        while (index!=destination) {
//            if([self hasPieceAtPosition:index])
//                return true;
//            index+=increament;
//        }
//    }
//    return false;
//}
//
//-(bool) isKing:(int) position{
//    return King == ((ChessModel*)[_listChess objectAtIndex:position]).tag;
//}
//
//-(bool) hasKingOnValidVerticalWay:(int) fromPosition{
//    return false;
//}
//
//-(ChessPiece) hasEnemyOnThisColumnUp:(int) origin team:(int)type{
//    int row = origin/8;
//    ChessModel* enemy;
//    for(int i=row;i<7;i++){
//        enemy = [_listChess objectAtIndex:i*8];
//        if(enemy.type!=type){
//            return enemy.tag;
//        }
//    }
//    return Empty;
//}
//
//-(ChessPiece) hasEnemyOnThisColumnDown:(int) origin team:(int)type{
//    int row = origin/8;
//    ChessModel* enemy;
//    for(int i=row;i>0;i--){
//        enemy = [_listChess objectAtIndex:i*8];
//        if(enemy.type!=type){
//            return enemy.tag;
//        }
//    }
//    return Empty;
//}
//
//-(bool) isChecked{
//    if(_game_turn%2==BELOW_TEAM){
//
//    }else{
//        
//    }
//    return false;
//}
//
//-(bool)isCheckmate{
//    ChessModel* chess = [_listChess objectAtIndex:destination];
//    if(chess.tag == Pawn){
//        if(chess.type == UPPER_TEAM){
//            int eatMoveLeftDown = destination + 7;
//            int eatMoveRightDown = destination + 9;
//            return [self isKing:eatMoveLeftDown] || [self isKing:eatMoveRightDown];
//        }else{
//            int eatMoveLeftUp = destination + 9;
//            int eatMoveRightUp = destination + 7;
//            return [self isKing:eatMoveLeftUp] || [self isKing:eatMoveRightUp];
//        }
//    }else if(chess.tag == Rook){
//        if(chess.type == UPPER_TEAM){
//            return (belowKingLocation.x == chess.location.x && ![self hasPiecesOnStraightHorizontalWay])
//                    || (belowKingLocation.y == chess.location.y && ![self hasPiecesOnStraightVerticalWay]);
//        }else{
//            return (upperKingLocation.x == chess.location.x && ![self hasPiecesOnStraightHorizontalWay])
//                    || (upperKingLocation.y == chess.location.y && ![self hasPiecesOnStraightVerticalWay]);
//        }
//    }else if(chess.tag == Knight){
//        
//    }else if(chess.tag == Bishop){
//        
//    }else if (chess.tag == Queen){
//        
//    }
//    return false;
//}
//
////Chesses movement///
//
////King movements
//-(MoveState) KingTile{
//    MoveState state = Keep;
//    if([self isMove] && ([self moveHorizontal_1] || [self moveVertical_1] || [self moveDiagonal_1])){
//        state = Move;
//    }
//    if([self isEatAction] && ([self moveHorizontal_1] || [self moveVertical_1] || [self moveDiagonal_1])){
//        state = Eat;
//    }
//    return state;
//}
////Queen movements
//-(MoveState) QueenTile {
//    MoveState state = Keep;
//    if([self moveDiagonal]){
//        state = [self BishopTile];
//    }
//    if([self moveStraightVertical] || [self moveStraightHorizontal]){
//        state = [self RookTile];
//    }
//    return state;
//}
////Bishop movements
//-(MoveState) BishopTile{
//    MoveState state = Keep;
//    if([self isMove]){
//        if([self moveDiagonal] && ![self hasPiecesOnDiaglonalWay]){
//            state = Move;
//        }
//    }
//    if([self isEatAction]){
//        if([self moveDiagonal] && ![self hasPiecesOnDiaglonalWay]){
//            state = Eat;
//        }
//    }
//    return state;
//}
////Knight movements
//-(MoveState) KnightTile{
//     MoveState state = Keep;
//    if([self moveLShape] && [self isMove]){
//        state = Move;
//    }
//    if([self moveLShape] && [self isEatAction]){
//        state = Eat;
//    }
//    return state;
//}
////Rook movements
//-(MoveState) RookTile{
//    MoveState state = Keep;
//    if([self isMove] ){
//        if([self moveStraightHorizontal] && ![self hasPiecesOnStraightHorizontalWay]){
//            state = Move;
//        }
//        if([self moveStraightVertical] && ![self hasPiecesOnStraightVerticalWay]){
//            state = Move;
//        }
//    }
//    if([self isEatAction]){
//        if([self moveStraightHorizontal] && ![self hasPiecesOnStraightHorizontalWay]){
//            state = Eat;
//        }
//        if([self moveStraightVertical] && ![self hasPiecesOnStraightVerticalWay]){
//            state = Eat;
//        }
//    }
//    return state;
//}
////Pawn movements
//-(MoveState) PawnTile:(int) type{
//    MoveState state = Keep;
//    // pawns below
//    if(type == BELOW_TEAM){
//        if([self isMove]){
//            if([self isFirstMove:BELOW_TEAM] && [self moveStraightVertical] && ![self hasPiecesOnStraightVerticalWay]){
//                state = Move;
//            }
//            if([self moveStraightUp1]){
//                state = Move;
//            }
//        }
//        if([self isEatAction] && [self moveDiagonalUp1]){
//            state = Eat;
//        }
//    }
//    //pawns upper
//    if(type == UPPER_TEAM){
//        if([self isMove]){
//            if([self isFirstMove:UPPER_TEAM] && [self moveStraightVertical] && ![self hasPiecesOnStraightVerticalWay]){
//                state = Move;
//            }
//            if([self moveStraightDown1]){
//                state = Move;
//            }
//        }
//        if([self isEatAction] && [self moveDiagonalDown1]){
//            state = Eat;
//        }
//    }
//    return state;
//}
//
//@end

