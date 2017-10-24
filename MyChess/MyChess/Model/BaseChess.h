//
//  BaseChess.h
//  MyChess
//
//  Created by Admin on 10/12/17.
//  Copyright © 2017 dvphu. All rights reserved.
//
#import <Foundation/Foundation.h>
#include "Location.h"
#include "Constant.h"
#include "ChessBoard.h"
#import "Utils.h"

@interface BaseChess : NSObject {
    NSMutableArray *locations;

}
- (id)initWithBoard:(ChessBoard *)board team:(int)team location:(Location *)location;

@property(nonatomic, assign) int team; //0 below - 1 upper
@property(nonatomic, readonly) NSString *icon;
@property(nonatomic, strong) Location *location;
@property(nonatomic, assign) int moveCount;
@property(nonatomic, weak) ChessBoard *board;

- (void)setLocationX:(int)x andY:(int)y;

- (NSMutableArray *)getValidLocations;

- (NSMutableArray *)getValidLocationsOverlapAlly;

- (BOOL)moveToLocation:(Location *)location;

- (bool)isValidLocationOnChecked:(Location *)location;

@property(nonatomic, getter=toString) NSString *name;

@end
