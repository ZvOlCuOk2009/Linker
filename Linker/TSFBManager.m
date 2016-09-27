//
//  TSFBManager.m
//  Linker
//
//  Created by Mac on 16.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSFBManager.h"

#import <GoogleSignIn/GoogleSignIn.h>

@import FirebaseAuth;


@implementation TSFBManager

#pragma mark - Singleton


+ (TSFBManager *)sharedManager
{
    static TSFBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TSFBManager alloc] init];
    });
    return manager;
}


#pragma mark - FBSDKGraphRequest


- (void)requestUserFriendsTheServerFacebook:(void(^)(NSArray *friends))success
{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends"
                                       parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if (!error) {
             NSArray * friendList = [result objectForKey:@"data"];
             if (success) {
                 success(friendList);
             }
         } else {
             NSLog(@"Error %@", [error localizedDescription]);
         }
     }];
}


- (void)requestUserDataFromTheServerFacebook
{
    
    NSDictionary * parameters = @{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio, location, friends, hometown, friendlists"};
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" // all friends "me/taggable_friends"
                                       parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error)
         {
             NSLog(@"resultis User Data = %@", result);
         } else {
             NSLog(@"Error %@", error);
         }
     }];
    
}


#pragma mark - FBSDKProfilePictureView


- (FBSDKProfilePictureView *)requestUserImageFromTheServerFacebook:(UIImageView *)currentImageView ID:(NSString *)ID
{
    
    FBSDKProfilePictureView *profilePictureview = [[FBSDKProfilePictureView alloc]initWithFrame:currentImageView.frame];
    [profilePictureview setProfileID:ID];
    return profilePictureview;
}


#pragma mark - FBSDKAppInviteDialogDelegate



- (void)inviteUserFriendsTheServerFacebook:(UIViewController *)controller
{
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:@"https://fb.me/1745102679089901"]; //https://fb.me/1453356328318807
    [FBSDKAppInviteDialog showFromViewController:controller withContent:content delegate:self];
}


- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results {
    NSLog(@"results = %@", results);
}


- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error {
    NSLog(@"error = %@", error);
}


#pragma mark - logOutFacebook


- (void)logOutUser
{
    [[[FBSDKLoginManager alloc] init] logOut];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
    [[GIDSignIn sharedInstance] signOut];
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        NSLog(@"Log out");
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
}


@end
