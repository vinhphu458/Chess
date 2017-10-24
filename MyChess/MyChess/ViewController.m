//
//  ViewController.m
//  MyChess
//
//  Created by Admin on 10/3/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    ChessBoardView* chessBoard;
    UndoRedoView *undoRedoView;
}
@end

@implementation ViewController{
    int center;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    center = (int) ((mSCREEN_HEIGHT - mSCREEN_WIDTH)/2);
    [self initChessBoardView];
    [self initButton];
}
- (void)initChessBoardView {
    chessBoard = [[ChessBoardView alloc] initWithFrame:CGRectMake(0, center, mSCREEN_WIDTH, mSCREEN_WIDTH)];
    [self.view addSubview:chessBoard];
}

-(void)initButton{
    int blow_board = (int) (center + mSCREEN_WIDTH + 10);
    undoRedoView = [[UndoRedoView alloc] initWithFrame:CGRectMake(0, blow_board, mSCREEN_WIDTH, 100)];
    [undoRedoView setChessBoardModel:chessBoard.board];
    [self.view addSubview:undoRedoView];
}

@end
