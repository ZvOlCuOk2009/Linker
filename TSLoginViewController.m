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
#import "TSPrefixHeader.pch"

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

@property (strong, nonatomic) IBOutlet UIView *forgotTopConstraint2;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation TSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    
    NSLog(@"token %@", [[FBSDKAccessToken currentAccessToken] tokenString]);
    
    self.loginButton = [[FBSDKLoginButton alloc] init];
    self.loginButton.hidden = YES;
    [self.view addSubview:self.loginButton];
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.loginButton.delegate = self;
    
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signInSilently];
    
    self.ref = [[FIRDatabase database] reference];
    
    self.signInButton.layer.masksToBounds = YES;
    self.signUpButton.layer.masksToBounds = YES;

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            
        } else if (IS_IPHONE_5) {
            
        } else if (IS_IPHONE_6) {
            
        } else if (IS_IPHONE_6_PLUS) {
            
            
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIColor *color = [UIColor blackColor];
    self.userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"  Username" attributes:@{NSForegroundColorAttributeName:color}];
    
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"  Password" attributes:@{NSForegroundColorAttributeName:color}];
}



- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error
{
    
    NSLog(@"token %@", [[FBSDKAccessToken currentAccessToken] tokenString]);

    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" // all friends "me/taggable_friends"
                                           parameters:nil]
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
    
    
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        
        self.fireUser = [TSFireUser initWithSnapshot:snapshot];
        
        NSString *userID = user.uid;
        NSString *displayName = user.displayName;
        NSString *email = user.email;
        NSString *photoURL = user.photoURL.absoluteString;
        
        
        NSString *name = nil;
        NSString *gender = nil;
        NSString *age = nil;
        NSString *target = nil;
        NSString *growth = nil;
        NSString *weight = nil;
        NSString *figure = nil;
        NSString *eyes = nil;
        NSString *hair = nil;
        NSString *relations = nil;
        NSString *childs = nil;
        NSString *earnings = nil;
        NSString *education = nil;
        NSString *launguages = nil;
        NSString *housing = nil;
        NSString *car = nil;
        NSString *hobby = nil;
        NSString *smoking = nil;
        NSString *alcohole = nil;
        
        
        
        if (![self.fireUser.displayName isEqualToString:@""]) {
            
            name = displayName;
            
        } else {
            
            name = self.fireUser.displayName;
        }
        
        
        
        if (![self.fireUser.gender isEqualToString:@""]) {
            
            gender = @"";
            
        } else {
            
            gender = self.fireUser.gender;
        }
        
        
        
        if (![self.fireUser.age isEqualToString:@""]) {
            
            
            age = @"";
            
        } else {
            
            age = self.fireUser.age;
        }
        
        
        if (![self.fireUser.target isEqualToString:@""]) {
            
            target = @"";
            
        } else {
            
            target = self.fireUser.age;
        }
        
        
        if (![self.fireUser.growth isEqualToString:@""]) {
            
            growth = @"";
            
        } else {
            
            growth = self.fireUser.growth;
            
        }
        
        
        if (![self.fireUser.weight isEqualToString:@""]) {
            
            weight = @"";
            
        } else {
            
            weight = self.fireUser.weight;
        }
        
        
        if (![self.fireUser.figure isEqualToString:@""]) {
            
            figure = @"";
            
        } else {
            
            figure = self.fireUser.figure;
        }
        
        
        
        if (![self.fireUser.eyes isEqualToString:@""]) {
            
            eyes = @"";
            
        } else {
            
            eyes = self.fireUser.eyes;
        }
        
        
        if (![self.fireUser.hair isEqualToString:@""]) {
            
            hair = @"";
            
        } else {
            
            hair = self.fireUser.hair;
        }
    
        
        
        if (![self.fireUser.relations isEqualToString:@""]) {
            
            relations = @"";
            
        } else {
            
            relations = self.fireUser.relations;
        }
        
        
        if (![self.fireUser.childs isEqualToString:@""]) {
            
            childs = @"";
            
        } else {
            
            childs = self.fireUser.childs;
        }
        
        
        
        if (![self.fireUser.earnings isEqualToString:@""]) {
            
            
            earnings = @"";
            
        } else {
            
            earnings = self.fireUser.earnings;
        }
        
        
        if (![self.fireUser.education isEqualToString:@""]) {
            
            education = @"";
            
        } else {
            
            education = self.fireUser.education;
        }
        
        
        if (![self.fireUser.launguages isEqualToString:@""]) {
            
            launguages = @"";
            
        } else {
            
            launguages = self.fireUser.launguages;
        }
        
        
        if (![self.fireUser.housing isEqualToString:@""]) {
            
            housing = @"";
            
        } else {
            
            housing = self.fireUser.housing;
            
        }
        
        
        if (![self.fireUser.car isEqualToString:@""]) {
            
            car = @"";
            
        } else {
            
            car = self.fireUser.car;
        }
        
        
        if (![self.fireUser.hobby isEqualToString:@""]) {
            
            hobby = @"";
            
        } else {
            
            hobby = self.fireUser.hobby;
        }
        
        
        if (![self.fireUser.smoking isEqualToString:@""]) {
            
            smoking = @"";
            
        } else {
            
            smoking = self.fireUser.smoking;
        }
        
        
        if (![self.fireUser.alcohole isEqualToString:@""]) {
            
            alcohole = @"";
            
        } else {
            
            alcohole = self.fireUser.alcohole;
            
        }
        
        
        
        if (email == nil) {
            email = @"email";
        }
        
        
        
        NSDictionary *userData = @{@"userID":userID,
                                   @"displayName":name,
                                   @"email":email,
                                   @"photoURL":photoURL,
                                   @"gender":gender,
                                   @"age":age,
                                   @"target":target,
                                   @"growth":growth,
                                   @"weight":weight,
                                   @"figure":figure,
                                   @"eyes":eyes,
                                   @"hair":hair,
                                   @"relations":relations,
                                   @"childs":childs,
                                   @"earnings":earnings,
                                   @"education":education,
                                   @"launguages":launguages,
                                   @"housing":housing,
                                   @"car":car,
                                   @"hobby":hobby,
                                   @"smoking":smoking,
                                   @"alcohole":alcohole};
        
        
        [[[[self.ref child:@"users"] child:@"userData"] child:user.uid] setValue:userData];
        
        NSString *token = user.uid;
        
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
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



@end
