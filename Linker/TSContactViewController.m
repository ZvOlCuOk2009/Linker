//
//  TSContactViewController.m
//  Linker
//
//  Created by Mac on 17.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSContactViewController.h"
#import "TSView.h"
#import "TSSearchBar.h"
#import "TSTableViewCell.h"
#import "TSFBManager.h"
#import "TSCellView.h"
#import "TSPrefixHeader.pch"
#import "TSParsingManager.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@import Firebase;
@import FirebaseDatabase;

@interface TSContactViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *friends;
@property (strong, nonatomic) NSString *currentID;
@property (strong, nonatomic) NSMutableArray *friendsIDs;
@property (strong, nonatomic) NSMutableArray *imageFriends;
@property (strong, nonatomic) NSMutableArray *arrayFriends;
@property (strong, nonatomic) TSCellView *cell;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRUser *user;

@end

@implementation TSContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.ref = [[FIRDatabase database] reference];
    
    
    [[TSFBManager sharedManager] requestUserFriendsTheServerFacebook:^(NSArray *friends)
     {
         self.friends = [TSParsingManager parsingFriendsFacebook:friends];
         [self.tableView reloadData];
         self.arrayFriends = [NSMutableArray arrayWithArray:self.friends];
         
         if (self.friends.count == 0) {
             
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Here you will see your friends have installed ""Triper"" on its device..."
                                                                                      message:nil
                                                                               preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                
                                                            }];
             
             [alertController addAction:action];
             
             [self presentViewController:alertController animated:YES completion:nil];
         }
     }];
    
    
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSString *key = [NSString stringWithFormat:@"users/%@/friends", self.user.uid];
        FIRDataSnapshot *friendSnapshot = [snapshot childSnapshotForPath:key];
        
        for (int i = 0; i < friendSnapshot.childrenCount; i++) {
            NSString *key = [NSString stringWithFormat:@"key%d", i];
            FIRDataSnapshot *pair = [friendSnapshot childSnapshotForPath:key];
            FIRDataSnapshot *ID = pair.value[@"fireUserID"];
            [self.friendsIDs addObject:ID];
        }
    }];
    
    
    self.imageFriends = [NSMutableArray array];
    self.friendsIDs = [NSMutableArray array];
    self.user = [FIRAuth auth].currentUser;
    
    
    TSView *grayRect = [[TSView alloc] initWithView:self.view];
    [self.view addSubview:grayRect];
    
    UISearchBar *searchBar = [[TSSearchBar alloc] initWithView:self.view];
    [self.view addSubview:searchBar];
    searchBar.delegate = self;
    
    self.tableView.contentInset = UIEdgeInsetsMake(36, 0, 46, 0);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSourece


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.friends) {
        
        return self.friends.count;
        
    } else {
        
        return 0;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *currentSection = [self.friends objectAtIndex:section];
    if ([[currentSection objectForKey:@"isOpen"] boolValue]) {
        NSArray *items = [currentSection objectForKey:@"items"];
        return items.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"detail";
    
    TSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[TSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *index = [self.imageFriends objectAtIndex:indexPath.section];
    
    FBSDKProfilePictureView *avatar = [[TSFBManager sharedManager]
                                       requestUserImageFromTheServerFacebook:cell.avatarUser ID:index];
    avatar.layer.cornerRadius = avatar.frame.size.width / 2;
    avatar.clipsToBounds = YES;
    [cell.blueRectangle addSubview:avatar];
    
    return cell;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *currentSection = [self.friends objectAtIndex:section];
    NSArray *dataNameFriend = [currentSection objectForKey:@"items"];
    NSString *nameFriend = [dataNameFriend objectAtIndex:0];
    
    NSArray *dataIDFriend = [currentSection objectForKey:@"id"];
    NSString *idFriend = [dataIDFriend objectAtIndex:0];
    
//    self.isOpen = [[currentSection objectForKey:@"isOpen"] boolValue];
    
    self.cell = [TSCellView cellView];
    self.cell.nameLabel.text = nameFriend;
    self.cell.titleLabel.text = nameFriend;
    self.cell.companyLabel.text = idFriend;
    
    FBSDKProfilePictureView *avatar = [[TSFBManager sharedManager]
                                       requestUserImageFromTheServerFacebook:self.cell.avatarImageView ID:idFriend];
    avatar.layer.cornerRadius = avatar.frame.size.width / 2;
    avatar.clipsToBounds = YES;
    [self.cell addSubview:avatar];
    
    [self.imageFriends addObject:idFriend];
    
    UIButton *button = [[UIButton alloc] init];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            button.frame = CGRectMake(275.0f, 39.0f, 22.0f, 22.0f);
        } else if (IS_IPHONE_5) {
            button.frame = CGRectMake(275.0f, 39.0f, 22.0f, 22.0f);
        } else if (IS_IPHONE_6) {
            button.frame = CGRectMake(323.0f, 46.0f, 26.0f, 26.0f);
        } else if (IS_IPHONE_6_PLUS) {
            button.frame = CGRectMake(357.0f, 51.0f, 29.0f, 29.0f);
        }
    }
    
    button.tag = section;
    
    [button addTarget:self action:@selector(didSelectSection:) forControlEvents:UIControlEventTouchUpInside];
    [self.cell addSubview:button];
    
    return self.cell;
}



- (void)didSelectSection:(UIButton *)sender
{
    
    NSMutableDictionary *currentSection = [self.friends objectAtIndex:sender.tag];
    
    NSArray *items = [currentSection objectForKey:@"items"];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 0; i < items.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sender.tag]];
    }
    
    
    NSDictionary *currentDict = [self.friends objectAtIndex:sender.tag];
    
    self.currentID = [currentDict objectForKey:@"id"];
    
    BOOL isOpen = [[currentSection objectForKey:@"isOpen"] boolValue];
    
    [currentSection setObject:[NSNumber numberWithBool:!isOpen] forKey:@"isOpen"];
    
    if (isOpen) {
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    } else {
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
    
}


#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    CGFloat height;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            height = 100;
        } else if (IS_IPHONE_5) {
            height = 100;
        } else if (IS_IPHONE_6) {
            height = 118;
        } else if (IS_IPHONE_6_PLUS) {
            height = 130;
        }
    }
    return height;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            height = 67;
        } else if (IS_IPHONE_5) {
            height = 67;
        } else if (IS_IPHONE_6) {
            height = 79;
        } else if (IS_IPHONE_6_PLUS) {
            height = 87;
        }
    }
    return height;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
