//
//  AppDelegate.m
//  Linker
//
//  Created by Mac on 14.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "TSLoginViewController.h"
#import "TSTabBarController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <GGLCore/GGLCore.h>
#import <linkedin-sdk/LISDK.h>

@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;

@interface AppDelegate () <GIDSignInDelegate>

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) UIStoryboard *storyBoard;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"token %@", [[FBSDKAccessToken currentAccessToken] tokenString]);
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    self.storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    if (token) {
        
        TSTabBarController *tabBarController = [self.storyBoard instantiateViewControllerWithIdentifier:@"TSTabBarController"];
        self.window.rootViewController = tabBarController;
        
    } else {
        
        TSLoginViewController *loginController = [self.storyBoard instantiateViewControllerWithIdentifier:@"TSLoginViewController"];
        self.window.rootViewController = loginController;
        
    }
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [FIRApp configure];
    
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
    [GIDSignIn sharedInstance].delegate = self;
    
    self.ref = [[FIRDatabase database] reference];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    if ([LISDKCallbackHandler shouldHandleUrl:url]) {
        return [LISDKCallbackHandler application:application
                                         openURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
    } else if ([[url scheme] isEqualToString:@"com.googleusercontent.apps.214635336992-u4bm6jf4u6q72r6vnjev08iurqebvl58"]) {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation];
    } else {
        
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return YES;
}


- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    if (error == nil) {
        
        GIDAuthentication *authentication = user.authentication;
        FIRAuthCredential *credential = [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
                                                                         accessToken:authentication.accessToken];
        [[FIRAuth auth] signInWithCredential:credential
                                  completion:^(FIRUser *user, NSError *error) {
                                      
                                      if (!error) {
                                          
                                          NSString *accessToken = authentication.accessToken;
                                          
                                          
                                          if (accessToken) {
                                              
                                              NSString *token = user.uid;
                                              NSString *name = user.displayName;
                                              NSString *email = user.email;
                                              NSString *imageURL = user.photoURL.absoluteString;
                                              
                                              NSDictionary *userData = @{@"userID":token,
                                                                         @"displayName":name,
                                                                         @"email":email,
                                                                         @"photoURL":imageURL};
                                              
                                              [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                                              [[NSUserDefaults standardUserDefaults] synchronize];
                                              
                                              [[[[self.ref child:@"users"] child:token] child:@"username"] setValue:userData];
                                              
                                              TSTabBarController *tabBarViewController = [self.storyBoard instantiateViewControllerWithIdentifier:@"TSTabBarController"];
                                              self.window.rootViewController = tabBarViewController;
                                          }
                                          
                                      } else {
                                          
                                          NSLog(@"Error %@", error.localizedDescription);
                                      }
                                      
                                      
                                  }];
        
    } else {
        
        NSLog(@"%@", error.localizedDescription);
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
