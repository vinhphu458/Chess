//
//  ChessModel.m
//  MyChess
//
//  Created by Admin on 10/4/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "ChessModel.h"

@implementation ChessModel
-(id)init{
    self = [super init];
    if(self){
        _type = -1;//empty cell
    }
    return self;
}
-(void)setEmpty{
    self.tag = Empty;
    self.icon = nil;
    self.type = -1;
}
@end
