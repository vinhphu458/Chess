//
// Created by Admin on 10/19/17.
// Copyright (c) 2017 dvphu. All rights reserved.
//

#import "BaseView.h"
#import "ChessBoard.h"

@interface UndoRedoView : BaseView<UIGestureRecognizerDelegate>
-(void) setChessBoardModel:(ChessBoard*) board;
@end