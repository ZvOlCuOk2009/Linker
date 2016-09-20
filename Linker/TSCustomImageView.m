//
//  TSCustomImageView.m
//  Linker
//
//  Created by Mac on 15.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSCustomImageView.h"

@implementation TSCustomImageView


- (void)drawRect:(CGRect)rect
{
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
}



@end
