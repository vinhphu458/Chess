//
//  Location.m
//  MyChess
//
//  Created by Admin on 10/11/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "Location.h"

@implementation Location
- (id)initX:(int)x Y:(int)y {
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
    }
    return self;
}

- (bool)isValid {
    return _x > -1 && _x < 8 && _y > -1 && _y < 8;
}

- (int)toIndex {
    return _x + _y * 8;
}

//overide method to check location in list
- (BOOL)isEqual:(Location *)loc {
    return self == loc || (_x == loc.x && _y == loc.y);
}
@end
