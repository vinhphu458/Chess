//
//  Location.h
//  MyChess
//
//  Created by Admin on 10/11/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject
@property(nonatomic, assign) int x;
@property(nonatomic, assign) int y;

- (id)initX:(int)x Y:(int)y;

- (bool)isValid;

- (int)toIndex;
@end
