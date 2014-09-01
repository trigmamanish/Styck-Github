//
//  AppDelegate.m
//  Styck
//
//  Created by Ravinderjeet Singh on 7/1/14.
//  Copyright (c) 2014 trigma. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FRDStravaClient+Access.h"
#import "ConnectStravaViewController.h"
#import "ViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
   // _navCtr = _window.rootViewController;
    
   
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"handleUrlTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
  //parse and facebook
     [Parse setApplicationId:@"osJ1N1JzleZTYkszcEdpyWRhtD35jMsLtv5r15l2"
                  clientKey:@"xRYsSBDBTRquuUcXccPUM7flGz9NWcbHun5hfOYY"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFFacebookUtils initializeFacebook];
    
    
    
    
    
    return YES;
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    int x = [[NSUserDefaults standardUserDefaults] integerForKey:@"handleUrlTime"];
    x++;
    [[NSUserDefaults standardUserDefaults] setInteger:x forKey:@"handleUrlTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(x == 1){
        return [FBAppCall handleOpenURL:url
                      sourceApplication:sourceApplication
                            withSession:[PFFacebookUtils session]];
    }
    
    else{
        //ConnectStravaViewController* testVC = [[ConnectStravaViewController alloc] init];
        
        ViewController *testVC = (ViewController *) [[[UIApplication sharedApplication] keyWindow] rootViewController];
        
        [[FRDStravaClient sharedInstance] parseStravaAuthCallback:url
                                                      withSuccess:^(NSString *stateInfo, NSString *code) {
                                                          // load appropriate view controller/view and
                                                          // make it initiate the token exchange using "code"
                                                          NSLog(@"here {  %@  }",code);
                                                          [[NSUserDefaults standardUserDefaults] setObject:code forKey:@"code"];
                                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                                          
                                                          [testVC gotoNavigation];
                                                          
                                                          //[testVC exchangeToken:code];
                                                          NSLog(@"here");
                                                          
                                                          
                                                          
                                                          
                                                      }
                                                          failure:^(NSString *stateInfo, NSString *error) {
                                                              NSLog(@"failure");
                                                              // show error
                                                              //[testVC showAuthFailedWithError:error];
                                                          }];
        
        return YES;
    
    }
    
    
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    
}



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    ConnectStravaViewController *testVC;
    for (UIViewController *vwController in self.navCtr.viewControllers) {
        if ([vwController isKindOfClass:[ConnectStravaViewController class]]) {
            testVC = (ConnectStravaViewController *) [[[UIApplication sharedApplication] keyWindow] rootViewController];
            break;
        }
    }
    
    
    [[FRDStravaClient sharedInstance] parseStravaAuthCallback:url
                                                  withSuccess:^(NSString *stateInfo, NSString *code) {
                                                      // load appropriate view controller/view and
                                                      // make it initiate the token exchange using "code"
                                                      NSLog(@"success");
                                                                     [testVC exchangeToken:code];
                                                      NSLog(@"here");
                                              
                                                      
                                                      
                                                  }
                                                      failure:^(NSString *stateInfo, NSString *error) {
                                                          NSLog(@"failure");
                                                          // show error
                                                          [testVC showAuthFailedWithError:error];
                                                      }];
    
    return NO;
}





							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
