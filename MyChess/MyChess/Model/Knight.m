//
//  Knight.m
//  MyChess
//
//  Created by Admin on 10/12/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "Knight.h"

@implementation Knight
- (NSMutableArray *)getValidLocations {
    [super getValidLocations];
    int col = self.location.x;
    int row = self.location.y;

    [self addLocation:LOCATION(col + 1, row + 2) canOverlapAlly:false];
    [self addLocation:LOCATION(col + 1, row - 2) canOverlapAlly:false];
    [self addLocation:LOCATION(col - 1, row + 2) canOverlapAlly:false];
    [self addLocation:LOCATION(col - 1, row - 2) canOverlapAlly:false];

    [self addLocation:LOCATION(col + 2, row + 1) canOverlapAlly:false];
    [self addLocation:LOCATION(col + 2, row - 1) canOverlapAlly:false];
    [self addLocation:LOCATION(col - 2, row + 1) canOverlapAlly:false];
    [self addLocation:LOCATION(col - 2, row - 1) canOverlapAlly:false];

    return locations;
}

- (NSMutableArray *)getValidLocationsOverlapAlly {
    [super getValidLocationsOverlapAlly];
    int col = self.location.x;
    int row = self.location.y;

    [self addLocation:LOCATION(col + 1, row + 2) canOverlapAlly:true];
    [self addLocation:LOCATION(col + 1, row - 2) canOverlapAlly:true];
    [self addLocation:LOCATION(col - 1, row + 2) canOverlapAlly:true];
    [self addLocation:LOCATION(col - 1, row - 2) canOverlapAlly:true];

    [self addLocation:LOCATION(col + 2, row + 1) canOverlapAlly:true];
    [self addLocation:LOCATION(col + 2, row - 1) canOverlapAlly:true];
    [self addLocation:LOCATION(col - 2, row + 1) canOverlapAlly:true];
    [self addLocation:LOCATION(col - 2, row - 1) canOverlapAlly:true];

    return locations;
}

- (void)addLocation:(Location *)location canOverlapAlly:(bool)overlapAlly {
    if ([self isValidLocationOnChecked:location]) {
        if ([self.board isEmptyAtLocation:location]) {
            [locations addObject:location];
        }
        if (overlapAlly && ![Utils isNull:[self.board chessAtLocation:location]]) {
            if ([self.board chessAtLocation:location].team == self.team) {
                [locations addObject:location];
            }
        }
        if ([self.board hasEnemyAtLocation:location myTeam:self.team]) {
            [locations addObject:location];
        }
    }
}
@end
