//
// Created by Admin on 10/19/17.
// Copyright (c) 2017 dvphu. All rights reserved.
//

#import "BaseChess.h"

@interface Movement : NSObject
- (id)initWithA:(BaseChess *)A B:(BaseChess *)B from:(int) from to:(int) to;
@property (nonatomic, strong) BaseChess *A;
@property (nonatomic, strong) BaseChess * B;
@property (nonatomic, assign) int from;
@property (nonatomic, assign) int to;
@end