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
#define TEAM_ONE_FROM_INDEX 48
#define TEAM_ONE_TO_INDEX 63
#define TEAM_TWO_FROM_INDEX 0
#define TEAM_TWO_TO_INDEX 15

//Chess icons
#define wKING @"white_king"
#define wQUEEN @"white_queen"
#define wROOK @"white_rook"
#define wKNIGHT @"white_knight"
#define wBISHOP @"white_bishop"
#define wPAWN @"white_pawn"

#define bKING @"black_king"
#define bQUEEN @"black_queen"
#define bROOK @"black_rook"
#define bKNIGHT @"black_knight"
#define bBISHOP @"black_bishop"
#define bPAWN @"black_pawn"

#endif /* Constant_h */
