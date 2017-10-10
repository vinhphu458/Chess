//
//  GameController.m
//  MyChess
//
//  Created by Admin on 10/4/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "GameController.h"

@interface GameController(){
    NSMutableArray* _listChess;
    int origin;
    int destination;
}
@end
@implementation GameController
-(id)init{
    self = [super init];
    if(self){
        _game_turn = 1;//below team
    }
    return self;
}
-(void)addListChess:(NSMutableArray *)listChess{
    _listChess = listChess;
}
-(void)move:(int)from toPosition:(int)position state:(OnMoveState)state{
    origin = from;
    destination = position;
    ChessModel* chess = ((ChessModel*)[_listChess objectAtIndex:from]);
    NSLog(@"Move: %@ from %d to %d", chess.icon, from, position);
    switch (chess.tag) {
        case King:
            state([self KingTile]);
            break;
        case Queen:
            state([self QueenTile]);
            break;
        case Bishop:
            state([self BishopTile]);
            break;
        case Knight:
            state([self KnightTile]);
            break;
        case Rook:
            state([self RookTile]);
            break;
        case Pawn:
            state([self PawnTile:chess.type]);
            break;
        default:
            state(Keep);
            break;
    }
}

-(void) changeGameTurn{
    _game_turn = 1 - _game_turn;
}

//for pawn
-(bool) moveStraightUp1{
    int value = origin - destination;
    return value>0 && abs(value)==8;
}
-(bool) moveStraightDown1{
    int value = origin - destination;
    return value<0 && abs(value)==8;
}
-(bool) moveDiagonalUp1{
    int value = origin - destination;
    return value>0 && (abs(value)==7 || abs(value)==9);
}
-(bool) moveDiagonalDown1{
    int value = origin - destination;
    return value<0 && (abs(value)==7 || abs(value)==9);
}
-(bool) isFirstMove:(int) type{
    if(type == UPPER_TEAM){
        for(int i = 8;i<16;i++){
            if(origin == i) return true;
        }
    }
    if(type == BELOW_TEAM){
        for(int i = 48;i<56;i++){
            if(origin == i) return true;
        }
    }
    return false;
}
//Other
-(bool) moveHorizontal_1{
    int value = abs(origin - destination);
    int rowOrigin = origin/COLLUMN_SIZE;
    int rowDestination = destination/COLLUMN_SIZE;
    return value == 1 && rowOrigin == rowDestination;
}
-(bool) moveVertical_1{
    int value = origin - destination;
    return abs(value)==8;
}
-(bool) moveDiagonal_1{
    int value = origin - destination;
    return (abs(value)==7 || abs(value)==9);
}

-(bool) moveDiagonal{
    int value = abs(origin - destination);
    return value%7 == 0 || value%9 == 0;
}
-(bool) moveStraightVertical{
    int value = abs(origin - destination);
    return value%8 == 0;
}
-(bool) moveStraightHorizontal{
    int rowOrigin = origin/COLLUMN_SIZE;
    int rowDestination = destination/COLLUMN_SIZE;
    return rowOrigin == rowDestination;
}
-(bool) moveLShape{
    int value = abs(origin - destination);
    return value == 6 || value == 10 || value == 15 || value == 17 || value == 19;
}

-(bool) isEatAction{
    int one = ((ChessModel*)[_listChess objectAtIndex: origin]).type;
    int two = ((ChessModel*)[_listChess objectAtIndex: destination]).type;
    return one!=two && two!=-1;
}

-(bool) isMove{
    return ((ChessModel*)[_listChess objectAtIndex: destination]).tag == Empty;
}

-(bool) hasPieceAtPosition:(int) position{
    ChessModel* chess = [_listChess objectAtIndex:position];
    return chess.tag != Empty;
}

-(bool) hasPiecesOnStraightVerticalWay{
    int value = origin - destination;
    int increament = value>0 ? -8 : 8;
    int index = origin + increament;
    while (index!=destination) {
        if([self hasPieceAtPosition:index])
            return true;
        index+=increament;
    }
    return false;
}

-(bool) hasPiecesOnStraightHorizontalWay{
    if(![self moveStraightHorizontal]) return false;
    int value = origin - destination;
    int increament = value > 0 ? -1 : 1;
    int index = origin + increament;
    while (index!=destination) {
        if([self hasPieceAtPosition:index])
            return true;
        index+=increament;
    }
    return false;
}

-(bool) hasPiecesOnDiaglonalWay{
    int value = origin - destination;
    if(abs(value)%7 == 0){ //move diagonal right up - down left
        int increament = value > 0 ? -7 : 7;
        int index = origin + increament;
        while (index!=destination) {
            if([self hasPieceAtPosition:index])
                return true;
            index+=increament;
        }
    }else{//move diagonal left up - down right
        int increament = value > 0 ? -9 : 9;
        int index = origin + increament;
        while (index!=destination) {
            if([self hasPieceAtPosition:index])
                return true;
            index+=increament;
        }
    }
    return false;
}

//King movements
-(MoveState) KingTile{
    if([self isMove] && ([self moveHorizontal_1] || [self moveVertical_1] || [self moveDiagonal_1])){
        return Move;
    }
    if([self isEatAction] && ([self moveHorizontal_1] || [self moveVertical_1] || [self moveDiagonal_1])){
        return Eat;
    }
    return Keep;
}
//Queen movements
-(MoveState) QueenTile {
    if([self moveDiagonal]){
        return [self BishopTile];
    }
    if([self moveStraightVertical] || [self moveStraightHorizontal]){
        return [self RookTile];
    }
    return Keep;
}
//Bishop movements
-(MoveState) BishopTile{
    if([self isMove]){
        if([self moveDiagonal] && ![self hasPiecesOnDiaglonalWay]){
            return Move;
        }
    }
    if([self isEatAction]){
        if([self moveDiagonal] && ![self hasPiecesOnDiaglonalWay]){
            return Eat;
        }
    }
    return Keep;
}
//Knight movements
-(MoveState) KnightTile{
    if([self moveLShape] && [self isMove]){
        return Move;
    }
    if([self moveLShape] && [self isEatAction]){
        return Eat;
    }
    return Keep;
}
//Rook movements
-(MoveState) RookTile{
    if([self isMove] ){
        if([self moveStraightHorizontal] && ![self hasPiecesOnStraightHorizontalWay]){
            return Move;
        }
        if([self moveStraightVertical] && ![self hasPiecesOnStraightVerticalWay]){
            return Move;
        }
    }
    if([self isEatAction]){
        if([self moveStraightHorizontal] && ![self hasPiecesOnStraightHorizontalWay]){
            return Eat;
        }
        if([self moveStraightVertical] && ![self hasPiecesOnStraightVerticalWay]){
            return Eat;
        }
    }
    return Keep;
}
//Pawn movements
-(MoveState) PawnTile:(int) type{
    // pawns below
    if(type == BELOW_TEAM){
        if([self isFirstMove:BELOW_TEAM] && [self moveStraightVertical] && ![self hasPiecesOnStraightVerticalWay] && [self isMove]){
            return Move;
        }
        if([self moveStraightUp1] && [self isMove]){
            return Move;
        }
        if([self isEatAction] && [self moveDiagonalUp1]){
            return Eat;
        }
        return Keep;
    }
    //pawns upper
    if(type == UPPER_TEAM){
        if([self isFirstMove:UPPER_TEAM] && [self moveStraightVertical] && ![self hasPiecesOnStraightVerticalWay] && [self isMove]){
            return Move;
        }
        if([self moveStraightDown1] && [self isMove]){
            return Move;
        }
        if([self isEatAction] && [self moveDiagonalDown1]){
            return Eat;
        }
        return Keep;
    }
    return Keep;
}

@end
