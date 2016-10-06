//
//  TSMapKitViewController.m
//  Linker
//
//  Created by Mac on 16.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSMapKitViewController.h"
#import "TSSearchBar.h"
#import "TSPrefixHeader.pch"

#import <MapKit/MapKit.h>

@interface TSMapKitViewController ()

@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISlider *changeSlider;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation TSMapKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UISearchBar *searchBar = [[TSSearchBar alloc] initWithmapView:self.navBarView];
    [self.navBarView addSubview:searchBar];
    
    self.textField.layer.borderWidth = 1;
    self.textField.layer.borderColor = (__bridge CGColorRef _Nullable)(WHITE_COLOR);
    self.textField.layer.cornerRadius = 3;
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.layer.masksToBounds = YES;
    

    NSLocale *locale = [NSLocale currentLocale];
    NSArray *countryArray = [NSLocale ISOCountryCodes];
    
    NSMutableArray *sortedCountryArray = [[NSMutableArray alloc] init];
    
    for (NSString *countryCode in countryArray) {
        
        NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
        [sortedCountryArray addObject:displayNameString];
        
    }
    
}


- (void)searchRegion:(NSString *)text
{
    
    __block NSString *location = nil;
    
    MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] init];
    [searchRequest setNaturalLanguageQuery:text];
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (!error) {
            for (MKMapItem *mapItem in [response mapItems]) {
                
                location = [mapItem name];
                NSLog(@"Location: %@, Placemark title: %@", location, [[mapItem placemark] title]);
            }
        } else {
            NSLog(@"Search Request Error: %@", [error localizedDescription]);
        }
    }];
    
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = location;
    request.region = self.mapView.region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
     {
         NSMutableArray *placemarks = [NSMutableArray array];
         for (MKMapItem *item in response.mapItems) {
             [placemarks addObject:item.placemark];
         }
         [self.mapView showAnnotations:placemarks animated:NO];
     }];
    
}


- (IBAction)testButton:(id)sender
{
    [self searchRegion:self.textField.text];
}


- (IBAction)changeSlider:(UISlider *)sender
{
    NSLog(@"slider %f", [sender value]);
    
    UIImageView *handleView = [_changeSlider.subviews lastObject];
    UILabel *label = (UILabel*)[handleView viewWithTag:1000];
    
    if (!label) {
        
        label = [[UILabel alloc] initWithFrame:handleView.bounds];
        label.tag = 1000;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = GREEN_COLOR;
        label.textAlignment = NSTextAlignmentCenter;
        [handleView addSubview:label];
        
    }
    
    label.text = [NSString stringWithFormat:@"%0.0f", self.changeSlider.value];

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
