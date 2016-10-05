//
//  TSTabBarController.m
//  Linker
//
//  Created by Mac on 16.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSTabBarController.h"

@interface TSTabBarController ()

@end

@implementation TSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.tintColor = [UIColor whiteColor];
    
    UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:2];
    [tabBarItem setImage:[UIImage imageNamed:@"logo_tab"]];
    self.tabBar.clipsToBounds = YES;
    
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        vc.title = nil;
        
    }];
    
    CGFloat xValue = self.tabBar.frame.size.width - (self.tabBar.frame.size.width / 5) + 20;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(xValue, 4, 40, 40);
    [button setBackgroundImage:[UIImage imageNamed:@"filter_tab"] forState:UIControlStateNormal];
    [self.tabBar addSubview:button];
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
