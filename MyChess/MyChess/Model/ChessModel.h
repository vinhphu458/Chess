//
//  ChessModel.h
//  MyChess
//
//  Created by Admin on 10/4/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    King, Queen, Bishop, Knight, Rook, Pawn, Empty
} ChessPiece;

@interface ChessModel : NSObject

@property (nonatomic, assign) int position;
@property (nonatomic, assign) ChessPiece tag;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString* icon;

@end
