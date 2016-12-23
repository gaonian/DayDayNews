//
//  UIColor+Extension.m
//  新闻
//
//  Created by 范英强 on 2016/11/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (UIColor *) colorWithHexString: (NSString *) hexString {
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1 Case:1];
            green = [self colorComponentFrom: colorString start: 1 length: 1 Case:2];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1 Case:3];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1 Case:0];
            red   = [self colorComponentFrom: colorString start: 1 length: 1 Case:1];
            green = [self colorComponentFrom: colorString start: 2 length: 1 Case:2];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1 Case:3];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2 Case:1];
            green = [self colorComponentFrom: colorString start: 2 length: 2 Case:2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2 Case:3];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2 Case:0];
            red   = [self colorComponentFrom: colorString start: 2 length: 2 Case:1];
            green = [self colorComponentFrom: colorString start: 4 length: 2 Case:2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2 Case:3];
            break;
        default:
            return nil;
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length Case:(int) ARGB{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    switch (ARGB) {
        case 0://alpha
            return hexComponent / 255.0;
            
            break;
        case 1://red
            
            return ( hexComponent )/ 255.0;
            
            break;
        case 2://green
            return (hexComponent)/ 255.0;
            
            break;
        case 3://blue
            return (hexComponent) / 255.0;
            
            break;
        default:
            break;
    }
    return 0;
}

@end
