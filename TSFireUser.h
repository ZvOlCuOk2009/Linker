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

@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *target;
@property (strong, nonatomic) NSString *growth;
@property (strong, nonatomic) NSString *weight;
@property (strong, nonatomic) NSString *figure;
@property (strong, nonatomic) NSString *eyes;
@property (strong, nonatomic) NSString *hair;
@property (strong, nonatomic) NSString *relations;
@property (strong, nonatomic) NSString *childs;
@property (strong, nonatomic) NSString *earnings;
@property (strong, nonatomic) NSString *education;
@property (strong, nonatomic) NSString *launguages;
@property (strong, nonatomic) NSString *housing;
@property (strong, nonatomic) NSString *car;
@property (strong, nonatomic) NSString *hobby;
@property (strong, nonatomic) NSString *smoking;
@property (strong, nonatomic) NSString *alcohole;

+ (TSFireUser *)initWithSnapshot:(FIRDataSnapshot *)snapshot;

@end
