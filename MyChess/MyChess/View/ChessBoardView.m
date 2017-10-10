//
//  ChessBoardView.m
//  MyChess
//
//  Created by Admin on 10/3/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "ChessBoardView.h"
@interface ChessBoardView()<UIGestureRecognizerDelegate>{
    double cellSide;
    ChessBoardModel* chessBoard;
    UIImageView* selectedChess;
    UIImageView* destinationView;
    GameController* controller;
    int fromPosition;
}

@end

@implementation ChessBoardView
-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        chessBoard = [[ChessBoardModel alloc] init];
        controller = [[GameController alloc] init];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    cellSide = self.frame.size.width / COLLUMN_SIZE;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for(int i = 0; i < CHESS_BOARD_SIZE; i++){
        int col = i%COLLUMN_SIZE;
        int row = i/COLLUMN_SIZE;
        CGRect cellSize = CGRectMake((CGFloat)col*cellSide, (CGFloat)row*cellSide, cellSide, cellSide);
        
        [Utils setCGContextColor:context hexColor:(row + col) % 2 == 0 ? CHESS_BOARD_COLOR1 : CHESS_BOARD_COLOR2];
        CGContextFillRect(context, cellSize);
        
        [self addChess:i withSize:cellSize];
    }
    [controller addListChess:[chessBoard chessList]];
}

-(void) addChess:(int) position withSize:(CGRect) cellSize {
    UIImageView *ico = [[UIImageView alloc] initWithFrame:cellSize];
    [self setUpOnclickEvent:ico];
    ico.tag = position;
    [chessBoard addChess:^(ChessModel* chess){
        ico.image = [UIImage imageNamed:chess.icon];
    } atPosition:position];
    [self addSubview:ico];
}

- (void)onDeselectedChess:(int)position {
    [selectedChess setBackgroundColor:nil];//reset background
    [chessBoard onDeselectedChess:position];//trigger to model
}

- (void)onMoveChessToPositon:(int)position {

    [selectedChess setBackgroundColor:nil];//reset background
    
    NSLog(@"Move: %@",((ChessModel*) [chessBoard.chessList objectAtIndex:fromPosition]).icon);
    if(![controller canMove:fromPosition toPosition:position]){
        return;
    }
    //change turn when move success
    controller.game_turn = 1 - controller.game_turn;
    //swap view
    CGRect temp = destinationView.frame;
    [destinationView setFrame:selectedChess.frame];
    [selectedChess setFrame:temp];
    //trigger to model
    [chessBoard onMoveChessToPositon:position];
}

- (void)onSelectedChess:(int)position {
    ChessModel* chess = [[chessBoard chessList] objectAtIndex:position];
    if(chess.type != [controller game_turn]) return;
    
    fromPosition = position;
    [selectedChess setBackgroundColor:[Utils colorFromHex:SELECTED_COLOR]];//set selected background
    [chessBoard onSelectedChess:position];//trigger to model
}

-(int) pointToPosition:(CGPoint) point{
    return point.x/cellSide + COLLUMN_SIZE*(point.y)/cellSide;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIImageView* selected = (UIImageView*)touch.view;
    int position = [self pointToPosition:selected.frame.origin];
    //on select chess
    if(selectedChess == nil && selected.image){
        selectedChess = selected;
        destinationView = nil;
        [self onSelectedChess:position];
        return true;
    }
    //on move chess
    if(selectedChess!=nil && selected!= selectedChess){
        destinationView = selected;
        [self onMoveChessToPositon:position];
        selectedChess = nil;
        return true;
    }
    //on de-select chess
    if(selected == selectedChess){
        [self onDeselectedChess:position];
        selectedChess = nil;
        destinationView = nil;
        return true;
    }
    return true;
}

//set up click event for each block
-(void) setUpOnclickEvent:(id) view{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    singleTap.numberOfTapsRequired = 1;
    [view setUserInteractionEnabled:YES];
    [view addGestureRecognizer:singleTap];
    singleTap.delegate = self;
}

@end
