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
        chess.position = i;
        [_chessList addObject:chess];
    }
    return self;
}

-(void)addChess:(OnChessAdded)onChessAdded atPosition:(int)position{
    if(position < 16){
        onChessAdded([self addBlackChess:position]);
        return;
    }
    if(position > 47){
        onChessAdded([self addWhiteChess:position]);
        return;
    }
    ChessModel* chess = [[ChessModel alloc] init];
    chess.tag = Empty;
    chess.position = position;
    [_chessList setObject:chess atIndexedSubscript:position];
}

-(ChessModel*)addWhiteChess:(int) position {
    ChessModel *chess = [_chessList objectAtIndex:position];
    chess.position = position;
    chess.type = 1;
    
    if(position == 56 || position==63){
        chess.tag = Rook;
        chess.icon = wROOK;
    }else if(position==57 || position==62){
        chess.tag = Knight;
        chess.icon = wKNIGHT;
    }else if(position==58 || position==61){
        chess.tag = Bishop;
        chess.icon = wBISHOP;
    }else if(position==59){
        chess.tag = Queen;
        chess.icon = wQUEEN;
    }else if(position==60){
        chess.tag = King;
        chess.icon = wKING;
    }else{
        chess.tag = Pawn;
        chess.icon = wPAWN;
    }
    [_chessList setObject:chess atIndexedSubscript:position];
    return chess;
}

-(ChessModel*) addBlackChess:(int) position {
    ChessModel *chess = [_chessList objectAtIndex:position];
    chess.position = position;
    chess.type = 2;
    
    if(position == 0 || position==7){
        chess.tag = Rook;
        chess.icon = bROOK;
    }else if(position==1 || position==6){
        chess.tag = Knight;
        chess.icon = bKNIGHT;
    }else if(position==2 || position==5){
        chess.tag = Bishop;
        chess.icon = bBISHOP;
    }else if(position==3){
        chess.tag = King;
        chess.icon = bKING;
    }else if(position==4){
        chess.tag = Queen;
        chess.icon = bQUEEN;
    }else{
        chess.tag = Pawn;
        chess.icon = bPAWN;
    }
    
    [_chessList setObject:chess atIndexedSubscript:position];
    return chess;
}

-(void)removeChess:(int) position{
    
}

-(void)replaceChess:(int)position with:(ChessModel *)chess{
    
}

- (void)onDeselectedChess:(int)position {
    NSLog(@"Model: onDeselectedChess %d", position);
    
}

- (void)onMoveChessToPositon:(int)position {
    NSLog(@"Model: onMoveChessToPositon %d", position);
    destinationChess = [_chessList objectAtIndex:position];
    [_chessList setObject:originChess atIndexedSubscript:position];
    [_chessList setObject:destinationChess atIndexedSubscript:selectedPosition];
    
    originChess =nil;
    destinationChess =nil;
    
    [self printChessBoard];
}

- (void)onSelectedChess:(int)position {
    NSLog(@"Model: onSelectedChess %d", position);
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
