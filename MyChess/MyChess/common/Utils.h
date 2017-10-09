//
//  Utils.h
//  MyChess
//
//  Created by Admin on 10/6/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Utils : NSObject
+(void) setCGContextColor:(CGContextRef) context hexColor:(int) hexCode;
+(UIColor *)colorFromHex:(int)hexCode;
@end
