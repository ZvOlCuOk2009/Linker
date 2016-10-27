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

   
    self.tabBar.tintColor = [UIColor whiteColor];
    
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        vc.title = nil;
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
