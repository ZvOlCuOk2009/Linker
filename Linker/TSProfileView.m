//
//  TSProfileView.m
//  Linker
//
//  Created by Mac on 15.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSProfileView.h"
#import "TSHandler.h"
#import "TSPrefixHeader.pch"

static NSDictionary *reportedContent;

@implementation TSProfileView


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // initialization
    }    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // initialization
    }
    return self;
}


- (IBAction)mainButtonsAction:(UIButton *)sender
{
    
    NSString *mission = [reportedContent objectForKey:@"mission"];
    NSString *about = [reportedContent objectForKey:@"about"];
    NSString *background = [reportedContent objectForKey:@"background"];
    NSString *interest = [reportedContent objectForKey:@"interest"];
    
    switch (sender.tag) {
        case 1:
        {[UIView animateWithDuration:0.3 animations:^{
            self.arrowImageView.frame = [TSHandler hendlerPositionArrow:1];
            self.contentTextView.text = mission;
        }];}
            break;
        case 2:
        {[UIView animateWithDuration:0.3 animations:^{
            self.arrowImageView.frame = [TSHandler hendlerPositionArrow:2];
            self.contentTextView.text = about;
        }];}
            break;
        case 3:
        {[UIView animateWithDuration:0.3 animations:^{
            self.arrowImageView.frame = [TSHandler hendlerPositionArrow:3];
            self.contentTextView.text = background;
        }];}
            break;
        case 4:
        {[UIView animateWithDuration:0.3 animations:^{
            self.arrowImageView.frame = [TSHandler hendlerPositionArrow:4];
            self.contentTextView.text = interest;
        }];}
            break;
        default:
            break;
    }
    
}


+ (instancetype)profileView:(NSDictionary *)content
{
    
    reportedContent = content;
    
    TSProfileView *view = nil;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            
            UINib *nib = [UINib nibWithNibName:@"TSProfileView" bundle:nil];
            view = [nib instantiateWithOwner:self options:nil][0];
            view.frame = CGRectMake(8, 20, 304, 394);
            
        } else if (IS_IPHONE_5) {
            
            UINib *nib = [UINib nibWithNibName:@"TSProfileView" bundle:nil];
            view = [nib instantiateWithOwner:self options:nil][0];
            view.frame = CGRectMake(8, 20, 304, 482);
            
        } else if (IS_IPHONE_6) {
            
            UINib *nib = [UINib nibWithNibName:@"TSProfileView6" bundle:nil];
            view = [nib instantiateWithOwner:self options:nil][0];
            view.frame = CGRectMake(11, 25, 356, 567);
            
        } else if (IS_IPHONE_6_PLUS) {
            
            UINib *nib = [UINib nibWithNibName:@"TSProfileView6Plus" bundle:nil];
            view = [nib instantiateWithOwner:self options:nil][0];
            view.frame = CGRectMake(11, 34, 393, 624);
        }
    }
    
    return view;
}


@end
