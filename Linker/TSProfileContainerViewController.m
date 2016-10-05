//
//  TSProfileContainerViewController.m
//  Linker
//
//  Created by Mac on 16.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSProfileContainerViewController.h"
#import "TSFBManager.h"
#import "TSProfileView.h"
#import "TSView.h"
#import "TSFireUser.h"

@import Firebase;
@import FirebaseDatabase;

@interface TSProfileContainerViewController ()

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation TSProfileContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.ref = [[FIRDatabase database] reference];
    
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        TSFireUser *fireUser = [TSFireUser initWithSnapshot:snapshot];
        
        NSDictionary *content = nil;
        
        if (fireUser.mission != nil && fireUser.about != nil &&
            fireUser.background != nil && fireUser.interest != nil) {
            
            NSString *mission = fireUser.mission;
            NSString *about = fireUser.about;
            NSString *background = fireUser.background;
            NSString *interest = fireUser.interest;
            
            content = @{@"mission":mission,
                        @"about":about,
                        @"background":background,
                        @"interest":interest};
        }
        
        TSProfileView *profileView = [TSProfileView profileView:content];
        profileView.frame = CGRectMake((self.view.frame.size.width - profileView.frame.size.width) / 2, 55, profileView.frame.size.width, profileView.frame.size.height);
        profileView.likeView.hidden = YES;
        
        profileView.nameLabel.text = fireUser.displayName;
        profileView.professionLabel.text = fireUser.profession;
        profileView.coingToLabel.text = fireUser.coingTo;
        profileView.currentArreaLabel.text = fireUser.currentArrea;
        
        NSURL *url = [NSURL URLWithString:fireUser.photoURL];
        
        if (url && url.scheme && url.host) {
            
            profileView.avatarImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                                        [NSURL URLWithString:fireUser.photoURL]]];
        } else {
            
            NSData *data = [[NSData alloc]initWithBase64EncodedString:fireUser.photoURL options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *convertImage = [UIImage imageWithData:data];
            profileView.avatarImageView.image = convertImage;
        }
        
        profileView.avatarImageView.layer.cornerRadius = profileView.avatarImageView.frame.size.width / 2;
        profileView.avatarImageView.layer.masksToBounds = YES;
        
        [self.view addSubview:profileView];
    }];
    
    
    TSView *grayRect = [[TSView alloc] initWithView:self.view];
    [self.view addSubview:grayRect];
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
