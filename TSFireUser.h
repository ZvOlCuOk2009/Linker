//
//  TSFireUser.h
//  Linker
//
//  Created by Mac on 15.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@import FirebaseAuth;
@import FirebaseDatabase;

@interface TSFireUser : NSObject

@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *photoURL;
@property (strong, nonatomic) NSString *profession;
@property (strong, nonatomic) NSString *commingFrom;
@property (strong, nonatomic) NSString *coingTo;
@property (strong, nonatomic) NSString *currentArrea;
@property (strong, nonatomic) NSString *launguage;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *mission;
@property (strong, nonatomic) NSString *about;
@property (strong, nonatomic) NSString *background;
@property (strong, nonatomic) NSString *interest;

+ (TSFireUser *)initWithSnapshot:(FIRDataSnapshot *)snapshot;

@end
