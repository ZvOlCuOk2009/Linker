//
//  TSHomeView.m
//  Linker
//
//  Created by Mac on 05.10.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSHomeView.h"
#import "TSFireUser.h"
#import "TSFBManager.h"
#import "TSLoginViewController.h"
#import "TSSettingScrollViewController.h"
#import "TSPrefixHeader.pch"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@import Firebase;
@import FirebaseDatabase;

@interface TSHomeView ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;


@property (strong, nonatomic) UIStoryboard *storyboard;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) TSSettingScrollViewController *settingScrollViewController;

@property (weak, nonatomic) IBOutlet UIButton *outButton;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (strong, nonatomic) UIView *alert;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightInviteButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightAvatarConstraint;

@end

@implementation TSHomeView


- (void)drawRect:(CGRect)rect
{
    
    self.ref = [[FIRDatabase database] reference];
    
    self.inviteButton.layer.cornerRadius = 3;
    self.inviteButton.layer.masksToBounds = YES;
    
    [self addAvatar];
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            
        } else if (IS_IPHONE_5) {
            
            self.heightInviteButtonConstraint.constant = 37;
            self.heightAvatarConstraint.constant = 180;
            
        } else if (IS_IPHONE_6) {
            
            self.heightInviteButtonConstraint.constant = 47;
            
        } else if (IS_IPHONE_6_PLUS) {
            
            self.heightInviteButtonConstraint.constant = 50;
        }
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    self.storyboard = [UIStoryboard storyboardWithName:@"HomeStoryboard" bundle:[NSBundle mainBundle]];
    self.settingScrollViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"SettingScrollViewStoryboard"];
    
}


- (void)addAvatar
{
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        TSFireUser *fireUser = [TSFireUser initWithSnapshot:snapshot];
        
        NSURL *url = [NSURL URLWithString:fireUser.photoURL];
        
        if (url && url.scheme && url.host) {
            
            if ([self verificationURL:fireUser.photoURL]) {
                FBSDKProfilePictureView *avatar = [[TSFBManager sharedManager] requestUserImageFromTheServerFacebook:self.avatarImageView ID:@"me"];
                avatar.layer.cornerRadius = avatar.frame.size.width / 2;
                avatar.layer.masksToBounds = YES;
                [self addSubview:avatar];
                
            } else {
                self.avatarImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                                     [NSURL URLWithString:fireUser.photoURL]]];
            }
            
        } else {
            
            NSData *data = [[NSData alloc]initWithBase64EncodedString:fireUser.photoURL options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *convertImage = [UIImage imageWithData:data];
            self.avatarImageView.image = convertImage;
        }
    }];
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
    self.avatarImageView .layer.masksToBounds = YES;
    
}


#pragma mark - Actions


- (IBAction)actionInviteFriends:(id)sender
{
    [[TSFBManager sharedManager] inviteUserFriendsTheServerFacebook:self.settingScrollViewController];
}



- (IBAction)actionLogOut:(id)sender
{
    
    self.alert = [[UIView alloc] init];
    self.alert.frame = CGRectMake(self.frame.size.width / 4, - 250,
                             self.frame.size.width / 1.5, self.frame.size.height / 4);
    self.alert.backgroundColor = [UIColor whiteColor];
    self.alert.layer.cornerRadius = 10;
    
    [self addSubview:self.alert];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.alert.frame = CGRectMake(self.frame.size.width / 4, (self.frame.size.height / 4) * 2,
                                      self.frame.size.width / 1.5, self.frame.size.height / 4);
    }];
    
    
    UIButton *yesButton = [[UIButton alloc] init];
    yesButton.backgroundColor = [UIColor whiteColor];
    yesButton.frame = CGRectMake(0, (self.alert.frame.size.height / 3) * 2,
                                 self.alert.frame.size.width / 2, self.alert.frame.size.height / 3);
    [yesButton setTitle:@"YES" forState:UIControlStateNormal];
    [yesButton setTintColor:[UIColor redColor]];
    [yesButton addTarget:self action:@selector(actionYesButton) forControlEvents:UIControlEventTouchUpInside];
    [self.alert addSubview:yesButton];
    
    UIButton *noButton = [[UIButton alloc] init];
    noButton.backgroundColor = [UIColor whiteColor];
    noButton.frame = CGRectMake(self.alert.frame.size.height / 2, (self.alert.frame.size.height / 3) * 2,
                                 self.alert.frame.size.width / 2, self.alert.frame.size.height / 3);
    [noButton setTitle:@"NO" forState:UIControlStateNormal];
    [noButton setTintColor:[UIColor blueColor]];
    [noButton addTarget:self action:@selector(actionNoButton) forControlEvents:UIControlEventTouchUpInside];
    [self.alert addSubview:noButton];
    
}


- (BOOL)verificationURL:(NSString *)url
{
    BOOL verification;
    NSArray *component = [url componentsSeparatedByString:@"."];
    NSString *firstComponent = [component firstObject];
    
    if ([firstComponent isEqualToString:@"https://scontent"]) {
        verification = YES;
    } else {
        verification = NO;
    }
    return verification;
}


- (void)actionYesButton
{
    [[TSFBManager sharedManager] logOutUser];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    TSLoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"TSLoginViewController"];
    [self.window setRootViewController:controller];
}


- (void)actionNoButton
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.alert.frame = CGRectMake(self.frame.size.width / 4, 780,
                                      self.frame.size.width / 1.5, self.frame.size.height / 4);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.alert removeFromSuperview];
    });
    
}

@end
