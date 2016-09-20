//
//  TSLoginViewController.h
//  Linker
//
//  Created by Mac on 14.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)signINButtonAction:(UIButton *)sender;

@end
