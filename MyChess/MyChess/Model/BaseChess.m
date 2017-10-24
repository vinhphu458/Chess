//
//  Moveable.m
//  MyChess
//
//  Created by Admin on 10/12/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "BaseChess.h"
#import "Checker.h"

@implementation BaseChess
- (id)initWithBoard:(ChessBoard *)board team:(int)team location:(Location *)location {
    self = [super init];
    if (self) {
        locations = [[NSMutableArray alloc] init];
        _board = board;
        _team = team;
        _location = location;
        _icon = CHESS_ICON(_team == UPPER_TEAM ? WHITE : BLACK, [NSStringFromClass([self class]) lowercaseString]);
        _moveCount = 0;
    }
    return self;
}

- (BOOL)moveToLocation:(Location *)location {
    if ([self isValidDestination:location]) {
        [self.board moveChess:self from:[_location toIndex] to:[location toIndex]];
        _location = location;
        _moveCount++;
        return true;
    }
    return false;
}

- (BOOL)isValidDestination:(Location *)destination {
    return [locations containsObject:destination];//move success
}

- (void)setLocationX:(int)x andY:(int)y {
    _location.x = x;
    _location.y = y;
}

- (NSMutableArray *)getValidLocations {
    if (locations.count > 0) {
        [locations removeAllObjects];
    }
    return nil;
}

- (NSMutableArray *)getValidLocationsOverlapAlly {
    if (locations.count > 0) {
        [locations removeAllObjects];
    }
    return nil;
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"%@_%@", _team == UPPER_TEAM ? @"W" : @"B", NSStringFromClass([self class])];
}

- (bool)isValidLocationOnChecked:(Location *)location {
    if (self.board.kingOnChecked == self.team) {
        NSMutableSet *moves = [self.board.checker validAllyMovesOnChecked];
        return moves.count == 0 || [moves containsObject:location];
    }
    return true;
}

@end
