 //
//  TSView.m
//  Linker
//
//  Created by Mac on 17.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSView.h"
#import "TSPrefixHeader.pch"

@implementation TSView

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, view.frame.size.width, 36);
        self.backgroundColor = GRAY_COLOR;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
