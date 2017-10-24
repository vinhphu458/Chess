//
// Created by Admin on 10/19/17.
// Copyright (c) 2017 dvphu. All rights reserved.
//

#import "UndoRedoView.h"
#import "ViewController.h"

@implementation UndoRedoView{
    UIButton *btUndo;
    UIButton *btRedo;
    UIButton *btReset;
    ChessBoard *gameControl;
}

- (void)setChessBoardModel:(ChessBoard *)board {
    gameControl = board;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGRect btUndoSize = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height/2);
    btUndo = [[UIButton alloc] initWithFrame:btUndoSize];
    [btUndo setTitle:@"Undo" forState:UIControlStateNormal];
    [btUndo setBackgroundColor:[UIColor brownColor]];

    CGRect btRedoSize = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height/2);
    btRedo = [[UIButton alloc] initWithFrame:btRedoSize];
    [btRedo setTitle:@"Redo" forState:UIControlStateNormal];
    [btRedo setBackgroundColor:[UIColor purpleColor]];

    CGRect btResetSize = CGRectMake(0, self.frame.size.height/2, self.frame.size.width, self.frame.size.height/2);
    btReset = [[UIButton alloc] initWithFrame:btResetSize];
    [btReset setTitle:@"Reset" forState:UIControlStateNormal];
    [btReset setBackgroundColor:[UIColor greenColor]];

    [self addSubview:btUndo];
    [self addSubview:btRedo];
    [self addSubview:btReset];

    [self setUpOnclickEvent:btUndo];
    [self setUpOnclickEvent:btRedo];
    [self setUpOnclickEvent:btReset];
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isEqual:btRedo]){
        NSLog(@"Redo");
        [gameControl doRedo];
    }
    if([touch.view isEqual:btUndo]){
        NSLog(@"Undo");
        [gameControl doUndo];
    }
    if([touch.view isEqual:btReset]){
        NSLog(@"Reset");
        [((ViewController *) self.window.rootViewController) initChessBoardView];
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