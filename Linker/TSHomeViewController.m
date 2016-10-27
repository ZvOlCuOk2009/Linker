//
//  TSHomeViewController.m
//  Linker
//
//  Created by Mac on 16.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSHomeViewController.h"
#import "TSFireUser.h"
#import "TSFBManager.h"
#import "TSLoginViewController.h"
#import "TSPrefixHeader.pch"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <MapKit/MapKit.h>

@import Firebase;
@import FirebaseDatabase;

@interface TSHomeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UIButton *outButton;
@property (weak, nonatomic) IBOutlet UIButton *meLocationButton;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) TSFireUser *fireUser;
@property (strong, nonatomic) FIRUser *user;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) NSInteger counter;
@property (strong, nonatomic) NSString *locality;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *country;

@end

@implementation TSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ref = [[FIRDatabase database] reference];
    
    self.inviteButton.layer.masksToBounds = YES;
    
    [self addAvatar];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                                                initWithTarget:self action:@selector(handleLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 2.0;
    [self.mapView addGestureRecognizer:longPressGestureRecognizer];

    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            
        } else if (IS_IPHONE_5) {
            
        } else if (IS_IPHONE_6) {
            
        } else if (IS_IPHONE_6_PLUS) {
            
        }
    }
    
}


- (void)addAvatar
{
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        TSFireUser *fireUser = [TSFireUser initWithSnapshot:snapshot];
        
        NSURL *url = [NSURL URLWithString:fireUser.photoURL];
        
        if (url && url.scheme && url.host) {
            
            if ([self verificationURL:fireUser.photoURL]) {
                FBSDKProfilePictureView *avatar = [[TSFBManager sharedManager] requestUserImageFromTheServerFacebook:self.avatarImageView ID:@"me"];
                avatar.layer.cornerRadius = avatar.frame.size.width / 2;
                avatar.layer.masksToBounds = YES;
                [self.view addSubview:avatar];
                
            } else {
                self.avatarImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                                     [NSURL URLWithString:fireUser.photoURL]]];
            }
            
        } else {
            
            NSData *data = [[NSData alloc]initWithBase64EncodedString:fireUser.photoURL options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *convertImage = [UIImage imageWithData:data];
            self.avatarImageView.image = convertImage;
        }
    }];
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
    self.avatarImageView .layer.masksToBounds = YES;
    
}


#pragma mark - Actions


- (IBAction)actionInviteFriends:(id)sender
{
    [[TSFBManager sharedManager] inviteUserFriendsTheServerFacebook:self];
}


- (IBAction)backButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self saveDataToDataBase];
}



- (IBAction)actionLogOut:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Do you want to exit the application?"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"YES"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [[TSFBManager sharedManager] logOutUser];
                                                          
                                                          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                                          
                                                          TSLoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"TSLoginViewController"];
                                                          [self presentViewController:controller animated:YES completion:nil];
                                                      }];
    
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"NO"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) { }];
    
    [alertController addAction:actionYes];
    [alertController addAction:actionNo];
    
    [self presentViewController:alertController animated:YES completion:nil];
}



- (BOOL)verificationURL:(NSString *)url
{
    BOOL verification;
    NSArray *component = [url componentsSeparatedByString:@"."];
    NSString *firstComponent = [component firstObject];
    
    if ([firstComponent isEqualToString:@"https://scontent"]) {
        verification = YES;
    } else {
        verification = NO;
    }
    return verification;
}


#pragma mark - Save Data to Base



- (void)saveDataToDataBase
{
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.fireUser = [TSFireUser initWithSnapshot:snapshot];
        
        NSDictionary *userData = nil;
        
        
        NSString *profession = nil;
        NSString *company = nil;
        NSString *city = nil;
        NSString *mission = nil;
        NSString *about = nil;
        NSString *background = nil;
        NSString *interest = nil;
        
        
        profession = self.fireUser.profession;
        company = self.fireUser.company;
        
        if (self.locality) {
            city = [NSString stringWithFormat:@"%@", self.locality];
        } else {
            city = [NSString stringWithFormat:@"%@", self.name];
        }
        
        mission = self.fireUser.mission;
        about = self.fireUser.about;
        background = self.fireUser.background;
        interest = self.fireUser.interest;
        
        
        userData = @{@"displayName":self.fireUser.displayName,
                     @"email":self.fireUser.email,
                     @"photoURL":self.fireUser.photoURL,
                     @"userID":self.fireUser.uid,
                     @"profession":profession,
                     @"company":company,
                     @"city":city,
                     @"mission":mission,
                     @"about":about,
                     @"background":background,
                     @"interest":interest};
        
        
        [[[[self.ref child:@"users"] child:self.user.uid] child:@"username"] setValue:userData];
        
    }];
}


#pragma mark - MapKit


- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    if (self.counter == 0)
    {
        CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = touchMapCoordinate;
        NSLog(@"annotation latitude - %f, annotation longitude %f",
              annotation.coordinate.latitude,
              annotation.coordinate.longitude);
        [self locationManager:annotation];
        [self.mapView addAnnotation:annotation];
        self.counter = 1;
    } else {
        [self.mapView removeAnnotations:self.mapView.annotations];
        self.counter = 0;
    }
    
}


- (void)locationManager:(MKPointAnnotation *)locations
{
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:locations.coordinate.latitude
                                                      longitude:locations.coordinate.longitude];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark * placemark in placemarks) {
            self.locality = [placemark locality];
            self.name = [placemark name];
            self.country  = [placemark country];
            NSLog(@"locality %@", self.locality);
            NSLog(@"name %@", self.name);
            NSLog(@"country %@", self.country);
        }
        
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
