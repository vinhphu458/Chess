//
//  Constant.h
//  MyChess
//
//  Created by Admin on 10/4/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#ifndef Constant_h
#define Constant_h
//devices
#define mSCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define mSCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

//color
#define CHESS_BOARD_COLOR1 0xff9999
#define CHESS_BOARD_COLOR2 0x00bfff
#define SELECTED_COLOR 0x91A188

//chess board value
#define CHESS_BOARD_SIZE 64
#define COLLUMN_SIZE 8

#define UPPER_TEAM 0
#define BELOW_TEAM 1


#define CHESS_ICON(color, chess) [NSString stringWithFormat:@"%@_%@", color, chess]
//Chess colors prefix
#define WHITE @"white"
#define BLACK @"black"

//Chess icons suffix
#define KING @"king"
#define QUEEN @"queen"
#define ROOK @"rook"
#define KNIGHT @"knight"
#define BISHOP @"bishop"
#define PAWN @"pawn"

#define TAG_OFFSET(index) (index + 1);

#define LOCATION(x, y) [[Location alloc]initX:x Y:y]
#define LOCATION_BY_INDEX(index) [[Location alloc]initX:(index%8) Y:(index/8)]

#endif /* Constant_h */
