//
//  TSSearchBar.m
//  Linker
//
//  Created by Mac on 17.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSSearchBar.h"
#import "TSPrefixHeader.pch"

@implementation TSSearchBar

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        self = [[TSSearchBar alloc] initWithFrame:CGRectMake(view.bounds.size.width / 2, - 5,
                                                             view.bounds.size.width / 2, 44)];
    }
    return self;
}


- (instancetype)initWithmapView:(UIView *)mapView
{
    self = [super init];
    if (self) {
        self = [[TSSearchBar alloc] initWithFrame:CGRectMake(5, 20, 365, 50)];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    self.searchBarStyle = UISearchBarStyleMinimal;
    self.tintColor = WHITE_COLOR;
    UITextField *txtSearchField = [self valueForKey:@"_searchField"];
    txtSearchField.layer.cornerRadius = 4;
    txtSearchField.layer.borderWidth = 1.0f;
    txtSearchField.layer.borderColor = WHITE_COLOR.CGColor;
    txtSearchField.textColor = WHITE_COLOR;
}

@end
