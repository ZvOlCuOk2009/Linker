//
//  TSSettingViewController.m
//  Linker
//
//  Created by Mac on 03.10.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSSettingViewController.h"

@interface TSSettingViewController ()

@property (weak, nonatomic) IBOutlet UIButton *fbButton;
@property (weak, nonatomic) IBOutlet UIButton *gButton;
@property (weak, nonatomic) IBOutlet UIButton *lnButton;
@property (weak, nonatomic) IBOutlet UIButton *eButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *iAmSegmentedControll;
@property (weak, nonatomic) IBOutlet UISegmentedControl *lookingForSegmentedControll;

@end

@implementation TSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIFont *font = [UIFont boldSystemFontOfSize:15.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    [self.iAmSegmentedControll setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.lookingForSegmentedControll setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    self.fbButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.gButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.lnButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.eButton.layer.borderColor = [UIColor blackColor].CGColor;
 
    self.lookingForSegmentedControll.selectedSegmentIndex = 1;
}

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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
