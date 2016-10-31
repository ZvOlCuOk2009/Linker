//
//  TSUserViewController.m
//  Linker
//
//  Created by Mac on 15.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSUserViewController.h"
#import "TSLoginViewController.h"
#import "TSTableViewCell.h"
#import "TSTableViewCellHeader.h"
#import "TSProfileView.h"
#import "TSFireUser.h"
#import "TSFBManager.h"
#import "TSPrefixHeader.pch"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

@import Firebase;
@import FirebaseDatabase;

@interface TSUserViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) TSFireUser *fireUser;

@property (strong, nonatomic) NSArray *dataSourse;
@property (strong, nonatomic) NSMutableArray *dataSourseGrowth;
@property (strong, nonatomic) NSMutableArray *dataSourseWeight;
@property (strong, nonatomic) NSMutableArray *dataSourseAge;
@property (strong, nonatomic) NSArray *dataSourseFigure;
@property (strong, nonatomic) NSArray *dataSourseEyes;
@property (strong, nonatomic) NSArray *dataSourseHair;
@property (strong, nonatomic) NSArray *dataSourseTarget;

@property (strong, nonatomic) NSMutableArray *pickerViews;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TSUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tags = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21"];
    self.dataSourse = @[@"Познакомлюсь", @"Я ищу", @"В возрасте", @"С какой целью", @"Моя внешность", @"Рост", @"Вес", @"Фигура", @"Глаза", @"Волосы", @"Обо мне", @"Отношения", @"Дети", @"Доход", @"Образование", @"Языки", @"Жилье", @"Автомобиль", @"Хобби", @"Курение", @"Алкоголь"];
    
    self.dataSourseGrowth = [NSMutableArray array];
    self.dataSourseWeight = [NSMutableArray array];
    self.dataSourseFigure = [NSMutableArray array];
    self.dataSourseEyes = [NSMutableArray array];
    self.dataSourseHair = [NSMutableArray array];
    self.dataSourseAge = [NSMutableArray array];
    self.pickerViews = [NSMutableArray array];
    
    for (int i = 140; i < 220; i++) {
        NSString *row = [NSString stringWithFormat:@"%d", i];
        [self.dataSourseGrowth addObject:row];
    }
    
    for (int i = 40; i < 150; i++) {
        NSString *row = [NSString stringWithFormat:@"%d", i];
        [self.dataSourseWeight addObject:row];
    }
    
    for (int i = 18; i < 80; i++) {
        NSString *row = [NSString stringWithFormat:@"%d", i];
        [self.dataSourseAge addObject:row];
    }
    
    self.dataSourseFigure = @[@"Спортивная", @"Стройная", @"Пара лишних кило", @"Полная"];
    self.dataSourseEyes = @[@"Карие", @"Серые", @"Голубые", @"Зеленые"];
    self.dataSourseHair = @[@"Блонд", @"Руссые", @"Шатен", @"Брюнет", @"Черные", @"Седые", @"Cбриты"];
    self.dataSourseTarget = @[@"Дружба и переписка", @"Флирт", @"Секс", @"Романтические отношения", @"Создание семьи"];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}



/*

- (void)reloadView
{
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.fireUser = [TSFireUser initWithSnapshot:snapshot];
        
        FBSDKProfilePictureView *avatar = [[TSFBManager sharedManager] requestUserImageFromTheServerFacebook:self.avatarImageView ID:@"me"];
        avatar.layer.cornerRadius = avatar.frame.size.width / 2;
        avatar.layer.masksToBounds = YES;
        [self.view addSubview:avatar];
        
        
        
        NSDictionary *content = nil;
        
        if (self.fireUser.mission != nil && self.fireUser.about != nil &&
            self.fireUser.background != nil && self.fireUser.interest != nil) {
            
            NSString *mission = self.fireUser.mission;
            NSString *about = self.fireUser.about;
            NSString *background = self.fireUser.background;
            NSString *interest = self.fireUser.interest;
            
            content = @{@"mission":mission,
                        @"about":about,
                        @"background":background,
                        @"interest":interest};
            
        }
        
        
        TSProfileView *profileView = [TSProfileView profileView:content];
        
        NSURL *url = [NSURL URLWithString:self.fireUser.photoURL];
        
        profileView.nameLabel.text = self.fireUser.displayName;
        profileView.professionLabel.text = self.fireUser.profession;
        profileView.companyLabel.text = self.fireUser.company;
        profileView.currentArreaLabel.text = self.fireUser.currentArrea;
        
        
        if (self.fireUser.photoURL) {
            
            if (url && url.scheme && url.host) {
                
                profileView.avatarImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                                            [NSURL URLWithString:self.fireUser.photoURL]]];
            } else {
                
                NSData *data = [[NSData alloc]initWithBase64EncodedString:self.fireUser.photoURL options:NSDataBase64DecodingIgnoreUnknownCharacters];
                UIImage *convertImage = [UIImage imageWithData:data];
                profileView.avatarImageView.image = convertImage;
            }
        } else {
            
            profileView.avatarImageView.image = [UIImage imageNamed:@"placeholder_message"];
        }
        
        profileView.avatarImageView.layer.cornerRadius = profileView.avatarImageView.frame.size.width / 2;
        profileView.avatarImageView.layer.masksToBounds = YES;
        
        [self.view addSubview:profileView];
        
        
                                                                                                                                                [NSURL URLWithString:self.fireUser.photoURL]]];
        
    }];
    
    

}
 
 */



#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourse count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierHeader = @"header";
    static NSString *identifierCell = @"cell";
    
    
    if (indexPath.row == 0) {

        TSTableViewCellHeader *cell = (TSTableViewCellHeader *)[tableView dequeueReusableCellWithIdentifier:identifierHeader];
        if (!cell) {
            cell = [[TSTableViewCellHeader alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierHeader];
        }
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            if (IS_IPHONE_4) {
                
            } else if (IS_IPHONE_5) {
                
            } else if (IS_IPHONE_6) {
                
            } else if (IS_IPHONE_6_PLUS) {
                
            }
        }
        
        FBSDKProfilePictureView *background = [[TSFBManager sharedManager] requestUserImageFromTheServerFacebook:cell.backgroundImageView ID:@"me"];
        background.frame = CGRectMake(0, 0, 414, 414);
        
        FBSDKProfilePictureView *avatar = [[TSFBManager sharedManager] requestUserImageFromTheServerFacebook:cell.avatarImageView ID:@"me"];
        avatar.frame = CGRectMake(85, 85, 244, 244);
        
        avatar.layer.cornerRadius = avatar.frame.size.width / 2;
        avatar.layer.masksToBounds = YES;
        [cell addSubview:background];
        [cell addSubview:avatar];
        
        return  cell;
        
    }
    
    TSTableViewCell *cell = (TSTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifierCell];
    
    if (!cell) {
        cell = [[TSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    }
    
    
    if ([cell isKindOfClass:[TSTableViewCell class]]) {
        cell.titleLabel.text = [self.dataSourse objectAtIndex:indexPath.row];
        NSInteger tag = indexPath.row;
        cell.pickerView.tag = tag;
        [self.pickerViews addObject:cell.pickerView];
    }
    
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 5 || indexPath.row == 11) {
//        cell.pickerView.hidden = YES;
    }

    NSLog(@"Row %ld", indexPath.row);
    
    return  cell;
}



#pragma mark - UITableViewDelegate



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 414;
    }
    
    return 40;
}



#pragma mark - UIPickerViewDataSource



- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    
    switch (thePickerView.tag) {
        case 1:
            return 0;
            break;
        case 2:
            return 0;
            break;
        case 3:
            return self.dataSourseAge.count;
            break;
        case 4:
            return self.dataSourseTarget.count;
            break;
        case 5:
            return 0;
            break;
        case 6:
            return self.dataSourseGrowth.count;
            break;
        case 7:
            return self.dataSourseWeight.count;
            break;
        case 8:
            return self.dataSourseFigure.count;
            break;
        case 9:
            return self.dataSourseEyes.count;
            break;
        case 10:
            return self.dataSourseHair.count;
            break;
        default:
            return 0;
            break;
    }
    
}



- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    switch (thePickerView.tag) {
        case 1:
            return nil;
            break;
        case 2:
            return nil;
            break;
        case 3:
            return [self.dataSourseAge objectAtIndex:row];
            break;
        case 4:
            return [self.dataSourseTarget objectAtIndex:row];
            break;
        case 5:
            return nil;
            break;
        case 6:
            return [self.dataSourseGrowth objectAtIndex:row];
            break;
        case 7:
            return [self.dataSourseWeight objectAtIndex:row];
            break;
        case 8:
            return [self.dataSourseFigure objectAtIndex:row];
            break;
        case 9:
            return [self.dataSourseEyes objectAtIndex:row];
            break;
        case 10:
            return [self.dataSourseHair objectAtIndex:row];
            break;
        default:
            return 0;
            break;
    }
    
}


#pragma mark - UIPickerViewDelegate


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 0;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    [[pickerView.subviews objectAtIndex:1] setHidden:TRUE];
    [[pickerView.subviews objectAtIndex:2] setHidden:TRUE]; // убрать полосы pickerView
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, pickerView.frame.size.width, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = TEXT_COLOR;
    label.font = [UIFont fontWithName:@"System" size:17];
    label.textAlignment = NSTextAlignmentRight;
    
    
    switch (pickerView.tag) {
        case 1:
            return nil;
            break;
        case 2:
            return nil;
            break;
        case 3:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseAge objectAtIndex:row]];
            break;
        case 4:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseTarget objectAtIndex:row]];
            break;
        case 5:
            return nil;
            break;
        case 6:
            label.text = [NSString stringWithFormat:@"%@ см", [self.dataSourseGrowth objectAtIndex:row]];
            break;
        case 7:
            label.text = [NSString stringWithFormat:@"%@ кг", [self.dataSourseWeight objectAtIndex:row]];
            break;
        case 8:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseFigure objectAtIndex:row]];
            break;
        case 9:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseEyes objectAtIndex:row]];
            break;
        case 10:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseHair objectAtIndex:row]];
            break;
        default:
            return 0;
            break;
    }
    
    return label;    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch(component) {
        case 0:
            [self.dataSourseAge objectAtIndex:row];
            break;
        case 1:
            [self.dataSourseAge objectAtIndex:row];
            break;
        default:
            break;
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
