//
//  Utils.m
//  MyChess
//
//  Created by Admin on 10/6/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+ (float *)rgbFromHex:(int)hexCode {
    float *rgb = malloc(sizeof(int) * 3);
    rgb[0] = (float) (((hexCode & 0xFF0000) >> 16) / 255.0);
    rgb[1] = (float) (((hexCode & 0x00FF00) >> 8) / 255.0);
    rgb[2] = (float) (((hexCode & 0x0000FF) >> 0) / 255.0);
    return rgb;
}

+ (void)setCGContextColor:(CGContextRef)context hexColor:(int)hexCode {
    float *rgb = [self rgbFromHex:hexCode];
    CGContextSetRGBFillColor(context, rgb[0], rgb[1], rgb[2], 1.0f);
}

+ (UIColor *)colorFromHex:(int)hexCode {
    float *rgb = [self rgbFromHex:hexCode];
    return [UIColor colorWithRed:rgb[0] green:rgb[1] blue:rgb[2] alpha:1.0f];
}

+ (BOOL)isNull:(id)obj {
    return obj == [NSNull null] || obj == nil;
}
@end
