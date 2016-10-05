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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Do you want to exit the application?"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"YES"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [[TSFBManager sharedManager] logOutUser];
                                                          
                                                          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                                          
                                                          TSLoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"TSLoginViewController"];
                                                          [self.settingScrollViewController presentViewController:controller animated:YES completion:nil];
                                                      }];
    
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"NO"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) { }];
    
    [alertController addAction:actionYes];
    [alertController addAction:actionNo];
    
    [self.settingScrollViewController presentViewController:alertController animated:YES completion:nil];
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

@end
