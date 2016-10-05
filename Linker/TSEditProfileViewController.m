//
//  TSEditProfileViewController.m
//  Linker
//
//  Created by Mac on 17.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSEditProfileViewController.h"
#import "TSFireUser.h"
#import "TSRetriveFriendsFBDatabase.h"
#import "TSPrefixHeader.pch"

@import Firebase;
@import FirebaseDatabase;

@interface TSEditProfileViewController ()

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRUser *user;
@property (strong, nonatomic) TSFireUser *fireUser;
@property (strong, nonatomic) NSMutableArray *friends;

@property (weak, nonatomic) IBOutlet UITextField *professionTextFd;
@property (weak, nonatomic) IBOutlet UITextField *commingFromTextFd;
@property (weak, nonatomic) IBOutlet UITextField *coingToTextFd;
@property (weak, nonatomic) IBOutlet UITextField *currentArreaTextFd;
@property (weak, nonatomic) IBOutlet UITextField *launguageTextFd;
@property (weak, nonatomic) IBOutlet UITextField *ageTextFd;
@property (weak, nonatomic) IBOutlet UITextField *missionTextFd;
@property (weak, nonatomic) IBOutlet UITextField *aboutTextFd;
@property (weak, nonatomic) IBOutlet UITextField *backgroundTextFd;
@property (weak, nonatomic) IBOutlet UITextField *interestTextFd;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;

@end

@implementation TSEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ref = [[FIRDatabase database] reference];
    self.user = [FIRAuth auth].currentUser;
    
    
    self.updateButton.layer.cornerRadius = 3;
    self.updateButton.layer.masksToBounds = YES;
}

- (IBAction)actBackPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionUpdt:(id)sender
{
    
    [self saveDataToDataBase];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)saveDataToDataBase
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            self.fireUser = [TSFireUser initWithSnapshot:snapshot];
            
            NSDictionary *userData = nil;
            
            
            NSString *profession = nil;
            NSString *coingTo = nil;
            NSString *city = nil;
            NSString *mission = nil;
            NSString *about = nil;
            NSString *background = nil;
            NSString *interest = nil;
            
            
            
            if ([self.professionTextFd.text isEqualToString:@""]) {
                
                profession = self.fireUser.profession;
                
            } else {
                
                profession = self.professionTextFd.text;
            }
            
            
            
            if ([self.coingToTextFd.text isEqualToString:@""]) {
                
                coingTo = self.fireUser.coingTo;
                
            } else {
                
                coingTo = self.coingToTextFd.text;
            }
            
            
            
            if ([self.currentArreaTextFd.text isEqualToString:@""]) {
                
                city = self.fireUser.currentArrea;
                
            } else {
                
                city = self.currentArreaTextFd.text;
            }
            
            
            
            if ([self.missionTextFd.text isEqualToString:@""]) {
                
                mission = self.fireUser.mission;
                
            } else {
                
                mission = self.missionTextFd.text;
            }
            
            
            
            if ([self.aboutTextFd.text isEqualToString:@""]) {
                
                about = self.fireUser.about;
                
            } else {
                
                about = self.aboutTextFd.text;
            }
            
            
            
            if ([self.backgroundTextFd.text isEqualToString:@""]) {
                
                background = self.fireUser.background;
                
            } else {
                background = self.backgroundTextFd.text;
            }
            
            
            
            if ([self.interestTextFd.text isEqualToString:@""]) {
                
                interest = self.fireUser.interest;
                
            } else {
                
                interest = self.interestTextFd.text;
            }
            
            
            userData = @{@"displayName":self.fireUser.displayName,
                         @"email":self.fireUser.email,
                         @"photoURL":self.fireUser.photoURL,
                         @"userID":self.fireUser.uid,
                         @"profession":profession,
                         @"coingTo":coingTo,
                         @"city":city,
                         @"mission":mission,
                         @"about":about,
                         @"background":background,
                         @"interest":interest};
            
            
            [[[[self.ref child:@"users"] child:self.user.uid] child:@"username"] setValue:userData];
            
        }];
        
    });
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.view.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.view.frame.origin.y - kbSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
    
}


- (void)keyboardDidHide:(NSNotification *)notification
{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
}

@end
