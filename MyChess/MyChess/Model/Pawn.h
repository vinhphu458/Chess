//
//  Pawn.h
//  MyChess
//
//  Created by Admin on 10/12/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "BaseChess.h"

@interface Pawn : BaseChess
- (bool)isCanPromotion;

- (bool)isEnPassant;

- (void)setPromotionTo:(Class)type;

- (int)doEnPassant;

-(NSMutableArray *)getDiagonalLocationsWithOverlapAlly:(bool) overlap;
@end
