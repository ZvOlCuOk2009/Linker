//
//  TSHomeViewController.m
//  Linker
//
//  Created by Mac on 16.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSHomeViewController.h"
#import "TSFireUser.h"
#import "TSFBManager.h"
#import "TSLoginViewController.h"
#import "TSPrefixHeader.pch"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@import Firebase;
@import FirebaseDatabase;

@interface TSHomeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UIButton *outButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightInviteButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightAvatarConstraint;

@end

@implementation TSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
                [self.view addSubview:avatar];
                
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
    [[TSFBManager sharedManager] inviteUserFriendsTheServerFacebook:self];
}


- (IBAction)actionEditing:(id)sender
{
    
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
                                                          [self presentViewController:controller animated:YES completion:nil];
                                                      }];
    
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"NO"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) { }];
    
    [alertController addAction:actionYes];
    [alertController addAction:actionNo];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
