//
//  King.m
//  MyChess
//
//  Created by Admin on 10/12/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "King.h"
#import "Rook.h"
#import "Checker.h"

@implementation King {
    Rook *_leftRook;
    Rook *_rightRook;
    bool isDoCastling;
}
- (id)initWithBoard:(ChessBoard *)board team:(int)team location:(Location *)location {
    self = [super initWithBoard:board team:team location:location];
    if (self) {
        [self.board setKing:self];
    }
    return self;
}

- (void)setLeftRook:(BaseChess *)leftRook andRightRook:(BaseChess *)rightRook {
    _leftRook = (Rook *) leftRook;
    _rightRook = (Rook *) rightRook;
}

- (BOOL)moveToLocation:(Location *)location {
    bool ret = [super moveToLocation:location];
    if (ret) {
        [self.board setKing:self];
        if ([location isEqual:[self castlingFarLocation]]) {
            isDoCastling = [self doCastlingFar];
        }
        if ([location isEqual:[self castlingNearLocation]]) {
            isDoCastling = [self doCastlingNear];
        }
    }
    return ret;
}

- (NSMutableArray *)getValidLocations {
    [super getValidLocations];
    int col = self.location.x;
    int row = self.location.y;
    [self addLocation:LOCATION(col, row + 1) canOverlapAlly:false];
    [self addLocation:LOCATION(col, row - 1) canOverlapAlly:false];//

    [self addLocation:LOCATION(col + 1, row + 1) canOverlapAlly:false];//
    [self addLocation:LOCATION(col + 1, row - 1) canOverlapAlly:false];//
    [self addLocation:LOCATION(col - 1, row - 1) canOverlapAlly:false];
    [self addLocation:LOCATION(col - 1, row + 1) canOverlapAlly:false];

    [self addLocation:LOCATION(col + 1, row) canOverlapAlly:false];
    [self addLocation:LOCATION(col - 1, row) canOverlapAlly:false];

    [self addCastling];

    return locations;
}

- (NSMutableArray *)getValidLocationsOverlapAlly {
    [super getValidLocationsOverlapAlly];
    int col = self.location.x;
    int row = self.location.y;
    [self addLocation:LOCATION(col, row + 1) canOverlapAlly:true];
    [self addLocation:LOCATION(col, row - 1) canOverlapAlly:true];

    [self addLocation:LOCATION(col + 1, row + 1) canOverlapAlly:true];
    [self addLocation:LOCATION(col + 1, row - 1) canOverlapAlly:true];
    [self addLocation:LOCATION(col - 1, row - 1) canOverlapAlly:true];
    [self addLocation:LOCATION(col - 1, row + 1) canOverlapAlly:true];

    [self addLocation:LOCATION(col + 1, row) canOverlapAlly:true];
    [self addLocation:LOCATION(col - 1, row) canOverlapAlly:true];
    return locations;
}

- (void)addLocation:(Location *)nextLocation canOverlapAlly:(bool) overlapAlly {
    if ([self.board.checker isCheckAtLocation:nextLocation])
        return;
    if ([self.board hasEnemyAtLocation:nextLocation myTeam:self.team]) {
        [locations addObject:nextLocation];
    }
    if ([self.board isEmptyAtLocation:nextLocation]) {
        [locations addObject:nextLocation];
    }
    if (overlapAlly && ![Utils isNull:[self.board chessAtLocation:nextLocation]]) {
        if ([self.board chessAtLocation:nextLocation].team == self.team) {
            [locations addObject:nextLocation];

        }
    }
}

- (void)addCastling {
    if (self.moveCount > 0) return;
    if (_leftRook.moveCount > 0 && _rightRook.moveCount > 0) return;
    if (self.location.y != _leftRook.location.y || self.location.y != _rightRook.location.y) return;
    if (self.onCheck) return;

    if ([self isEmptyPiecesToLeftRook]) {
        if (![self.board.checker isCheckAtLocation:[self castlingFarLocation]]) {
            NSLog(@"Can castling far");
            [locations addObject:[self castlingFarLocation]];
        } else {
            NSLog(@"Check on castling far");
        }
    }
    if ([self isEmptyPiecesToRightRook]) {
        if (![self.board.checker isCheckAtLocation:[self castlingNearLocation]]) {
            NSLog(@"Can castling near");
            [locations addObject:[self castlingNearLocation]];
        } else {
            NSLog(@"Check on castling near");
        }
    }
}

- (bool)doCastling {
    return isDoCastling;
}

- (BOOL)doCastlingFar {
    //King has been moved
    NSLog(@"Do castling far");
    [_leftRook moveToLocation:self.team == UPPER_TEAM ? LOCATION(3, 0) : LOCATION(3, 7)];
    return true;
}

- (BOOL)doCastlingNear {
    //King has been moved
    NSLog(@"Do castling near");
    [_rightRook moveToLocation:self.team == UPPER_TEAM ? LOCATION(5, 0) : LOCATION(5, 7)];
    return true;
}

- (Location *)castlingFarLocation {
    if (self.team == UPPER_TEAM) {
        return LOCATION(2, 0);
    } else {
        return LOCATION(2, 7);
    }
}

- (Location *)castlingNearLocation {
    if (self.team == UPPER_TEAM) {
        return LOCATION(6, 0);
    } else {
        return LOCATION(6, 7);
    }
}

- (bool)isEmptyPiecesToLeftRook {
    int col = self.location.x;
    int row = self.location.y;
    for (int i = col - 1; i > _leftRook.location.x; i--) {
        if (![self.board isEmptyAtLocation:LOCATION(i, row)])
            return false;
    }
    return true;
}

- (bool)isEmptyPiecesToRightRook {
    int col = self.location.x;
    int row = self.location.y;
    for (int i = col + 1; i < _rightRook.location.x; i++) {
        if (![self.board isEmptyAtLocation:LOCATION(i, row)])
            return false;
    }
    return true;
}

@end
