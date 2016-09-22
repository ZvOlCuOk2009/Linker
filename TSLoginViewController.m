//
//  TSLoginViewController.m
//  Linker
//
//  Created by Mac on 14.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSLoginViewController.h"
#import "TSTabBarController.h"
#import "TSFireUser.h"
#import "TSFBManager.h"
#import "TSParsingManager.h"
#import "TSSaveFriendsFBDatabase.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <linkedin-sdk/LISDK.h>

@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;

@interface TSLoginViewController () <FBSDKLoginButtonDelegate, GIDSignInUIDelegate>

@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) TSFireUser *fireUser;
@property (strong, nonatomic) NSMutableArray *userFriends;

@end

@implementation TSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    NSError *error;
//    [[FIRAuth auth] signOut:&error];
    
    NSLog(@"token %@", [[FBSDKAccessToken currentAccessToken] tokenString]);
    
    self.loginButton = [[FBSDKLoginButton alloc] init];
    self.loginButton.hidden = YES;
    [self.view addSubview:self.loginButton];

    _loginButton.delegate = self;
    
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signInSilently];
    
    self.ref = [[FIRDatabase database] reference];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIColor *color = [UIColor blackColor];
    self.userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"  Username" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"  Password" attributes:@{NSForegroundColorAttributeName: color}];
}



- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error
{
    
    NSLog(@"token %@", [[FBSDKAccessToken currentAccessToken] tokenString]);

    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        NSDictionary * parameters = @{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio, location, friends, hometown, friendlists"};
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                           parameters:parameters]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"resultis:%@", result);
             } else {
                 NSLog(@"Error %@", error);
             }
         }];
        
        
    } else {
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"public_profile"]
                     fromViewController:self
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                    if (error) {
                                        NSLog(@"Process error");
                                    } else if (result.isCancelled) {
                                        NSLog(@"Cancelled");
                                    } else {
                                        NSLog(@"Logged in");
                                    }
                                }];
        
        
    }
    
    FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                     credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
    
    [[FIRAuth auth] signInWithCredential:credential
                              completion:^(FIRUser *user, NSError *error) {
                                  
                                  [self saveUserToFirebase:user];
                                  [self openTheTabBarController];
                              }];
    
    
    if (![FBSDKAccessToken currentAccessToken])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


- (IBAction)facebookButtonTouchUpInside:(id)sender
{
    [self.loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}


- (void)openTheTabBarController
{
    TSTabBarController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSTabBarController"];
    [self presentViewController:controller animated:YES completion:nil];
}


- (void)saveUserToFirebase:(FIRUser *)user
{
    
    [[TSFBManager sharedManager] requestUserFriendsTheServerFacebook:^(NSArray *friends)
     {
         self.userFriends = [TSParsingManager parsingFriendsFacebook:friends];
     }];
    
    
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.fireUser = [TSFireUser initWithSnapshot:snapshot];
        
        
        NSString *userID = user.uid;
        NSString *displayName = user.displayName;
        NSString *email = user.email;
        NSString *photoURL = user.photoURL.absoluteString;
        
        
        NSString *name = nil;
        NSString *profession = nil;
        NSString *commingFrom = nil;
        NSString *coingTo = nil;
        NSString *city = nil;
        NSString *launguage = nil;
        NSString *age = nil;
        NSString *mission = nil;
        NSString *about = nil;
        NSString *background = nil;
        NSString *interest = nil;
        
        
        if (![self.fireUser.displayName isEqualToString:@""]) {
            
            name = displayName;
            
        } else {
            
            name = self.fireUser.displayName;
        }
        
        
        
        if (![self.fireUser.profession isEqualToString:@""]) {
            
            profession = @"";
            
        } else {
            
            profession = self.fireUser.profession;
        }
        
        
        
        if (![self.fireUser.commingFrom isEqualToString:@""]) {
            
            
            commingFrom = @"";
            
        } else {
            
            commingFrom = self.fireUser.commingFrom;
        }
        
        
        
        if (![self.fireUser.coingTo isEqualToString:@""]) {
            
            coingTo = @"";
            
        } else {
            
            coingTo = self.fireUser.coingTo;
        }
        
        
        
        if (![self.fireUser.currentArrea isEqualToString:@""]) {
            
            city = @"";
            
        } else {
            
            city = self.fireUser.currentArrea;
        }
        
        
        
        if (![self.fireUser.launguage isEqualToString:@""]) {
            
            launguage = @"";
            
        } else {
            
            launguage = self.fireUser.launguage;
        }
        
        
        
        if (![self.fireUser.age isEqualToString:@""]) {
            
            age = @"";
            
        } else {
            
            age = self.fireUser.age;
        }
        
        
        
        if (![self.fireUser.mission isEqualToString:@""]) {
            
            mission = @"";
            
        } else {
            
            mission = self.fireUser.mission;
            
        }
        
        
        
        if (![self.fireUser.about isEqualToString:@""]) {
            
            about = @"";
            
        } else {
            
            about = self.fireUser.about;
        }
        
        
        
        if (![self.fireUser.background isEqualToString:@""]) {
            
            background = @"";
            
        } else {
            
            background = self.fireUser.background;
        }
        
        
        
        if (![self.fireUser.interest isEqualToString:@""]) {
            
            interest = @"";
            
        } else {
            
            interest = self.fireUser.interest;
        }
        
        
        
        if (email == nil) {
            email = @"email";
        }
        
        
        NSDictionary *userData = @{@"userID":userID,
                                   @"displayName":name,
                                   @"email":email,
                                   @"photoURL":photoURL,
                                   @"profession":profession,
                                   @"commingFrom":commingFrom,
                                   @"coingTo":coingTo,
                                   @"city":city,
                                   @"launguage":launguage,
                                   @"age":age,
                                   @"mission":mission,
                                   @"about":about,
                                   @"background":background,
                                   @"interest":interest,};
        
        NSString *token = [userData objectForKey:@"userID"];
        
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[[[self.ref child:@"users"] child:user.uid] child:@"username"] setValue:userData];
        
        [TSSaveFriendsFBDatabase saveFriendsDatabase:user userFriend:self.userFriends];
        
    }];
    
}



- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"User log Out");
}



- (void)alertController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Invalid password or e-mail, try again..."
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                   }];
    
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Autorization Google


- (IBAction)gPlusButtonTouchUpInside:(id)sender
{
    [[GIDSignIn sharedInstance] signIn];
}


- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error
{
    
}


- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}


- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    
}


#pragma mark - Autorization E - mail


- (void)signInWithEmailAndPassword
{
    
    [[FIRAuth auth] signInWithEmail:self.userNameTextField.text
                           password:self.passwordTextField.text
                         completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                             if (!error) {
                                 
                                 NSArray *provider = user.providerData;
                                 NSLog(@"provider = %@", provider.description);
                                 
                                 [self openTheTabBarController];
                                 
                                 NSString *token = user.uid;
                                 
                                 [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                                 [[NSUserDefaults standardUserDefaults] synchronize];
                                 
                             } else {
                                 NSLog(@"Error %@", error.localizedDescription);
                                 [self alertController];
                             }
                         }];
    
}



- (IBAction)signINButtonAction:(UIButton *)sender
{
    if (![self.userNameTextField.text isEqualToString:@""] && ![self.passwordTextField.text isEqualToString:@""]) {
        [self signInWithEmailAndPassword];
    }
}


#pragma mark - Autorization Linkedin


- (IBAction)actButtonLinkedin:(id)sender
{
    [LISDKSessionManager createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION, nil]
                                         state:@"code"
                        showGoToAppStoreDialog:YES
                                  successBlock:^(NSString *returnState) {
                                      
                                      [[LISDKAPIHelper sharedInstance] getRequest:@"https://api.linkedin.com/v1/people/~"
                                                                          success:^(LISDKAPIResponse *response) {
                                                                              
                                                                              NSData* data = [response.data dataUsingEncoding:NSUTF8StringEncoding];
                                                                              NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                                              
                                                                              NSString *authUsername = [NSString stringWithFormat: @"%@ %@", [dictResponse valueForKey: @"firstName"], [dictResponse valueForKey: @"lastName"]];
                                                                              NSLog(@"Authenticated user name  : %@", authUsername);
                                                                              
                                                                          } error:^(LISDKAPIError *error) {
                                                                              
                                                                          }];
                                  } errorBlock:^(NSError *error) {
                                      NSLog(@"%s %@","error called! ", [error description]);
                                  }];
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
