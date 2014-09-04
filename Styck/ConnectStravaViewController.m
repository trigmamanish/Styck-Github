//
//  ConnectStravaViewController.m
//  Styck
//
//  Created by Ravinderjeet Singh on 7/2/14.
//  Copyright (c) 2014 trigma. All rights reserved.
//

#import "FRDStravaClientImports.h"
#import "ConnectStravaViewController.h"
#import "ProgressScreenViewController.h"
#import <Parse/Parse.h>
#import "NotificationViewController.h"

#define ACCESS_TOKEN_KEY @"0f39111fc0eca719e8e0091544b345805c84797b"

@interface ConnectStravaViewController ()

@end

@implementation ConnectStravaViewController

{
    NSString *name;
    NSString *email;
    int x;
    NSString *tokenfromparse;
}
@synthesize btnnwOtlt,authorizeButton,statusLabel,connectBigLbl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"code"]);
    
}

- (void)viewDidLoad
{
    
    self.authorizeButton.hidden=YES;
    self.connectBigLbl.hidden=YES;
    x=0;
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    self.btnnwOtlt.hidden=YES;
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [super viewDidLoad];
    
    //Facebook Request
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            NSLog(@"user info: %@", result);
        
            name = [result valueForKey:@"first_name"];
            email=[result valueForKeyPath:@"email"];
            
            NSLog(@"%@",name);
            NSLog(@"%@",email);
            [self parseQuery];
            
            
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
    
    //STRAVA API
    
    
    // Get yourself a client secret and client ID from strava http://www.strava.com/developers
    // and configure them here:
    
    //[[NSUserDefaults standardUserDefaults] s :@"ClientSecret"];
    //[[NSUserDefaults standardUserDefaults] objectForKey:@"ClientSecret"];
    //[[NSUserDefaults standardUserDefaults] objectForKey:@"ClientSecret"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"b5b832a141aa86b5a5a754e93e990065452f2b28" forKey:@"ClientSecret"];
    [[NSUserDefaults standardUserDefaults] setObject:@"2087" forKey:@"ClientID"];
    [[NSUserDefaults standardUserDefaults] setObject:@"google.com" forKey:@"CallbackDomain"];
    
    
    
    NSString *clientSecret = [[NSUserDefaults standardUserDefaults] objectForKey:@"ClientSecret"];
    NSInteger clientID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ClientID"] integerValue];
    NSString *domain = [[NSUserDefaults standardUserDefaults] objectForKey:@"CallbackDomain"];
    
    
    NSLog(@"clientSecret:-%@clientID:-%d domain:-%@",clientSecret,clientID,domain);
    // hard-code ID and secret here:
    //clientID = 1234
    //clientSecret = @"ffffffffffffffffffffffffffffffffffffffff";
    //domain = @"www.myregistereddomain.com";
    
    if (clientSecret.length == 0 || clientID == 0 || domain.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"error"
                                                            message:@"Configure the Strava client secret, ID and domain in the Settings or hard-code them in AuthViewController viewDidLoad, and restart the demo app."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    [[FRDStravaClient sharedInstance] initializeWithClientId:clientID
                                                clientSecret:clientSecret];
    
    
    self.statusLabel.text = @"";
    
  //  [self checktoken];
    
    //[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ACCESS_TOKEN_KEY"];
//    
//    NSString *previousToken = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_KEY];
//    NSLog(@"[  %@  ]",previousToken);
//    
//    if ([previousToken length] > 0) {
//        // check the user token is still ok by fetching user data
//        self.authorizeButton.hidden = YES;
//        self.statusLabel.text = @"Checking access token is valid...";
//        
//        [[FRDStravaClient sharedInstance] setAccessToken:previousToken];
//        [[FRDStravaClient sharedInstance] fetchCurrentAthleteWithSuccess:^(StravaAthlete *athlete) {
//            self.statusLabel.text = @"ok.";
//            
//           
//            
//            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", athlete.id] forKey:@"AthleteDetail"];
//            [[NSUserDefaults standardUserDefaults] setObject:previousToken forKey:@"AccessToken"];
//            
//            NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"AthleteDetail"]);
//            NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"]);
//            
//            
//            
//            
//            
//            
//            
//            [self performSegueWithIdentifier:@"authorizeSuccessfulSegue" sender:athlete];
//        }
//                                                                 failure:^(NSError *error) {
//                                                                     self.statusLabel.text = @"Access token invalid, you need to reauthorize.";
//                                                                     self.authorizeButton.hidden = NO;
//                                                                     [[FRDStravaClient sharedInstance] setAccessToken:nil];
//                                                                 }];
//    } else {
//        self.authorizeButton.hidden = NO;
//        
//        // do nothing, this will show the access button.
//    }
//
//    
//    
    
    
   
    
    // Do any additional setup after loading the view.
}
-(void)parseQuery
{
    self.authorizeButton.hidden = YES;
    self.statusLabel.text = @"Connecting to Strava...";
    PFQuery *query= [PFUser query];
    [query whereKey:@"email" equalTo:email];
    [query whereKeyExists:@"strava_token"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if(!error)
        {
            
            NSLog(@"%@",[object valueForKey:@"strava_token"]);
            tokenfromparse=[object valueForKey:@"strava_token"];
            [self checktoken];
        }
        else
        {
            
            self.authorizeButton.hidden = NO;
            self.statusLabel.text=@"";
            self.connectBigLbl.hidden=NO;
            
        }
        
        
    }];

}

-(void)checktoken
{
    
    
    
  //  NSString *previousToken = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_KEY];
    NSString *previousToken = tokenfromparse;

    NSLog(@"[  %@  ]",previousToken);
    
    if ([previousToken length] > 0) {
        // check the user token is still ok by fetching user data
        self.authorizeButton.hidden = YES;
        self.statusLabel.text = @"Connecting to Strava...";
        
        [[FRDStravaClient sharedInstance] setAccessToken:previousToken];
        [[FRDStravaClient sharedInstance] fetchCurrentAthleteWithSuccess:^(StravaAthlete *athlete) {
            self.statusLabel.text = @"ok.";
            
            
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", athlete.id] forKey:@"AthleteDetail"];
            [[NSUserDefaults standardUserDefaults] setObject:previousToken forKey:@"AccessToken"];
            
            NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"AthleteDetail"]);
            NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"]);
            
            
            
            
            
            [self performSegueWithIdentifier:@"authorizeSuccessfulSegue" sender:athlete];
        }
                                                                 failure:^(NSError *error) {
                                                                     self.statusLabel.text = @"Access token invalid, you need to reauthorize.";
                                                                     self.authorizeButton.hidden = NO;
                                                                     [[FRDStravaClient sharedInstance] setAccessToken:nil];
                                                                 }];
    } else {
        self.authorizeButton.hidden = NO;
        
        // do nothing, this will show the access button.
    }
    
    
    
}

- (void)willBecomeActive:(NSNotification *)notification
{
//    if (x==1)
//    {
//        [self performSegueWithIdentifier:@"authorizeSuccessfulSegue" sender:nil];
//
//    }
//    
    
    
//    NotificationViewController *notificationTest=[[NotificationViewController alloc]init];
//    if (self.navigationController.topViewController == self) {
//        [self performSegueWithIdentifier:@"authorizeSuccessfulSegue" sender:nil];
//    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"code"]){
        [self exchangeToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"code"]];
    }
    
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


- (IBAction)StravaConnectBtn:(id)sender
{
    
//    PFQuery *query= [PFUser query];
//    //[query whereKey:@"strava_token" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"]];
//    [query whereKey:@"email" equalTo:email];
//    [query whereKeyExists:@"strava_token"];
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
//        if(!error)
//        {
//            
//            NSLog(@"%@",[object valueForKey:@"strava_token"]);
//            tokenfromparse=[object valueForKey:@"strava_token"];
//            [self checktoken];
//        }
//        else
//        {
    
            
            NSString *strURL = [NSString stringWithFormat:@"Styck://%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"CallbackDomain"]];
            
            [[FRDStravaClient sharedInstance] authorizeWithCallbackURL:[NSURL URLWithString:strURL]
                                                             stateInfo:nil];
            x=1;
            authorizeButton.hidden=YES;
            statusLabel.hidden=NO;
            statusLabel.text=@"Connecting...";
            

            
//        }
//        
//        
//    }];
    
  }

-(void) exchangeToken:(NSString *)code
{
    [[FRDStravaClient sharedInstance] exchangeTokenForCode:code
                                                   success:^(StravaAccessTokenResponse *response) {
                                                       
                                                       
                                                       [[NSUserDefaults standardUserDefaults] setObject:response.accessToken forKey:ACCESS_TOKEN_KEY];
                                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                                       NSLog(@"%@",response);
                                                       NSLog(@"acces token here %@",[[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_KEY]);
                                                       
                                                       
                                                         [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",response.athlete.id] forKey:@"AthleteDetail"];
                                                       
                                                       [[NSUserDefaults standardUserDefaults] setObject:response.accessToken forKey:@"AccessToken"];
                                                       
                                                       NSLog(@"%@", [[NSUserDefaults standardUserDefaults]objectForKey:@"AthleteDetail"]);
                                                       NSLog(@"%@", [[NSUserDefaults standardUserDefaults]objectForKey:@"AccessToken"]);
                                                       
                                                       [[PFUser currentUser]setValue:response.accessToken forKey:@"strava_token"];
                                                       [[PFUser currentUser] saveInBackground];

                                                     //  x=1;
                                                       
                                                       [self performSegueWithIdentifier:@"authorizeSuccessfulSegue"
                                                                                sender:nil];
                                                   
                                                   } failure:^(NSError *error) {
                                                       [self showAuthFailedWithError:error.localizedDescription];
                                                   }];
}

-(void) showAuthFailedWithError:(NSString *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                        message:error
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
    [alertView show];
}


- (void)dosegue 
{

    NotificationViewController *destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    
    [self.navigationController pushViewController:destViewController animated:YES];

}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([[segue identifier] isEqualToString:@"authorizeSuccessfulSegue"])
//    {
//        StravaAthlete *athlete = sender;
//        UINavigationController *navVC = segue.destinationViewController;
//        NotificationViewController *destinationVC = [segue destinationViewController];
//        
//        NSLog(@"%@",athlete);
//        NSLog(@"%ld",(long)athlete.id);
//        
//        destinationVC.athleteId = [NSString stringWithFormat:@"%d",athlete.id];
//        destinationVC.token = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_KEY];
//    }
}



- (IBAction)newObjectBtn:(id)sender
{
    //Testing object creation
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
   // testObject[@"foo"] = @"bar";
    testObject[@"fbname"]=name;
    testObject[@"fbemail"]=email;
    [testObject saveInBackground];
    NSLog(@"data sent");
}


@end
