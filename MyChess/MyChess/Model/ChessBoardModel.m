//
//  ChessBoardModel.m
//  MyChess
//
//  Created by Admin on 10/3/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "ChessBoardModel.h"
@interface ChessBoardModel(){
    ChessModel* originChess;
    ChessModel* destinationChess;
    int selectedPosition;
}

@end

@implementation ChessBoardModel
-(id)init{
    self = [super init];
    _chessList  = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < CHESS_BOARD_SIZE; i++){
        ChessModel* chess = [[ChessModel alloc] init];
        chess.tag = Empty;
        chess.location.x = i%COLLUMN_SIZE;
        chess.location.y = i/COLLUMN_SIZE;
        [_chessList addObject:chess];
    }
    return self;
}

-(void)addChess:(OnChessAdded)onChessAdded atPosition:(int)position{
    if(position < 16){
        onChessAdded([self addUpperChess:position color:BLACK]);
        return;
    }
    if(position > 47){
        onChessAdded([self addBelowChess:position color:WHITE]);
        return;
    }
    ChessModel* chess = [[ChessModel alloc] init];
    chess.tag = Empty;
    chess.location.x = position%COLLUMN_SIZE;
    chess.location.y = position/COLLUMN_SIZE;
    [_chessList setObject:chess atIndexedSubscript:position];
}



-(ChessModel*)addBelowChess:(int) position color:(NSString*)color {
    ChessModel *chess = [_chessList objectAtIndex:position];
    chess.location.x = position%COLLUMN_SIZE;
    chess.location.y = position/COLLUMN_SIZE;
    chess.type = BELOW_TEAM;
    if(position == 56 || position==63){
        chess.tag = Rook;
        chess.icon = CHESS_ICON(color, ROOK);
    }else if(position==57 || position==62){
        chess.tag = Knight;
        chess.icon = CHESS_ICON(color, KNIGHT);
    }else if(position==58 || position==61){
        chess.tag = Bishop;
        chess.icon = CHESS_ICON(color, BISHOP);
    }else if(position==59){
        chess.tag = Queen;
        chess.icon = CHESS_ICON(color, QUEEN);
    }else if(position==60){
        chess.tag = King;
        chess.icon = CHESS_ICON(color, KING);
    }else{
        chess.tag = Pawn;
        chess.icon = CHESS_ICON(color, PAWN);
    }
    
    [_chessList setObject:chess atIndexedSubscript:position];
    return chess;
}

-(ChessModel*) addUpperChess:(int) position color:(NSString*)color {
    ChessModel *chess = [_chessList objectAtIndex:position];
    chess.location.x = position%COLLUMN_SIZE;
    chess.location.y = position/COLLUMN_SIZE;
    chess.type = UPPER_TEAM;
    
    if(position == 0 || position==7){
        chess.tag = Rook;
        chess.icon = CHESS_ICON(color, ROOK);
    }else if(position==1 || position==6){
        chess.tag = Knight;
        chess.icon = CHESS_ICON(color, KNIGHT);
    }else if(position==2 || position==5){
        chess.tag = Bishop;
        chess.icon = CHESS_ICON(color, BISHOP);
    }else if(position==3){
        chess.tag = Queen;
        chess.icon = CHESS_ICON(color, QUEEN);
    }else if(position==4){
        chess.tag = King;
        chess.icon = CHESS_ICON(color, KING);
    }else{
        chess.tag = Pawn;
        chess.icon = CHESS_ICON(color, PAWN);
    }
    [_chessList setObject:chess atIndexedSubscript:position];
    return chess;
}

- (void)onDeselectedChess:(int)position {
    
}

- (void)onMoveChessToPositon:(int)position {    
    destinationChess = [_chessList objectAtIndex:position];
    [_chessList setObject:originChess atIndexedSubscript:position];
    [_chessList setObject:destinationChess atIndexedSubscript:selectedPosition];
    originChess = nil;
    destinationChess = nil;
    
//    MoveModel* movement = [[MoveModel alloc] init];
//    [movement setFromPosition:selectedPosition toPosition:position moveState:Move];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"chess" object:movement];
    
    [self printChessBoard];
}

-(void) onDefeatEnemyAtPosition:(int)position{
    destinationChess = [_chessList objectAtIndex:position];
    [destinationChess setEmpty];
    
    [_chessList setObject:originChess atIndexedSubscript:position];
    [_chessList setObject:destinationChess atIndexedSubscript:selectedPosition];
    originChess = nil;
    destinationChess = nil;
    
//    MoveModel* movement = [[MoveModel alloc] init];
//    [movement setFromPosition:selectedPosition toPosition:position moveState:Eat];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"chess" object:movement];
    [self printChessBoard];
}

- (void)onSelectedChess:(int)position {
    selectedPosition = position;
    originChess = [_chessList objectAtIndex:position];
}

-(void) printChessBoard{
    for(int i=0;i<COLLUMN_SIZE;i++){
        ChessModel* chess1 = [_chessList objectAtIndex:0 + i*8];
        ChessModel* chess2 = [_chessList objectAtIndex:1 + i*8];
        ChessModel* chess3 = [_chessList objectAtIndex:2 + i*8];
        ChessModel* chess4 = [_chessList objectAtIndex:3 + i*8];
        ChessModel* chess5 = [_chessList objectAtIndex:4 + i*8];
        ChessModel* chess6 = [_chessList objectAtIndex:5 + i*8];
        ChessModel* chess7 = [_chessList objectAtIndex:6 + i*8];
        ChessModel* chess8 = [_chessList objectAtIndex:7 + i*8];
        NSLog(@"%@ %@ %@ %@ %@ %@ %@ %@",chess1.icon,chess2.icon,chess3.icon,chess4.icon,chess5.icon,chess6.icon,chess7.icon,chess8.icon );
    }
}

@end
