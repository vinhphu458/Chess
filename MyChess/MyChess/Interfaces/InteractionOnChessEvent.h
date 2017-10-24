//
//  InteractionOnChessEvent.h
//  MyChess
//
//  Created by Admin on 10/6/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InteractionOnChessEvent <NSObject>
- (void)onSelectedChess:(int)position;

- (void)onDeselectedChess:(int)position;

- (void)onMoveChessToPosition:(int)position;
@end
