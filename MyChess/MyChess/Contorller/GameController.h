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

@interface GameController : NSObject
-(void) addListChess:(NSMutableArray*) listChess;
-(bool) canMove:(int) from toPosition:(int) position;
@property (nonatomic) int game_turn;//0(upper team) - 1(below team)
@end
