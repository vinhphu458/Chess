//
//  Pawn.m
//  MyChess
//
//  Created by Admin on 10/12/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "Pawn.h"
#import "Queen.h"
#import "Rook.h"
#import "Bishop.h"
#import "Knight.h"

@implementation Pawn {
    NSMutableArray *enPassantMoves;
    bool isEnPassantMove;
    int turnOnEnPassant1, turnOnEnPassant2;
    BOOL hasSaveOnEnPassant1, hasSavedOnEnPassant2;
}

- (id)initWithBoard:(ChessBoard *)board team:(int)team location:(Location *)location {
    self = [super initWithBoard:board team:team location:location];
    if (self) {
        locations = [[NSMutableArray alloc] init];
        enPassantMoves = [[NSMutableArray alloc] init];
        turnOnEnPassant1 = 0;
        turnOnEnPassant2 = 0;
    }
    return self;
}

- (BOOL)moveToLocation:(Location *)location {
    bool ret = [super moveToLocation:location];
    if (ret) {
        isEnPassantMove = [enPassantMoves containsObject:location];
    }
    return ret;
}

- (bool)isEnPassant {
    return isEnPassantMove;
}

- (int)doEnPassant {
    int col = self.location.x;
    int row = self.location.y;
    int removeEnemyPawnIndex = [LOCATION(col, self.team == UPPER_TEAM ? row - 1 : row + 1) toIndex];
    [enPassantMoves removeAllObjects];
    return removeEnemyPawnIndex;
}

- (NSMutableArray *)getValidLocations {
    [super getValidLocations];
    return locations = self.team == UPPER_TEAM
            ? [self getValidUpperPawnLocations]
            : [self getValidBelowPawnLocations];
}

- (NSMutableArray *)getValidLocationsOverlapAlly {
    [super getValidLocationsOverlapAlly];
    return [self getDiagonalLocationsWithOverlapAlly:true];
}

- (NSMutableArray *)getValidBelowPawnLocations {
    int col = self.location.x;
    int row = self.location.y;

    Location *up1 = LOCATION(col, row - 1);
    if ([self.board isEmptyAtLocation:up1]) {
        if ([self isValidLocationOnChecked:up1]) {
            [locations addObject:up1];
        }
        Location *up2 = LOCATION(col, row - 2);
        if (self.moveCount == 0 && [self.board isEmptyAtLocation:up2]) {
            if ([self isValidLocationOnChecked:up2]) {
                [locations addObject:up2];
            }
        }
    }

    [locations addObjectsFromArray:[self getDiagonalLocationsWithOverlapAlly:false]];
    [self addEnPassant];
    return locations;
}

- (NSMutableArray *)getValidUpperPawnLocations {
    int col = self.location.x;
    int row = self.location.y;
    Location *down1 = LOCATION(col, row + 1);
    if ([self.board isEmptyAtLocation:down1]) {
        if ([self isValidLocationOnChecked:down1]) {
            [locations addObject:down1];
        }
        Location *down2 = LOCATION(col, row + 2);
        if (self.moveCount == 0 && [self.board isEmptyAtLocation:down2]) {
            if ([self isValidLocationOnChecked:down1]) {
                [locations addObject:down2];
            }
        }
    }
    [locations addObjectsFromArray:[self getDiagonalLocationsWithOverlapAlly:false]];
    [self addEnPassant];
    return locations;
}

- (NSMutableArray *)getDiagonalLocationsWithOverlapAlly:(bool)overlap {
    NSMutableArray *killEnemyLocations = [[NSMutableArray alloc] init];
    int col = self.location.x;
    int row = self.location.y;
    Location *nextLocation1 = self.team == UPPER_TEAM ? LOCATION(col + 1, row + 1) : LOCATION(col + 1, row - 1);
    Location *nextLocation2 = self.team == UPPER_TEAM ? LOCATION(col - 1, row + 1) : LOCATION(col - 1, row - 1);

    if ([self.board hasEnemyAtLocation:nextLocation1 myTeam:self.team] || overlap) {
        if ([self isValidLocationOnChecked:nextLocation1]) {
            [killEnemyLocations addObject:nextLocation1];
        }
    }

    if ([self.board hasEnemyAtLocation:nextLocation2 myTeam:self.team] || overlap) {
        if ([self isValidLocationOnChecked:nextLocation2]) {
            [killEnemyLocations addObject:nextLocation2];
        }
    }
    return killEnemyLocations;
}

- (void)addEnPassant {
    int fifthRank = self.team == UPPER_TEAM ? 4 : 3;
    int col = self.location.x;
    int row = self.location.y;
    if (row == fifthRank) {
        BaseChess *enemyRight = [self.board chessAtLocation:LOCATION(col + 1, row)];
        BaseChess *enemyLeft = [self.board chessAtLocation:LOCATION(col - 1, row)];
        BOOL hasPawnEnemy1 = ([enemyRight isKindOfClass:[Pawn class]] && enemyRight.team != self.team && ((Pawn *) enemyRight).moveCount == 1);
        if (hasPawnEnemy1) {
            if (!hasSaveOnEnPassant1) {
                turnOnEnPassant1 = self.board.turn_counter;
                hasSaveOnEnPassant1 = true;
            }
            if (![self isSkipTurnEnPassant1]) {
                Location *enPassant1 = LOCATION(col + 1, self.team == UPPER_TEAM ? row + 1 : row - 1);
                if ([self isValidLocationOnChecked:enPassant1]) {
                    [locations addObject:enPassant1];
                    [enPassantMoves addObject:enPassant1];
                }
            } else {
                [enPassantMoves removeAllObjects];
            }
        }
        bool hasPawnEnemy2 = ([enemyLeft isKindOfClass:[Pawn class]] && enemyLeft.team != self.team && ((Pawn *) enemyLeft).moveCount == 1);
        if (hasPawnEnemy2) {
            if (!hasSavedOnEnPassant2) {
                turnOnEnPassant2 = self.board.turn_counter;
                hasSavedOnEnPassant2 = true;
            }
            if (![self isSkipTurnEnPassant2]) {
                Location *enPassant2 = LOCATION(col - 1, self.team == UPPER_TEAM ? row + 1 : row - 1);
                if ([self isValidLocationOnChecked:enPassant2]) {
                    [locations addObject:enPassant2];
                    [enPassantMoves addObject:enPassant2];
                }
            } else {
                [enPassantMoves removeAllObjects];
            }
        }
    }
}

- (BOOL)isSkipTurnEnPassant1 {
    return self.board.turn_counter - turnOnEnPassant1 > 0;
}

- (BOOL)isSkipTurnEnPassant2 {
    return self.board.turn_counter - turnOnEnPassant2 > 0;
}

- (bool)isCanPromotion {
    if (self.team == UPPER_TEAM) {
        return self.location.y == 7;
    } else {
        return self.location.y == 0;
    }
}

- (void)setPromotionTo:(Class)type {
    int index = [self.location toIndex];
    self.board.chessList[index] = [self createChess:type];
}

- (BaseChess *)createChess:(Class)type {
    if ([type isEqual:[Queen class]]) {
        NSLog(@"promo Queen");
        return [[Queen alloc] initWithBoard:self.board team:self.team location:self.location];
    } else if ([type isEqual:[Bishop class]]) {
        NSLog(@"promo Bishop");
        return [[Bishop alloc] initWithBoard:self.board team:self.team location:self.location];
    } else if ([type isEqual:[Rook class]]) {
        NSLog(@"promo Rook");
        return [[Rook alloc] initWithBoard:self.board team:self.team location:self.location];
    } else if ([type isEqual:[Knight class]]) {
        NSLog(@"promo Knight");
        return [[Knight alloc] initWithBoard:self.board team:self.team location:self.location];
    }
    return nil;
}

@end
