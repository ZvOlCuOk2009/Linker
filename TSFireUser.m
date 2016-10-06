//
//  TSFireUser.m
//  Linker
//
//  Created by Mac on 15.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSFireUser.h"

@implementation TSFireUser

+ (TSFireUser *)initWithSnapshot:(FIRDataSnapshot *)snapshot
{
    
    TSFireUser *user = [[TSFireUser alloc] init];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    
    if(token)
    {
        NSString *currentID = [FIRAuth auth].currentUser.uid;
        NSString *key = [NSString stringWithFormat:@"users/%@/username", currentID];
        
        FIRDataSnapshot *fireUser = [snapshot childSnapshotForPath:key];
        
        FIRDataSnapshot *userIdent = fireUser.value[@"userID"];
        FIRDataSnapshot *userName = fireUser.value[@"displayName"];
        FIRDataSnapshot *userEmail = fireUser.value[@"email"];
        FIRDataSnapshot *userPhoto = fireUser.value[@"photoURL"];
        FIRDataSnapshot *userProfession = fireUser.value[@"profession"];
        FIRDataSnapshot *userCompany = fireUser.value[@"company"];
        FIRDataSnapshot *userCurrentArrea = fireUser.value[@"city"];
        FIRDataSnapshot *userMission = fireUser.value[@"mission"];
        FIRDataSnapshot *userAbout = fireUser.value[@"about"];
        FIRDataSnapshot *userBackground = fireUser.value[@"background"];
        FIRDataSnapshot *userInterest = fireUser.value[@"interest"];
        
        
        user.uid = (NSString *)userIdent;
        user.displayName = (NSString *)userName;
        user.email = (NSString *)userEmail;
        user.photoURL = (NSString *)userPhoto;
        user.profession = (NSString *)userProfession;
        user.company = (NSString *)userCompany;
        user.currentArrea = (NSString *)userCurrentArrea;
        user.mission = (NSString *)userMission;
        user.about = (NSString *)userAbout;
        user.background = (NSString *)userBackground;
        user.interest = (NSString *)userInterest;
    }
    
    return user;
}

@end
