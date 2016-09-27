//
//  TSRegistrationViewController.m
//  Linker
//
//  Created by Mac on 21.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSRegistrationViewController.h"
#import "TSFireUser.h"
#import "TSTabBarController.h"

@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;

@interface TSRegistrationViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) FIRDatabaseReference *ref;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *displayTextField;
@property (weak, nonatomic) IBOutlet UIButton *avatarPlacehold;

@property (strong, nonatomic) IBOutlet UIImagePickerController *picker;
@property (strong, nonatomic) IBOutlet UIImage *image;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation TSRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loa
    
    self.ref = [[FIRDatabase database] reference];
    
    self.avatarPlacehold.layer.cornerRadius = self.avatarPlacehold.bounds.size.width / 2;
    self.avatarPlacehold.layer.masksToBounds = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)tapSelectImgButton:(id)sender
{
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    self.picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.picker.sourceType];
    self.picker.allowsEditing = NO;
    self.picker.edgesForExtendedLayout = YES;
    
    [self presentViewController:self.picker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.avatarPlacehold setImage:self.image forState:UIControlStateNormal];
    
}


- (IBAction)registerButt:(id)sender
{
    
    if (![self.emailTextField.text isEqualToString:@""] && ![self.passwordTextField.text isEqualToString:@""] && ![self.displayTextField.text isEqualToString:@""]) {
        
        CGSize newSize = CGSizeMake(300, 300);
        
        UIGraphicsBeginImageContext(newSize);
        [self.image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        NSData *dataImage = UIImagePNGRepresentation(newImage);
        NSString *stringImage = [dataImage base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
        
        NSString *email = self.emailTextField.text;
        NSString *password = self.passwordTextField.text;
        NSString *displayName = self.displayTextField.text;
        
        [[FIRAuth auth] createUserWithEmail:email
                                   password:password
                                 completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                     if (!error) {
                                         
                                         if (user.uid) {
                                             
                                             NSString *profession = @"";
                                             NSString *commingFrom = @"";
                                             NSString *coingTo = @"";
                                             NSString *city = @"";
                                             NSString *launguage = @"";
                                             NSString *age = @"";
                                             NSString *mission = @"";
                                             NSString *about = @"";
                                             NSString *background = @"";
                                             NSString *interest = @"";
                                             
                                             NSDictionary *userData = @{@"userID":user.uid,
                                                                        @"displayName":displayName,
                                                                        @"email":email,
                                                                        @"photoURL":stringImage,
                                                                        @"profession":profession,
                                                                        @"commingFrom":commingFrom,
                                                                        @"coingTo":coingTo,
                                                                        @"city":city,
                                                                        @"launguage":launguage,
                                                                        @"age":age,
                                                                        @"mission":mission,
                                                                        @"about":about,
                                                                        @"background":background,
                                                                        @"interest":interest};
                                             
                                             NSString *token = user.uid;
                                             
                                             [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                                             [[NSUserDefaults standardUserDefaults] synchronize];
                                             
                                             [[[[self.ref child:@"users"] child:user.uid] child:@"username"] setValue:userData];
                                             
                                         }
                                         
                                         TSTabBarController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSTabBarController"];
                                         [self presentViewController:controller animated:YES completion:nil];
                                         
                                     } else {
                                         NSLog(@"Error - %@", error.localizedDescription);
                                         
                                         [self alertControllerEmail];
                                     }
                                 }];
        
    } else {
        
        [self alertControllerTextFieldNil];
    }
    
}


- (IBAction)actionBackPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}


- (void)alertControllerEmail
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"This e-mail address has already been registered in the database, or it does not exist..."
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                   }];
    
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)alertControllerTextFieldNil
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please fill in all text fields..."
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                   }];
    
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Keyboard notification


- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.view.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.view.frame.origin.y - kbSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
    
}


- (void)keyboardDidHide:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
