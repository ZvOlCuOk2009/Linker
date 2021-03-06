//
//  TSParsingManager.m
//  Linker
//
//  Created by Mac on 16.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSParsingManager.h"

@implementation TSParsingManager

+ (NSMutableArray *)parsingFriendsFacebook:(NSArray *)friendsData
{
    NSMutableArray *friends = [NSMutableArray array];
    
    for (int i = 0; i < [friendsData count]; i++) {
        NSDictionary *data = [friendsData objectAtIndex:i];
        NSString *name = [data objectForKey:@"name"];
        NSString *ID = [data objectForKey:@"id"];
        NSArray *arrayNameFriend = [NSArray arrayWithObjects:name, nil];
        NSArray *idFriend = [NSArray arrayWithObjects:ID, nil];
        NSMutableDictionary *friend = [NSMutableDictionary dictionary];
        [friend setObject:arrayNameFriend forKey:@"items"];
        [friend setObject:idFriend forKey:@"id"];
        [friends addObject:friend];
    }
    return friends;
}

@end
