//
//  TSContainerMatchViewController.m
//  Linker
//
//  Created by Mac on 16.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSContainerMatchViewController.h"
#import "TSMatchViewController.h"
#import "TSRetriveFriendsFBDatabase.h"

@import Firebase;
@import FirebaseDatabase;

@interface TSContainerMatchViewController ()

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation TSContainerMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ref = [[FIRDatabase database] reference];
    
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableArray *friends = [TSRetriveFriendsFBDatabase retriveFriendsDatabase:snapshot];
        
        TSMatchViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSMatchViewController"];
        controller.friends = friends;
        
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        [self.navigationController pushViewController:controller animated:NO];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
