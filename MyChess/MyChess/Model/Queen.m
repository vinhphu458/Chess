//
//  Queen.m
//  MyChess
//
//  Created by Admin on 10/12/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "Queen.h"
#import "Bishop.h"
#import "Rook.h"

@implementation Queen{
    Bishop* bishop;
    Rook* rook;
}

-(id)initWithBoard:(ChessBoard *)board team:(int)team location:(Location *)location{
    self = [super initWithBoard:board team:team location:location];
    if(self){
        bishop = [[Bishop alloc] initWithBoard:board team:team location:location];
        rook = [[Rook alloc] initWithBoard:board team:team location:location];
    }
    return self;
}

-(NSMutableArray *)getValidLocations{
    [super getValidLocations];
    bishop.location = self.location;
    rook.location = self.location;
    [locations addObjectsFromArray:[bishop getValidLocations]];
    [locations addObjectsFromArray:[rook getValidLocations]];
    return locations;
}

- (NSMutableArray *)getValidLocationsOverlapAlly {
    [super getValidLocationsOverlapAlly];
    bishop.location = self.location;
    rook.location = self.location;
    [locations addObjectsFromArray:[bishop getValidLocationsOverlapAlly]];
    [locations addObjectsFromArray:[rook getValidLocationsOverlapAlly]];
    return locations;
}
@end
