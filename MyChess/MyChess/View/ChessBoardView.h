//
//  ChessBoardView.h
//  MyChess
//
//  Created by Admin on 10/3/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "ChessBoardModel.h"
#import "Utils.h"
#import "InteractionOnChessEvent.h"
#import "BaseView.h"
@class ChessBoard;
@interface ChessBoardView : BaseView<UIGestureRecognizerDelegate, InteractionOnChessEvent>
@property (nonatomic, getter=getChessBoard) ChessBoard * board;
@end
