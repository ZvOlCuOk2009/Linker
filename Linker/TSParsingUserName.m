//
//  TSParsingUserName.m
//  Linker
//
//  Created by Mac on 29.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSParsingUserName.h"

@implementation TSParsingUserName

+ (NSMutableArray *)parsingOfTheUserName:(NSArray *)friends
{
    NSMutableArray *namesArray = [NSMutableArray array];
    
    for (int i = 0; i < [friends count]; i++) {
        NSDictionary *data = [friends objectAtIndex:i];
        NSArray *dataName = [data objectForKey:@"items"];
        NSString *name = [dataName objectAtIndex:0];
        [namesArray addObject:name];
    }
    return namesArray;
}


@end
