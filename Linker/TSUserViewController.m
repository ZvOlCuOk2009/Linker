//
//  TSUserViewController.m
//  Linker
//
//  Created by Mac on 15.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSUserViewController.h"
#import "TSLoginViewController.h"
#import "TSProfileView.h"
#import "TSFireUser.h"
#import "TSFBManager.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@import Firebase;
@import FirebaseDatabase;

@interface TSUserViewController ()

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) TSFireUser *fireUser;

@end

@implementation TSUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ref = [[FIRDatabase database] reference];
    
    
    [self reloadView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadView];
    });
    
    [[TSFBManager sharedManager] requestUserDataFromTheServerFacebook];
    
    NSLog(@"token %@", [[FBSDKAccessToken currentAccessToken] tokenString]);
}


- (void)reloadView
{
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.fireUser = [TSFireUser initWithSnapshot:snapshot];
        
        NSDictionary *content = nil;
        
        if (self.fireUser.mission != nil && self.fireUser.about != nil &&
            self.fireUser.background != nil && self.fireUser.interest != nil) {
            
            NSString *mission = self.fireUser.mission;
            NSString *about = self.fireUser.about;
            NSString *background = self.fireUser.background;
            NSString *interest = self.fireUser.interest;
            
            content = @{@"mission":mission,
                        @"about":about,
                        @"background":background,
                        @"interest":interest};
            
        }
        
        
        TSProfileView *profileView = [TSProfileView profileView:content];
        
        NSURL *url = [NSURL URLWithString:self.fireUser.photoURL];
        
        profileView.nameLabel.text = self.fireUser.displayName;
        profileView.professionLabel.text = self.fireUser.profession;
        profileView.comingFromLabel.text = self.fireUser.commingFrom;
        profileView.coingToLabel.text = self.fireUser.coingTo;
        profileView.currentArreaLabel.text = self.fireUser.currentArrea;
        profileView.miniNameLabel.text = self.fireUser.uid;
        profileView.launguageLabel.text = self.fireUser.launguage;
        profileView.ageLabel.text = self.fireUser.age;
        
        
        if (self.fireUser.photoURL) {
            
            if (url && url.scheme && url.host) {
                
                profileView.avatarImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                                            [NSURL URLWithString:self.fireUser.photoURL]]];
            } else {
                
                NSData *data = [[NSData alloc]initWithBase64EncodedString:self.fireUser.photoURL options:NSDataBase64DecodingIgnoreUnknownCharacters];
                UIImage *convertImage = [UIImage imageWithData:data];
                profileView.avatarImageView.image = convertImage;
            }
        } else {
            
            profileView.avatarImageView.image = [UIImage imageNamed:@"placeholder_message"];
        }
        
        profileView.avatarImageView.layer.cornerRadius = profileView.avatarImageView.frame.size.width / 2;
        profileView.avatarImageView.layer.masksToBounds = YES;
        
        [self.view addSubview:profileView];
        
    }];

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
