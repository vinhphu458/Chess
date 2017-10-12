//
//  GameController.h
//  MyChess
//
//  Created by Admin on 10/4/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChessModel.h"
#import "Constant.h"

typedef enum: NSUInteger {
    Keep = 0, //0000 0000
    Move = 1, //0000 0001
    Eat = 2, //0000 0010
    Checkmate = 4,// 0000 0100
    Pawn_Promotion = 8 //0000 1000
    //=> Move = 1
    //=> Move & Eat = 3
    //=> Move & Check = 5
    //=> Move & Pawn_Promotion = 9
    //=> Move & Eat & Check = 7
    //=> Move & Eat & Pawn_Promotion = 11
} MoveState;

typedef void (^OnMoveState)(MoveState);

@interface GameController : NSObject
@property (nonatomic) int game_turn;//0(below team) - 1(upper team)

-(void) addListChess:(NSMutableArray*) listChess;
-(void) setStateChangedListener:(OnMoveState)state;
-(void) move:(int) from toPosition:(int) position;
-(void) changeGameTurn;
@end
