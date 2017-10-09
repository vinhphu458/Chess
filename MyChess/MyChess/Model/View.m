//
//  View.m
//  MyChess
//
//  Created by Admin on 10/6/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "View.h"
@interface View(){
    double squareSize;
}
@end

@implementation View


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    NSLog(@"on Draw Rect");
    [super drawRect:rect];
    squareSize = 40;
    CGPoint boardOrigin;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*
     This is an 8x8 grid.  Core Graphics starts drawing from the bottom-left corner so
     boardOrigin.y is set to 7-times the square's side length.  This starts drawing
     squares beginning with the upper-left square, working right and then down through
     each row with a couple of nested for-loops
     */
    boardOrigin.y = squareSize * 7;
    
    for(int row = 0; row < 8; row++) {
        
        for(int column = 0; column < 8; column++) {
            
            CGRect square = {
                boardOrigin.x + (column * squareSize),
                boardOrigin.y - (row * squareSize),
                squareSize,
                squareSize};
            
            // This is a handy little way of laying out the right box colours
            // When the row number and column number added together is divisible by
            // two, set the fill colour to dark blue, otherwise set it to light blue
            
            if((row + column) % 2 == 0) {
                // a dark blue
                CGContextSetRGBFillColor(context, 0.02, 0.28, 0.48, 1.00);
            }
            else {
                // a light blue
                CGContextSetRGBFillColor(context, 0.34, 0.72, 1.00, 1.00);
            }
            
            CGContextFillRect(context, square);
            
        }
        
    }
    
    // Add a nice gradient overlay
    CAGradientLayer* gradientOverlay = [CAGradientLayer layer];
    gradientOverlay.frame = rect;
    
    gradientOverlay.colors = [NSArray arrayWithObjects:(id)
                              [UIColor colorWithRed:0. green:0. blue:0. alpha:0.7].CGColor,
                              [UIColor colorWithRed:0. green:0. blue:0. alpha:0.99].CGColor,
                              nil];
    
    gradientOverlay.locations = [NSArray arrayWithObjects:
                                 [NSNumber numberWithFloat:0.0],
                                 [NSNumber numberWithFloat: (squareSize * 6) / self.frame.size.height],
                                 nil];
    
    gradientOverlay.startPoint = CGPointMake(0.1, 0.1);
    gradientOverlay.endPoint = CGPointMake(1, 1);
    
    [self.layer setMask:gradientOverlay];
}


@end
