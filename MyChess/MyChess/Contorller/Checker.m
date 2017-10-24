//
//  Checker.m
//  MyChess
//
//  Created by Admin on 10/11/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "Checker.h"
#import "King.h"
#import "Pawn.h"

@implementation Checker {
    ChessBoard *_board;
    NSMutableArray *lastTeamMoves;
    NSMutableArray *defendMoves;
    NSMutableArray *wayForCheck;
    NSMutableArray *wayForCheckCanCut;
    BaseChess *_offense;
    BaseChess *checker;
    BaseChess *upperKing;
    BaseChess *belowKing;
}
- (id)initWithBoard:(ChessBoard *)board {
    self = [super init];
    if (self) {
        _board = board;
        _validKingMovesOnChecked = [NSMutableSet set];
        _validAllyMovesOnChecked = [NSMutableSet set];
    }
    return self;
}

- (void)setLastEnemyMoved:(BaseChess *)chess {
    NSLog(@"Attacker: %@ move to (%d, %d)", [chess toString], chess.location.x, chess.location.y);
    _offense = chess;
    [self getLastTeamMoves:false];
}

- (bool)isCheck {
    return [self isCheckAtLocation:[self getDefendKingLocation]];
}

- (bool)isCheckAtLocation:(Location *)location {
    bool ret = [lastTeamMoves containsObject:location];
    return ret;
}

//save king location when moved
- (void)setKing:(BaseChess *)king {
    if (king.team == UPPER_TEAM) {
        upperKing = king;
    } else {
        belowKing = king;
    }
}

- (bool)isCheckmate {
    //No more move
    int allyMoves = [self getValidAllyMovesOnChecked].count;
    int kingMoves = [self getValidKingMovesOnChecked].count;
    return kingMoves == 0 && allyMoves == 0;
}

- (NSMutableSet *)getValidAllyMovesOnChecked {
    [_validAllyMovesOnChecked removeAllObjects];
    wayForCheckCanCut = [self wayForCheckCanCut:checker king:[self getDefendKingLocation]];
    [self getDefendTeamMoves];
    for (Location *move in defendMoves) {
        if ([wayForCheckCanCut containsObject:move]) {
            NSLog(@"Ally can move to (%d, %d)", move.x, move.y);
            [_validAllyMovesOnChecked addObject:move];
        }
    }
    NSLog(@"Total ally move: %d", _validAllyMovesOnChecked.count);
    return _validAllyMovesOnChecked;
}

- (NSMutableSet *)getValidKingMovesOnChecked {
    [_validKingMovesOnChecked removeAllObjects];
    NSMutableArray *kingMoves = [[self getDefendKing] getValidLocations];
    [self getLastTeamMoves:true];
    [lastTeamMoves addObjectsFromArray:wayForCheck];
    for (Location *move in kingMoves) {
        if (![lastTeamMoves containsObject:move]) {
            if (![self isCheckAtLocation:move]) {
                NSLog(@"King can move to (%d, %d)", move.x, move.y);
                [_validKingMovesOnChecked addObject:move];
            }
        }
    }
    NSLog(@"Total King move: %d", _validKingMovesOnChecked.count);
    return _validKingMovesOnChecked;
}

- (BaseChess *)getDefendKing {
    return _offense.team == UPPER_TEAM ? belowKing : upperKing;
}

- (Location *)getDefendKingLocation {
    return _offense.team == UPPER_TEAM ? belowKing.location : upperKing.location;
}

- (void)getLastTeamMoves:(bool)overlapAlly {
    lastTeamMoves = [[NSMutableArray alloc] init];
    int enemy = _offense.team;
    NSMutableArray *listChessNoBlank = [[NSMutableArray alloc] initWithArray:_board.chessList];
    [listChessNoBlank removeObject:[NSNull null]];
    for (BaseChess *enemyChess in listChessNoBlank) {
        if (enemyChess.team == enemy && ![enemyChess isKindOfClass:[King class]]) {
            if ([enemyChess isKindOfClass:[Pawn class]]) {
                NSMutableArray *moves = [((Pawn *) enemyChess) getDiagonalLocationsWithOverlapAlly:true];
                [lastTeamMoves addObjectsFromArray:moves];
            } else {
                NSMutableArray *moves = overlapAlly ? [enemyChess getValidLocationsOverlapAlly] : [enemyChess getValidLocations];
                if ([moves containsObject:[self getDefendKingLocation]]) {
                    checker = enemyChess;
                    [self wayForCheck:checker king:[self getDefendKingLocation]];
                }
                [lastTeamMoves addObjectsFromArray:moves];
            }
        }
    }
}

- (void)getDefendTeamMoves {
    defendMoves = [[NSMutableArray alloc] init];
    int enemy = _offense.team;
    NSMutableArray *listChessNoBlank = [[NSMutableArray alloc] initWithArray:_board.chessList];
    [listChessNoBlank removeObject:[NSNull null]];
    for (BaseChess *enemyChess in listChessNoBlank) {
        if (enemyChess.team != enemy && ![enemyChess isKindOfClass:[King class]]) {
            [defendMoves addObjectsFromArray:[enemyChess getValidLocations]];
        }
    }
}

- (NSMutableArray *)wayForCheckCanCut:(BaseChess *)attacker king:(Location *)kingLocation {
    wayForCheckCanCut = [[NSMutableArray alloc] init];
    int upDown = kingLocation.y - attacker.location.y;
    int leftRight = kingLocation.x - attacker.location.x;
    int incrementX = leftRight == 0 ? 0 : leftRight / abs(leftRight);
    int incrementY = upDown == 0 ? 0 : upDown / abs(upDown);
    [self addLocation:attacker.location to:kingLocation incrementX:incrementX incrementY:incrementY intoList:wayForCheckCanCut];
    return wayForCheckCanCut;
}

- (NSMutableArray *)wayForCheck:(BaseChess *)attacker king:(Location *)kingLocation {
    wayForCheck = [[NSMutableArray alloc] init];
    int upDown = kingLocation.y - attacker.location.y;
    int leftRight = kingLocation.x - attacker.location.x;
    int incrementX = leftRight == 0 ? 0 : leftRight / abs(leftRight);
    int incrementY = upDown == 0 ? 0 : upDown / abs(upDown);
    [self addCheckWay:attacker.location incrementX:incrementX incrementY:incrementY intoList:wayForCheck];
    return wayForCheck;
}

- (void)addLocation:(Location *)from to:(Location *)king incrementX:(int)incrementX incrementY:(int)incrementY intoList:(NSMutableArray *)arr {
    [arr addObject:from];
    Location *newLocation = LOCATION(from.x + incrementX, from.y + incrementY);
    if (![newLocation isValid] || [newLocation isEqual:king]) return;
    [self addLocation:newLocation to:king incrementX:incrementX incrementY:incrementY intoList:arr];
}

- (void)addCheckWay:(Location *)from incrementX:(int)incrementX incrementY:(int)incrementY intoList:(NSMutableArray *)arr {
    if (![from isValid]) return;
    [arr addObject:from];
    Location *newLocation = LOCATION(from.x + incrementX, from.y + incrementY);
    [self addCheckWay:newLocation incrementX:incrementX incrementY:incrementY intoList:arr];
}

@end
