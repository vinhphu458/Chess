//
//  Bishop.m
//  MyChess
//
//  Created by Admin on 10/12/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "Bishop.h"
#import "Checker.h"

@implementation Bishop
- (NSMutableArray *)getValidLocations {
    [super getValidLocations];
    [self addLocation:self.location incrementX:1 incrementY:1 overlapAlly:false];
    [self addLocation:self.location incrementX:-1 incrementY:-1 overlapAlly:false];
    [self addLocation:self.location incrementX:1 incrementY:-1 overlapAlly:false];
    [self addLocation:self.location incrementX:-1 incrementY:1 overlapAlly:false];
    return locations;
}

- (NSMutableArray *)getValidLocationsOverlapAlly {
    [super getValidLocationsOverlapAlly];
    [self addLocation:self.location incrementX:1 incrementY:1 overlapAlly:true];
    [self addLocation:self.location incrementX:-1 incrementY:-1 overlapAlly:true];
    [self addLocation:self.location incrementX:1 incrementY:-1 overlapAlly:true];
    [self addLocation:self.location incrementX:-1 incrementY:1 overlapAlly:true];
    return locations;
}

- (void)addLocation:(Location *)current incrementX:(int)incrementX incrementY:(int)incrementY overlapAlly:(bool) canOverlapAlly {
    Location *newLocation = LOCATION(current.x + incrementX, current.y + incrementY);
    if([newLocation isValid]){
        if ([self isValidLocationOnChecked:newLocation]) {
            if ([self.board hasEnemyAtLocation:newLocation myTeam:self.team]) {
                [locations addObject:newLocation];
                return;
            }
            if(canOverlapAlly){
                if(![Utils isNull:[self.board chessAtLocation:newLocation]]){
                    if ([self.board chessAtLocation:newLocation].team == self.team) {
                        [locations addObject:newLocation];
                        return;
                    }
                }
            } else{
                if ([self.board isEmptyAtLocation:newLocation]) {
                    [locations addObject:newLocation];
                } else {
                    return;
                }
            }
        }
        [self addLocation:newLocation incrementX:incrementX incrementY:incrementY overlapAlly:canOverlapAlly];
    }
}
@end
