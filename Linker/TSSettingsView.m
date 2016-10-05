//
//  TSSettingsView.m
//  Linker
//
//  Created by Mac on 05.10.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSSettingsView.h"
#import "TSPrefixHeader.pch"

@interface TSSettingsView ()

@property (weak, nonatomic) IBOutlet UIButton *fbButton;
@property (weak, nonatomic) IBOutlet UIButton *gButton;
@property (weak, nonatomic) IBOutlet UIButton *lnButton;
@property (weak, nonatomic) IBOutlet UIButton *eButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *iAmSegmentedControll;
@property (weak, nonatomic) IBOutlet UISegmentedControl *lookingForSegmentedControll;
@property (assign, nonatomic) NSInteger counter;

@end

@implementation TSSettingsView


- (void)drawRect:(CGRect)rect
{
    self.counter = 0;
    
    UIFont *font = [UIFont boldSystemFontOfSize:15.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    [self.iAmSegmentedControll setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.lookingForSegmentedControll setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    self.fbButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.gButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.lnButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.eButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.lookingForSegmentedControll.selectedSegmentIndex = 1;
}


#pragma mark - Actions


- (IBAction)actionIAmSegmentedControll:(id)sender
{
    if (self.iAmSegmentedControll.selectedSegmentIndex == 0) {
        self.lookingForSegmentedControll.selectedSegmentIndex = 1;
    }
    else {
        self.lookingForSegmentedControll.selectedSegmentIndex = 0;
    }
}

- (IBAction)actionLookingForSegmentedControll:(id)sender
{
    if (self.lookingForSegmentedControll.selectedSegmentIndex == 0) {
        self.iAmSegmentedControll.selectedSegmentIndex = 1;
    }
    else {
        self.iAmSegmentedControll.selectedSegmentIndex = 0;
    }
}


- (IBAction)actionFBButton:(UIButton *)sender
{
    
    [self switchBackgroundButton:sender];
}


- (IBAction)actionGoogleButton:(UIButton *)sender
{
    [self switchBackgroundButton:sender];
}


- (IBAction)actionLinkedinButton:(UIButton *)sender
{
    [self switchBackgroundButton:sender];
}


- (IBAction)actionEmailButton:(UIButton *)sender
{
    [self switchBackgroundButton:sender];
}


- (void)switchBackgroundButton:(UIButton *)button
{

    if (self.counter == 0) {
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        self.counter = 1;
    } else if (self.counter == 1) {
        button.backgroundColor = LIGHT_GRAY_COLOR;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.counter = 0;
    }
}

@end
