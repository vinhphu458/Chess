//
//  ChessBoard.h
//  MyChess
//
//  Created by Admin on 10/12/17.
//  Copyright © 2017 dvphu. All rights reserved.
//
#import "Location.h"
#import "InteractionOnChessEvent.h"

@class BaseChess;
@class Checker;
typedef enum : NSUInteger {
    Keep = 0, //0000 0000
    Move = 1, //0000 0001
    Eat = 2, //0000 0010
    Check = 4,// 0000 0100
    Checkmate = 8,// 0000 1000
    Pawn_Promotion = 16, //0001 0000
    Pawn_EnPassant = 32, // 0010 0000
    Castling = 64, //0100 0000
    Draw = 128 //1000 0000
    //=> Move = 1
    //=> Move & Eat = 3
    //=> Move & Check = 5
    //=> Move & Pawn_Promotion = 17
    //=> Move & Eat & Check = 7
    //=> Move & Eat & Pawn_Promotion = 19
} State;

typedef void (^OnMovedState)(State, NSArray *);

@interface ChessBoard : NSObject <InteractionOnChessEvent>
@property(nonatomic, strong) NSMutableArray *chessList;
@property(nonatomic, assign) int turn_by_team;
@property(nonatomic, assign) int turn_counter;
@property(nonatomic, assign) bool game_end;
@property(nonatomic, strong) NSArray *locations;
@property(nonatomic, strong) Checker *checker;
@property(nonatomic, assign) int kingOnChecked;

- (void)moveChess:(BaseChess *)chess from:(int)origin to:(int)destination;

- (void)setOnChessMovedStatus:(OnMovedState)state;

- (BOOL)isEmptyAtLocation:(Location *)location;

- (BOOL)hasEnemyAtLocation:(Location *)location myTeam:(int)myTeam;

- (BaseChess *)chessAtLocation:(Location *)location;

- (void)setKing:(BaseChess *)king;

- (void)doUndo;

- (void)doRedo;

- (void)doReset;
@end
