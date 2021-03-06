//
//  TSHandler.m
//  Linker
//
//  Created by Mac on 15.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSHandler.h"
#import "TSPrefixHeader.pch"

@implementation TSHandler

+ (CGRect)hendlerPositionArrow:(NSInteger)tag
{
    CGFloat yValue = 0.0;
    CGFloat xValue = 0.0;
    CGFloat weihgt = 0.0;
    CGFloat height = 0.0;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            
            yValue = 244;
            weihgt = 24;
            height = 7;
            
            if (tag == 1) {
                xValue = 22;
            } else if (tag == 2) {
                xValue = 93;
            } else if (tag == 3) {
                xValue = 176;
            }else if (tag == 4) {
                xValue = 262;
            }
            
        } else if (IS_IPHONE_5) {
            
            yValue = 298;
            weihgt = 24;
            height = 8;
            
            if (tag == 1) {
                xValue = 22;
            } else if (tag == 2) {
                xValue = 93;
            } else if (tag == 3) {
                xValue = 176;
            }else if (tag == 4) {
                xValue = 262;
            }
            
        } else if (IS_IPHONE_6) {
            
            yValue = 350;
            
            if (tag == 1) {
                xValue = 28;
            } else if (tag == 2) {
                xValue = 111;
            } else if (tag == 3) {
                xValue = 210;
            }else if (tag == 4) {
                xValue = 309;
            }
            
            weihgt = 25;
            height = 11;
            
        } else if (IS_IPHONE_6_PLUS) {
            
            yValue = 386;
            
            if (tag == 1) {
                xValue = 28;
            } else if (tag == 2) {
                xValue = 124;
            } else if (tag == 3) {
                xValue = 233;
            }else if (tag == 4) {
                xValue = 343;
            }
            
            weihgt = 25;
            height = 11;
        }
    }
    
    CGRect frame;
    if (tag == 1) {
        frame = CGRectMake(xValue, yValue, weihgt, height);
    } else if (tag == 2) {
        frame = CGRectMake(xValue, yValue, weihgt, height);
    } else if (tag == 3) {
        frame = CGRectMake(xValue, yValue, weihgt, height);
    } else if (tag == 4) {
        frame = CGRectMake(xValue, yValue, weihgt, height);
    }
    return frame;
}

@end
