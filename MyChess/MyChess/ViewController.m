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
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int center = (mSCREEN_HEIGHT - mSCREEN_WIDTH)/2;
    chessBoard = [[ChessBoardView alloc] initWithFrame:CGRectMake(0, center, mSCREEN_WIDTH, mSCREEN_WIDTH)];
    [self.view addSubview:chessBoard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
