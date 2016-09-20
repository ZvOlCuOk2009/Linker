//
//  TSRetriveFriendsFBDatabase.h
//  Linker
//
//  Created by Mac on 16.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Firebase;
@import FirebaseDatabase;

@interface TSRetriveFriendsFBDatabase : NSObject

+ (NSMutableArray *)retriveFriendsDatabase:(FIRDataSnapshot *)snapshot;

@end
