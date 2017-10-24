//
//  Checker.h
//  MyChess
//
//  Created by Admin on 10/11/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChessBoard.h"
#import "BaseChess.h"

@interface Checker : NSObject
- (id)initWithBoard:(ChessBoard *)board;

- (bool)isCheck;

- (bool)isCheckmate;

- (bool)isCheckAtLocation:(Location *)location;

- (void)setLastEnemyMoved:(BaseChess *)chess;

- (void)setKing:(BaseChess *)king;

- (Location *)getDefendKingLocation;

@property(nonatomic, strong) NSMutableSet *validAllyMovesOnChecked;
@property(nonatomic, strong) NSMutableSet *validKingMovesOnChecked;

@end
