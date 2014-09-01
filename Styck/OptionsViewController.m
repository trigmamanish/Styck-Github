//
//  OptionsViewController.m
//  Styck
//
//  Created by Ravinderjeet Singh on 7/2/14.
//  Copyright (c) 2014 trigma. All rights reserved.
//

#import "OptionsViewController.h"
#import <Parse/Parse.h>
#import "FRDStravaClientImports.h"
#define ACCESS_TOKEN_KEY @"0f39111fc0eca719e8e0091544b345805c84797b"



@interface OptionsViewController ()

@end

@implementation OptionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationItem setHidesBackButton:YES animated:NO];

    
    
    [super viewDidLoad];
    
  

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logoutBtn:(id)sender
{
        [PFUser logOut]; // Log out
    [FRDStravaClient sharedInstance].accessToken = nil;
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:ACCESS_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //
           // Return to login page
        [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES
                             completion:nil];

    
    
//    
   

    
}

- (IBAction)inviteBtn:(id)sender
{
    [self shareText:@"test" andImage:[UIImage imageNamed:@""] andUrl:[NSURL URLWithString:@""]];
}

- (IBAction)styckBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if (text) {
        [sharingItems addObject:text];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    if (url) {
        [sharingItems addObject:url];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}


@end
