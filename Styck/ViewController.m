//
//  ViewController.m
//  Styck
//
//  Created by Ravinderjeet Singh on 7/1/14.
//  Copyright (c) 2014 trigma. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface ViewController ()

@end

@implementation ViewController
@synthesize signLbl,fbBtnOutlet;
- (void)viewDidLoad
{
    
    self.navigationController.navigationBarHidden=NO;
   // [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.translucent=NO;
        [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    fbBtnOutlet.hidden=YES;
    signLbl.text=@"Connecting...";
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        // Push the next view controller without animation
        [self performSegueWithIdentifier:@"facebookLoginSegue" sender:nil];
        
        
    }
    else
    {
        fbBtnOutlet.hidden=NO;
        signLbl.text=@"Sign In";
    }
}

-(void) gotoNavigation{
[self performSegueWithIdentifier:@"facebookLoginSegue" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)FacebookLoginBtn:(id)sender
{
    [PFFacebookUtils logInWithPermissions:@[@"public_profile",@"email"] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self performSegueWithIdentifier:@"facebookLoginSegue" sender:nil];
        } else {
            NSLog(@"User logged in through Facebook!");
            [self performSegueWithIdentifier:@"facebookLoginSegue" sender:nil];
        }
    }];
    
}
@end
