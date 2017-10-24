//
//  ChessBoardView.m
//  MyChess
//
//  Created by Admin on 10/3/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "ChessBoardView.h"
#import "BaseChess.h"

@implementation ChessBoardView {
    CGFloat cellSide;
    UIImageView *selectedChess;
    UIImageView *destinationView;
    int fromPosition, toPosition;
    ChessBoard *newChessBoard;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        newChessBoard = [[ChessBoard alloc] init];
        [self stateChangedCallBack];
    }
    return self;
}

- (ChessBoard *)getChessBoard {
    return newChessBoard;
}

- (void)stateChangedCallBack {
    __weak typeof(self) _self = self;
    [newChessBoard setOnChessMovedStatus:^(State state, NSArray *positionsChanged) {
        NSLog(@"Emitted state: %lu", (unsigned long) state);
        if (state == Keep) {
            //[_self highLightMoves];
        }

        if (state & Move || state & Eat) {
            [_self refreshViewAt:positionsChanged];
            //[_self unHighlightMoves];
            if (state & Check) {

            }
            if (state & Checkmate) {
                [self showCheckmate: newChessBoard.turn_by_team];
            }
            if (state & Pawn_Promotion) {
            }
            if (state & Pawn_EnPassant) {

            }
        }
    }];
}

- (void)highLightMoves {
    for (int i = 0; i < newChessBoard.locations.count; i++) {
        int index = [newChessBoard.locations[i] toIndex];
        int tag = TAG_OFFSET(index);
        UIView *view = [self viewWithTag:tag];
        [view setBackgroundColor:[Utils colorFromHex:SELECTED_COLOR]];
    }
}

- (void)unHighlightMoves {
    for (int i = 0; i < newChessBoard.locations.count; i++) {
        int index = [newChessBoard.locations[i] toIndex];
        int tag = TAG_OFFSET(index);
        UIView *view = [self viewWithTag:tag];
        [view setBackgroundColor:nil];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    cellSide = self.frame.size.width / COLLUMN_SIZE;
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i = 0; i < CHESS_BOARD_SIZE; i++) {
        int col = i % COLLUMN_SIZE;
        int row = i / COLLUMN_SIZE;
        CGRect cellSize = CGRectMake(col * cellSide, row * cellSide, cellSide, cellSide);

        [Utils setCGContextColor:context hexColor:(row + col) % 2 == 0 ? CHESS_BOARD_COLOR1 : CHESS_BOARD_COLOR2];
        CGContextFillRect(context, cellSize);
        [self addChessView:i withSize:cellSize];
    }
}

//new models
- (void)addChessView:(int)position withSize:(CGRect)cellSize {
    CGRect resize = CGRectMake(cellSize.origin.x + 1, cellSize.origin.y + 1, cellSize.size.width - 2, cellSize.size.height - 2);
    UIImageView *ico = [[UIImageView alloc] initWithFrame:resize];
    [self setUpOnclickEvent:ico];
    ico.tag = TAG_OFFSET(position);
    BaseChess *chess = newChessBoard.chessList[position];
    if (chess != (id) [NSNull null]) {
        ico.image = [UIImage imageNamed:[chess icon]];
    }
    [self addSubview:ico];
}

- (void)onDeselectedChess:(int)position {
    [selectedChess setBackgroundColor:nil];//reset background
    [newChessBoard onDeselectedChess:position];
    fromPosition = -1;
    [self unHighlightMoves];
}

- (void)onMoveChessToPosition:(int)position {
    toPosition = position;
    [selectedChess setBackgroundColor:nil];//reset background
    [newChessBoard onMoveChessToPosition:position];
    toPosition = -1;
}

- (void)refreshViewAt:(NSArray *)positions {
    for (NSNumber *pos in positions) {
        BaseChess *chess = [newChessBoard chessList][[pos intValue]];
        int tag = TAG_OFFSET([pos intValue]);
        if ([Utils isNull:chess]) {
            [(UIImageView *) [self viewWithTag:tag] setImage:nil];
        } else {
            [(UIImageView *) [self viewWithTag:tag] setImage:[UIImage imageNamed:chess.icon]];
        }
    }
}

- (void)updateChessView:(int)origin and:(int)destination {
    BaseChess *destinationChess = [newChessBoard chessList][destination];
    BaseChess *originChess = [newChessBoard chessList][origin];
    origin = TAG_OFFSET(origin);
    destination = TAG_OFFSET(destination);
    if ([Utils isNull:originChess]) {
        [((UIImageView *) [self viewWithTag:origin]) setImage:nil];
    } else {
        [((UIImageView *) [self viewWithTag:origin]) setImage:[UIImage imageNamed:originChess.icon]];
    }
    if ([Utils isNull:destinationChess]) {
        [((UIImageView *) [self viewWithTag:destination]) setImage:nil];
    } else {
        [((UIImageView *) [self viewWithTag:destination]) setImage:[UIImage imageNamed:destinationChess.icon]];
    }

}

- (void)onSelectedChess:(int)position {
    BaseChess *selected = newChessBoard.chessList[position];
    if (selected.team != newChessBoard.turn_by_team) {
        selectedChess = nil;
        return;
    }
    if(self.board.game_end){
        selectedChess = nil;
        return;
    }
    fromPosition = position;
    [selectedChess setBackgroundColor:[Utils colorFromHex:SELECTED_COLOR]];//set selected background
    [newChessBoard onSelectedChess:position];//trigger to model
}

- (int)pointToPosition:(CGPoint)point {
    return (int) (point.x / cellSide + COLLUMN_SIZE * (point.y) / cellSide);
}


- (void)showCheckmate:(int) team {
    NSString *teamWin = [NSString stringWithFormat:@"%@ Win", team == UPPER_TEAM ? @"Black" : @"White"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Checkmate"
                                                                   message:teamWin
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                          }];
    [alert addAction:defaultAction];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    UIImageView *selected = (UIImageView *) touch.view;
    int position = [self pointToPosition:selected.frame.origin];
    //on select chess
    if (selectedChess == nil && selected.image) {
        selectedChess = selected;
        destinationView = nil;
        [self onSelectedChess:position];
        return true;
    }
    //on move chess
    if (selectedChess != nil && selected != selectedChess) {
        destinationView = selected;
        [self onMoveChessToPosition:position];
        selectedChess = nil;
        return true;
    }
    //on de-select chess
    if (selected == selectedChess) {
        [self onDeselectedChess:position];
        selectedChess = nil;
        destinationView = nil;
        return true;
    }
    return true;
}

//set up click event for each block
- (void)setUpOnclickEvent:(id)view {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    singleTap.numberOfTapsRequired = 1;
    [view setUserInteractionEnabled:YES];
    [view addGestureRecognizer:singleTap];
    singleTap.delegate = self;
}

@end
