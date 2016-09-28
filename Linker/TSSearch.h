//
//  TSSearch.h
//  Linker
//
//  Created by Mac on 29.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSSearch : NSObject

+ (NSMutableArray *)calculationSearchArray:(NSArray *)incomingArray
                                      text:(NSString *)searchString;

@end
