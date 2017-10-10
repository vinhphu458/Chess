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
#import "MoveModel.h"

typedef void (^OnMoveState)(MoveState);

@interface GameController : NSObject
-(void) addListChess:(NSMutableArray*) listChess;
-(void) move:(int) from toPosition:(int) position state: (OnMoveState)state;
@property (nonatomic) int game_turn;//0(upper team) - 1(below team)
-(void) changeGameTurn;
@end
