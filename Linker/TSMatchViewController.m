//
//  TSMatchViewController.m
//  Linker
//
//  Created by Mac on 16.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSMatchViewController.h"
#import "ZLSwipeableView.h"
#import "TSProfileView.h"

static NSInteger counter = 0;

@import Firebase;
@import FirebaseDatabase;

@interface TSMatchViewController () <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate>

@property (weak, nonatomic) TSProfileView *profileView;
@property (strong, nonatomic) ZLSwipeableView *swipeableView;

@end

@implementation TSMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect frame = CGRectMake(0, - 20, self.view.bounds.size.width, self.view.bounds.size.height);
    
    self.swipeableView = [[ZLSwipeableView alloc] initWithFrame:self.view.frame];
    self.swipeableView.frame = frame;
    [self.view addSubview:self.swipeableView];
    
    self.swipeableView.dataSource = self;
    self.swipeableView.delegate = self;
    
    [self.swipeableView swipeTopViewToLeft];
    [self.swipeableView swipeTopViewToRight];
    
    [self.swipeableView discardAllViews];
    [self.swipeableView loadViewsIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ZLSwipeableViewDataSource


- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:counter inSection:0];
    
        if (self.friends.count > 0) {
    
            NSDictionary *indexCard = [self.friends objectAtIndex:indexPath.row];
            
            
            NSString *mission = [indexCard objectForKey:@"mission"];
            NSString *about = [indexCard objectForKey:@"about"];
            NSString *background = [indexCard objectForKey:@"background"];
            NSString *interest = [indexCard objectForKey:@"interest"];
            
            if (mission == nil) {
                mission = @"";
            }
            
            if (about == nil) {
                about = @"";
            }
            
            if (background == nil) {
                background = @"";
            }
            
            if (interest == nil) {
                interest = @"";
            }
            
            NSDictionary *content = @{@"mission":mission,
                                      @"about":about,
                                      @"background":background,
                                      @"interest":interest};
            
            self.profileView = [TSProfileView profileView:content];
            
            
            NSInteger max = [self.friends count];
            
            
            NSString *nameFriend = [indexCard objectForKey:@"items"];
            __block NSString *photoURL = [indexCard objectForKey:@"photoURL"];
            NSString *profession = [indexCard objectForKey:@"profession"];
            NSString *company = [indexCard objectForKey:@"company"];
            NSString *currentArrea = [indexCard objectForKey:@"currentArrea"];
            
            
            NSURL *url = [NSURL URLWithString:photoURL];
            
            
            self.profileView.nameLabel.text = nameFriend;
            self.profileView.professionLabel.text = profession;
            self.profileView.companyLabel.text = company;
            self.profileView.currentArreaLabel.text = currentArrea;
            
            if (url && url.scheme && url.host) {
                
                NSData *dataImage = [NSData dataWithContentsOfURL:url];
                self.profileView.avatarImageView.image = [UIImage imageWithData:dataImage];
                
            } else {
                
                if (!photoURL) {
                    photoURL = @"";
                }
                
                NSData *data = [[NSData alloc]initWithBase64EncodedString:photoURL options:NSDataBase64DecodingIgnoreUnknownCharacters];
                UIImage *convertImage = [UIImage imageWithData:data];
                self.profileView.avatarImageView.image = convertImage;
            }
            
            self.profileView.avatarImageView.layer.cornerRadius = self.profileView.avatarImageView.frame.size.width / 2;
            self.profileView.avatarImageView.layer.masksToBounds = YES;
            
            ++counter;
            
            if (counter == max) {
                counter = 0;
            }
    
    
        } else {
    
            if  (!self.friends.count)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Here you will see your friends have installed ""Triper""..."
                                                                                         message:@""
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action  = [UIAlertAction actionWithTitle:@"Ok"
                                                                  style:UIAlertActionStyleCancel
                                                                handler:^(UIAlertAction * _Nonnull action) { }];
                [alertController addAction:action];
                [self presentViewController:alertController animated:YES completion:nil];
    
                return nil;
            }
    
        }
    
    return self.profileView;
    
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
