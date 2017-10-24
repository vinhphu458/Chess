//
//  King.h
//  MyChess
//
//  Created by Admin on 10/12/17.
//  Copyright © 2017 dvphu. All rights reserved.
//
#import "BaseChess.h"

@interface King : BaseChess
@property (nonatomic, assign) bool onCheck;
-(void) setLeftRook:(BaseChess*) leftRook andRightRook:(BaseChess*) rightRook;
-(bool) doCastling;
@end
