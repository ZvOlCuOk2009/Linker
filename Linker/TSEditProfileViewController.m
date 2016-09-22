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


@end

@implementation TSEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ref = [[FIRDatabase database] reference];
    self.user = [FIRAuth auth].currentUser;
    
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
            NSString *commingFrom = nil;
            NSString *coingTo = nil;
            NSString *city = nil;
            NSString *launguage = nil;
            NSString *age = nil;
            NSString *mission = nil;
            NSString *about = nil;
            NSString *background = nil;
            NSString *interest = nil;
            
            
            
            if ([self.professionTextFd.text isEqualToString:@""]) {
                
                profession = self.fireUser.profession;
                
            } else {
                
                profession = self.professionTextFd.text;
            }
            
            
            
            if ([self.commingFromTextFd.text isEqualToString:@""]) {
                
                commingFrom = self.fireUser.commingFrom;
                
            } else {
                commingFrom = self.commingFromTextFd.text;
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
            
            
            
            if ([self.launguageTextFd.text isEqualToString:@""]) {
                
                launguage = self.fireUser.launguage;
                
            } else {
                
                launguage = self.launguageTextFd.text;
            }
            
            
            
            if ([self.ageTextFd.text isEqualToString:@""]) {
                
                age = self.fireUser.age;
                
            } else {
                
                age = self.ageTextFd.text;
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
                         @"commingFrom":commingFrom,
                         @"coingTo":coingTo,
                         @"city":city,
                         @"launguage":launguage,
                         @"age":age,
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
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 330)];
    }];
    
}


- (void)keyboardDidHide:(NSNotification *)notification
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            
            [UIView animateWithDuration:0.3 animations:^{
                [self.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 480)];
            }];
        } else if (IS_IPHONE_5) {
            
            [UIView animateWithDuration:0.3 animations:^{
                [self.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 568)];
            }];
            
        } else if (IS_IPHONE_6) {
            
            [UIView animateWithDuration:0.3 animations:^{
                [self.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 736)];
            }];
            
        } else if (IS_IPHONE_6_PLUS) {
            
            [UIView animateWithDuration:0.3 animations:^{
                [self.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 736)];
            }];
        }
    }
    
    
    
}

@end
