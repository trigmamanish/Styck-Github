//
//  NotificationViewController.m
//  Styck
//
//  Created by Ravinderjeet Singh on 7/2/14.
//  Copyright (c) 2014 trigma. All rights reserved.
//

#import "FRDStravaClientImports.h"
#import "NotificationViewController.h"
#import "ProgressScreenViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController
@synthesize athleteId,token;

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

    
    
    
    NSLog(@"%@", athleteId);
    NSLog(@"%@", token);
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    
[self performSelector:@selector(loadingNextView) withObject:nil afterDelay:5.0f];

}

-(void)loadingNextView
{
    [self performSegueWithIdentifier:@"optionscreen" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([[segue identifier] isEqualToString:@"optionscreen"])
//    {
//        //StravaAthlete *athlete = sender;
//        UINavigationController *navVC = segue.destinationViewController;
//        ProgressScreenViewController *destinationVC2 = [segue destinationViewController];
//        
//        NSLog(@"from notification[ %@ ]",athleteId);
//        NSLog(@"from notification[  %@  ]",token);
//        NSString *tokenNotfication=token;
//        
//      //  destinationVC2.athleteId2 = athleteId;
//       // destinationVC2.token2 = token;
//    }
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

@end
