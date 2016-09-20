//
//  TSFBManager.h
//  Linker
//
//  Created by Mac on 16.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>


@interface TSFBManager : NSObject <FBSDKAppInviteDialogDelegate>

+ (TSFBManager *)sharedManager;

- (void)requestUserFriendsTheServerFacebook:(void(^)(NSArray *friends)) success;
- (FBSDKProfilePictureView *)requestUserImageFromTheServerFacebook:(UIImageView *)currentImageView ID:(NSString *)ID;
- (void)inviteUserFriendsTheServerFacebook:(UIViewController *)controller;
- (void)logOutUser;

@end
