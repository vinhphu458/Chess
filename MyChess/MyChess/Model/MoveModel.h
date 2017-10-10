//
//  MoveModel.h
//  MyChess
//
//  Created by Admin on 10/10/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    Move, Eat, Keep
} MoveState;

@interface MoveModel : NSObject
@property (nonatomic, assign) int fromPosition;
@property (nonatomic, assign) int toPosition;
@property (nonatomic, assign) int state;
-(void) setFromPosition:(int)fromPosition toPosition:(int) toPosition moveState:(MoveState) state;
@end
