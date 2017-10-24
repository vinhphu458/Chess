//
// Created by Admin on 10/19/17.
// Copyright (c) 2017 dvphu. All rights reserved.
//

#import "Movement.h"

@implementation Movement
- (id)initWithA:(BaseChess *)A B:(BaseChess *)B from:(int) from to:(int) to{
    self = [super init];
    if(self){
        _from = from;
        _to = to;
        _A = A;
        _B = B;
    }
    return self;
}
@end