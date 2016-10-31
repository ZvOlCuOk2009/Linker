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
        
        FIRDataSnapshot *userGender = fireUser.value[@"gender"];
        FIRDataSnapshot *userAge = fireUser.value[@"age"];
        FIRDataSnapshot *userTarget = fireUser.value[@"target"];
        FIRDataSnapshot *userGrowth = fireUser.value[@"growth"];
        FIRDataSnapshot *userWeight = fireUser.value[@"weight"];
        FIRDataSnapshot *userFigure = fireUser.value[@"figure"];
        FIRDataSnapshot *userEyes = fireUser.value[@"eyes"];
        FIRDataSnapshot *userHair = fireUser.value[@"hair"];
        FIRDataSnapshot *userRelations = fireUser.value[@"relations"];
        FIRDataSnapshot *userChilds = fireUser.value[@"childs"];
        FIRDataSnapshot *userEarnings = fireUser.value[@"earnings"];
        FIRDataSnapshot *userEducation = fireUser.value[@"education"];
        FIRDataSnapshot *userLaunguages = fireUser.value[@"launguages"];
        FIRDataSnapshot *userHousing = fireUser.value[@"housing"];
        FIRDataSnapshot *userCar = fireUser.value[@"car"];
        FIRDataSnapshot *userHobby = fireUser.value[@"hobby"];
        FIRDataSnapshot *userSmoking = fireUser.value[@"smoking"];
        FIRDataSnapshot *userAlcohole = fireUser.value[@"alcohole"];
        
        
        user.uid = (NSString *)userIdent;
        user.displayName = (NSString *)userName;
        user.email = (NSString *)userEmail;
        user.photoURL = (NSString *)userPhoto;
        
        user.gender = (NSString *)userGender;
        user.age = (NSString *)userAge;
        user.target = (NSString *)userTarget;
        user.growth = (NSString *)userGrowth;
        user.weight = (NSString *)userWeight;
        user.figure = (NSString *)userFigure;
        user.eyes = (NSString *)userEyes;
        user.hair = (NSString *)userHair;
        user.relations = (NSString *)userRelations;
        user.childs = (NSString *)userChilds;
        user.earnings = (NSString *)userEarnings;
        user.education = (NSString *)userEducation;
        user.launguages = (NSString *)userLaunguages;
        user.housing = (NSString *)userHousing;
        user.car = (NSString *)userCar;
        user.hobby = (NSString *)userHobby;
        user.smoking = (NSString *)userSmoking;
        user.alcohole = (NSString *)userAlcohole;
        
    }
    
    return user;
}

@end
