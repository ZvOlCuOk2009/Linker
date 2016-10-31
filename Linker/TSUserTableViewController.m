//
//  TSUserTableViewController.m
//  Linker
//
//  Created by Mac on 28.10.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSUserTableViewController.h"
#import "TSFBManager.h"
#import "TSPrefixHeader.pch"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@import Firebase;
@import FirebaseDatabase;

@interface TSUserTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UIPickerView *ageMinPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *ageMaxPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *targetPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *weightPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *growthPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *figurePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *eyesPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *hairPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *relationsPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *childsPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *earningsPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *educationPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *launguagesPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *housingPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *automobilePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *hobbyPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *alcoholePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *smokingPickerView;

@property (weak, nonatomic) IBOutlet UIButton *boyButton;
@property (weak, nonatomic) IBOutlet UIButton *girlButton;

@property (strong, nonatomic) NSMutableArray *dataSourseGrowth;
@property (strong, nonatomic) NSMutableArray *dataSourseWeight;
@property (strong, nonatomic) NSMutableArray *dataSourseAge;
@property (strong, nonatomic) NSArray *dataSourseFigure;
@property (strong, nonatomic) NSArray *dataSourseEyes;
@property (strong, nonatomic) NSArray *dataSourseHair;
@property (strong, nonatomic) NSArray *dataSourseTarget;
@property (strong, nonatomic) NSArray *dataSourseRelations;
@property (strong, nonatomic) NSArray *dataSourseChilds;
@property (strong, nonatomic) NSArray *dataSourseEarnings;
@property (strong, nonatomic) NSArray *dataSourseEducation;
@property (strong, nonatomic) NSArray *dataSourseLaunguages;
@property (strong, nonatomic) NSArray *dataSourseHousing;
@property (strong, nonatomic) NSArray *dataSourseAutomobile;
@property (strong, nonatomic) NSArray *dataSourseHobby;
@property (strong, nonatomic) NSArray *dataSourseAlcohole;
@property (strong, nonatomic) NSArray *dataSourseSmoking;

@property (strong, nonatomic) UIImage *clickImage;
@property (strong, nonatomic) UIImage *noClickImage;
@property (strong, nonatomic) UIImage *pointImage;
@property (strong, nonatomic) UIImage *circleImage;

@property (strong, nonatomic) NSUserDefaults *userDefaults;

@property (assign, nonatomic) BOOL positionButtonBoy;
@property (assign, nonatomic) BOOL positionButtonGirl;

@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;
@property (assign, nonatomic) BOOL positionButtonGender;

@end

@implementation TSUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    self.tableView.backgroundView = imageView;
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    [self configureContrioller];

}


#pragma mark - Configure contrioller


- (void)configureContrioller
{
    
    self.dataSourseGrowth = [NSMutableArray array];
    self.dataSourseWeight = [NSMutableArray array];
    self.dataSourseAge = [NSMutableArray array];
    
    
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
    
    self.dataSourseFigure = @[@"Указать...", @"Спортивная", @"Стройная", @"Пара лишних кило", @"Полная"];
    self.dataSourseEyes = @[@"Указать...", @"Карие", @"Серые", @"Голубые", @"Зеленые"];
    self.dataSourseHair = @[@"Указать...", @"Блонд", @"Руссые", @"Шатен", @"Брюнет", @"Черные", @"Седые", @"Cбриты"];
    self.dataSourseTarget = @[@"Указать...", @"Дружба и переписка", @"Флирт", @"Секс", @"Романтические отношения", @"Создание семьи"];
    self.dataSourseRelations = @[@"Указать...", @"Свободен", @"Занят", @"Ничего серьйозного"];
    self.dataSourseChilds = @[@"Указать...", @"Есть", @"Есть хочу ещё", @"Нет, когда нибудь", @"Нет и не хочу"];
    self.dataSourseEarnings = @[@"Указать...", @"Обеспечен", @"Средний", @"Не большой стабильный"];
    self.dataSourseEducation = @[@"Указать...", @"Несколько высших", @"Высшее",@"Не полное высшеее", @"Среднее - техническое",@"Студент"];
    self.dataSourseLaunguages = @[@"Указать...", @"Русский", @"Английский", @"Украинский", @"Немецкий"];
    self.dataSourseHousing = @[@"Указать...", @"Свой дом", @"Своя квартира", @"Снимаю квартиру", @"Снимаю комнату", @"Живу с родителями"];
    self.dataSourseAutomobile = @[@"Указать...", @"Есть", @"Нет"];
    self.dataSourseHobby = @[@"Указать...", @"Спорт", @"Музыка", @"Кулинария", @"Йога", @"Танцы"];
    self.dataSourseSmoking = @[@"Указать...", @"Курю каждый день", @"Курю редко", @"Не курю", @"Не курю и не терплю курящих"];
    self.dataSourseAlcohole = @[@"Указать...", @"Иногда выпиваю в компании", @"Не употребляю", @"Всегда готов!"];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 46, 0);
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            [self setBackground:self.view.frame.size.width];
            [self setAvatar:CGPointMake(66, 188)];
        } else if (IS_IPHONE_5) {
            [self setBackground:self.view.frame.size.width];
            [self setAvatar:CGPointMake(66, 188)];
        } else if (IS_IPHONE_6) {
            [self setBackground:self.view.frame.size.width];
            [self setAvatar:CGPointMake(77, 220)];
        } else if (IS_IPHONE_6_PLUS) {
//            [self setBackground:self.view.frame.size.width];
            [self setAvatar:CGPointMake(85, 244)];
        }
    }
    
    
    self.clickImage = [UIImage imageNamed:@"gray-checked"];
    self.noClickImage = [UIImage imageNamed:@"check-box"];
    
    
    self.positionButtonBoy = NO;
    self.positionButtonGirl = NO;
    
    self.pointImage = [UIImage imageNamed:@"radio-on-button"];
    self.circleImage = [UIImage imageNamed:@"circle-outline"];
    
}


#pragma mark - set avatar and background


- (void)setAvatar:(CGPoint)coordinates
{
    
    FBSDKProfilePictureView *avatar = [[TSFBManager sharedManager] requestUserImageFromTheServerFacebook:self.avatarImageView ID:@"me"];
    avatar.frame = CGRectMake(coordinates.x, coordinates.x, coordinates.y, coordinates.y);
    
    avatar.layer.cornerRadius = avatar.frame.size.width / 2;
    avatar.layer.masksToBounds = YES;
    [self.view addSubview:avatar];
    
}


- (void)setBackground:(NSInteger)side
{
    
    FBSDKProfilePictureView *background = [[TSFBManager sharedManager] requestUserImageFromTheServerFacebook:self.backgroundImageView ID:@"me"];
    background.frame = CGRectMake(0, 0, side, side);
    [self.view addSubview:background];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *genderUser = nil;
    
    if (self.positionButtonGender == NO) {
        genderUser = @"man";
    } else {
        genderUser = @"woman";
    }
    
    NSDictionary *userData = @{@"genderUser":genderUser};
    
//    [[[self.ref child:@"users"] child:@"dataUsers"] setValue:userData];
}


- (void)viewDidDisappear:(BOOL)animated
{
    
    NSString *valuePickerViewAgeMin = [self pickerView:self.ageMinPickerView
                                             titleForRow:[self.ageMinPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewAgeMax = [self pickerView:self.ageMaxPickerView
                                             titleForRow:[self.ageMaxPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewTarget = [self pickerView:self.targetPickerView
                                             titleForRow:[self.targetPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewWeight = [self pickerView:self.weightPickerView
                                             titleForRow:[self.weightPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewGrowth = [self pickerView:self.growthPickerView
                                             titleForRow:[self.growthPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewFigure = [self pickerView:self.figurePickerView
                                             titleForRow:[self.figurePickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewEyes = [self pickerView:self.eyesPickerView
                                             titleForRow:[self.eyesPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewHair = [self pickerView:self.hairPickerView
                                             titleForRow:[self.hairPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewRelations = [self pickerView:self.relationsPickerView
                                             titleForRow:[self.relationsPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewChilds = [self pickerView:self.childsPickerView
                                             titleForRow:[self.childsPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewEarnings = [self pickerView:self.earningsPickerView
                                             titleForRow:[self.earningsPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewEducation = [self pickerView:self.educationPickerView
                                             titleForRow:[self.educationPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewLaunguage = [self pickerView:self.launguagesPickerView
                                             titleForRow:[self.launguagesPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewHousing = [self pickerView:self.housingPickerView
                                             titleForRow:[self.housingPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewAutomobile = [self pickerView:self.automobilePickerView
                                             titleForRow:[self.automobilePickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewHobby = [self pickerView:self.hobbyPickerView
                                             titleForRow:[self.hobbyPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewSmoking = [self pickerView:self.smokingPickerView
                                            titleForRow:[self.smokingPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewAlcohole = [self pickerView:self.alcoholePickerView
                                             titleForRow:[self.alcoholePickerView selectedRowInComponent:0] forComponent:0];
    
    
    NSLog(@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@", valuePickerViewAgeMin, valuePickerViewAgeMax, valuePickerViewTarget, valuePickerViewWeight, valuePickerViewGrowth, valuePickerViewFigure, valuePickerViewEyes, valuePickerViewHair, valuePickerViewRelations, valuePickerViewChilds, valuePickerViewEarnings, valuePickerViewEducation, valuePickerViewLaunguage, valuePickerViewHousing, valuePickerViewAutomobile, valuePickerViewHobby, valuePickerViewAlcohole, valuePickerViewSmoking);
    
    
    
        
//        NSDictionary *userData = nil;
        NSString *searchMan = nil;
        NSString *searchVoman = nil;
        
        if (self.positionButtonBoy == YES) {
            searchMan = @"Мужчина";
        }
        
        if (self.positionButtonGirl == YES) {
            searchVoman = @"Женщина";
        }

}


#pragma mark - Action


- (IBAction)actionBoyButton:(id)sender
{
    
    if (self.positionButtonBoy == NO) {
        [sender setImage:self.clickImage forState:UIControlStateNormal];
        self.positionButtonBoy = YES;
    } else {
        [sender setImage:self.noClickImage forState:UIControlStateNormal];
        self.positionButtonBoy = NO;
    }
    
}


- (IBAction)actionGirlButton:(id)sender
{
    
    if (self.positionButtonGirl == NO) {
        [sender setImage:self.clickImage forState:UIControlStateNormal];
        self.positionButtonGirl = YES;
    } else {
        [sender setImage:self.noClickImage forState:UIControlStateNormal];
        self.positionButtonGirl = NO;
    }
    
}


- (IBAction)actionUserBoyButton:(UIButton *)sender
{
    
    self.positionButtonGender = YES;
    
    if (self.positionButtonGender == NO) {
        [sender setImage:self.circleImage forState:UIControlStateNormal];
        [self.womanButton setImage:self.pointImage forState:UIControlStateNormal];
        self.positionButtonGender = YES;
    } else {
        [sender setImage:self.pointImage forState:UIControlStateNormal];
        [self.womanButton setImage:self.circleImage forState:UIControlStateNormal];
        self.positionButtonGender = NO;
    }
    
}


- (IBAction)actionUserGirlButton:(UIButton *)sender
{
    
    self.positionButtonGender = NO;
    
    if (self.positionButtonGender == YES) {
        [sender setImage:self.circleImage forState:UIControlStateNormal];
        [self.manButton setImage:self.pointImage forState:UIControlStateNormal];
        self.positionButtonGender = NO;
    } else {
        [sender setImage:self.pointImage forState:UIControlStateNormal];
        [self.manButton setImage:self.circleImage forState:UIControlStateNormal];
        self.positionButtonGender = YES;
    }
    
}


#pragma mark - UIPickerViewDataSource


- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    
    switch (thePickerView.tag) {
        case 1:
            return self.dataSourseAge.count;
            break;
        case 2:
            return self.dataSourseAge.count;
            break;
        case 3:
            return self.dataSourseTarget.count;
            break;
        case 4:
            return self.dataSourseWeight.count;
            break;
        case 5:
            return self.dataSourseGrowth.count;
            break;
        case 6:
            return self.dataSourseFigure.count;
            break;
        case 7:
            return self.dataSourseEyes.count;
            break;
        case 8:
            return self.dataSourseHair.count;
            break;
        case 9:
            return self.dataSourseRelations.count;
            break;
        case 10:
            return self.dataSourseChilds.count;
            break;
        case 11:
            return self.dataSourseEarnings.count;
            break;
        case 12:
            return self.dataSourseEducation.count;
            break;
        case 13:
            return self.dataSourseLaunguages.count;
            break;
        case 14:
            return self.dataSourseHousing.count;
            break;
        case 15:
            return self.dataSourseAutomobile.count;
            break;
        case 16:
            return self.dataSourseHobby.count;
            break;
        case 17:
            return self.dataSourseSmoking.count;
            break;
        case 18:
            return self.dataSourseAlcohole.count;
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
            return [self.dataSourseAge objectAtIndex:row];
            break;
        case 2:
            return [self.dataSourseAge objectAtIndex:row];
            break;
        case 3:
            return [self.dataSourseTarget objectAtIndex:row];
            break;
        case 4:
            return [self.dataSourseWeight objectAtIndex:row];
            break;
        case 5:
            return [self.dataSourseGrowth objectAtIndex:row];
            break;
        case 6:
            return [self.dataSourseFigure objectAtIndex:row];
            break;
        case 7:
            return [self.dataSourseEyes objectAtIndex:row];
            break;
        case 8:
            return [self.dataSourseHair objectAtIndex:row];
            break;
        case 9:
            return [self.dataSourseRelations objectAtIndex:row];
            break;
        case 10:
            return [self.dataSourseChilds objectAtIndex:row];
            break;
        case 11:
            return [self.dataSourseEarnings objectAtIndex:row];
            break;
        case 12:
            return [self.dataSourseEducation objectAtIndex:row];
            break;
        case 13:
            return [self.dataSourseLaunguages objectAtIndex:row];
            break;
        case 14:
            return [self.dataSourseHousing objectAtIndex:row];
            break;
        case 15:
            return [self.dataSourseAutomobile objectAtIndex:row];
            break;
        case 16:
            return [self.dataSourseHobby objectAtIndex:row];
            break;
        case 17:
            return [self.dataSourseSmoking objectAtIndex:row];
            break;
        case 18:
            return [self.dataSourseAlcohole objectAtIndex:row];
            break;
        default:
            return 0;
            break;
    }
    
}


#pragma mark - UIPickerViewDelegate


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 34;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    [[pickerView.subviews objectAtIndex:1] setHidden:TRUE];
    [[pickerView.subviews objectAtIndex:2] setHidden:TRUE]; // убрать полосы pickerView
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, pickerView.frame.size.width, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = TEXT_COLOR;
    label.font = [UIFont fontWithName:@"System Light" size:16];
    label.textAlignment = NSTextAlignmentRight;
    
    
    switch (pickerView.tag) {
        case 1:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseAge objectAtIndex:row]];
            break;
        case 2:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseAge objectAtIndex:row]];
            break;
        case 3:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseTarget objectAtIndex:row]];
            break;
        case 4:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseWeight objectAtIndex:row]];
            break;
        case 5:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseGrowth objectAtIndex:row]];
            break;
        case 6:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseFigure objectAtIndex:row]];
            break;
        case 7:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseEyes objectAtIndex:row]];
            break;
        case 8:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseHair objectAtIndex:row]];
            break;
        case 9:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseRelations objectAtIndex:row]];
            break;
        case 10:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseChilds objectAtIndex:row]];
            break;
        case 11:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseEarnings objectAtIndex:row]];
            break;
        case 12:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseEducation objectAtIndex:row]];
            break;
        case 13:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseLaunguages objectAtIndex:row]];
            break;
        case 14:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseHousing objectAtIndex:row]];
            break;
        case 15:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseAutomobile objectAtIndex:row]];
            break;
        case 16:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseHobby objectAtIndex:row]];
            break;
        case 17:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseSmoking objectAtIndex:row]];
            break;
        case 18:
            label.text = [NSString stringWithFormat:@"%@", [self.dataSourseAlcohole objectAtIndex:row]];
            break;
        default:
            return 0;
            break;
    }
    
    return label;
}



@end
