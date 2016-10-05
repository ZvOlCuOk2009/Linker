//
//  TSSettingScrollViewController.m
//  Linker
//
//  Created by Mac on 05.10.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSSettingScrollViewController.h"
#import "TSHomeViewController.h"
#import "TSSettingViewController.h"
#import "TSFireUser.h"

#import <MapKit/MapKit.h>

@import Firebase;
@import FirebaseDatabase;

@class MKMapView;

@interface TSSettingScrollViewController () <MKMapViewDelegate>

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) TSFireUser *fireUser;
@property (strong, nonatomic) FIRUser *user;
@property (weak, nonatomic) IBOutlet UIButton *meLocationButton;
@property (weak, nonatomic) IBOutlet UISwitch *switchLocationUser;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) NSInteger counter;
@property (strong, nonatomic) NSString *locality;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *country;

@end

@implementation TSSettingScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.counter = 0;
    
    self.ref = [[FIRDatabase database] reference];
    self.user = [FIRAuth auth].currentUser;
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 2.0;
    [self.mapView addGestureRecognizer:longPressGestureRecognizer];
}


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


- (IBAction)switchMeLocation:(id)sender
{
    if (self.switchLocationUser.isOn) {
        self.meLocationButton.userInteractionEnabled = YES;
        self.meLocationButton.hidden = NO;
    } else {
        self.meLocationButton.userInteractionEnabled = NO;
        self.meLocationButton.hidden = YES;
    }
}


- (IBAction)backButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self saveDataToDataBase];
}


- (void)saveDataToDataBase
{
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.fireUser = [TSFireUser initWithSnapshot:snapshot];
        
        NSDictionary *userData = nil;
        
        
        NSString *profession = nil;
        NSString *coingTo = nil;
        NSString *city = nil;
        NSString *mission = nil;
        NSString *about = nil;
        NSString *background = nil;
        NSString *interest = nil;
        
        
        profession = self.fireUser.profession;
        coingTo = self.fireUser.coingTo;
        
        if (self.locality) {
            city = [NSString stringWithFormat:@"%@, %@", self.locality, self.country];
        } else {
            city = [NSString stringWithFormat:@"%@, %@", self.name, self.country];
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
                     @"coingTo":coingTo,
                     @"city":city,
                     @"mission":mission,
                     @"about":about,
                     @"background":background,
                     @"interest":interest};
        
        
        [[[[self.ref child:@"users"] child:self.user.uid] child:@"username"] setValue:userData];
        
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
