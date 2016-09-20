//
//  TSSaveFriendsFBDatabase.h
//  Linker
//
//  Created by Mac on 16.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@import FirebaseAuth;
@import FirebaseDatabase;

@interface TSSaveFriendsFBDatabase : NSObject

+ (void)saveFriendsDatabase:(FIRUser *)user userFriend:(NSArray *)friends;

@end
