//
//  MoveModel.m
//  MyChess
//
//  Created by Admin on 10/10/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "MoveModel.h"

@implementation MoveModel
-(void)setFromPosition:(int)fromPosition toPosition:(int)toPosition moveState:(MoveState)state{
    _fromPosition = fromPosition;
    _toPosition = toPosition;
    _state = state;
}
@end
