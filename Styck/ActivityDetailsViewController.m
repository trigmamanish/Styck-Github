//
//  ActivityDetailsViewController.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/5/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "ActivityDetailsViewController.h"
#import "FRDStravaClientImports.h"
#import "GearViewController.h"
#import "JBLineChartView.h"
#import "JBBarChartView.h"
#import "ActivityHelper.h"
#import "AthleteHeadShotsCollectionViewController.h"
#import <Parse/Parse.h>



@interface ActivityDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *rawTextView;

@property (nonatomic, strong) StravaActivity *activity;

@end

@implementation ActivityDetailsViewController
{
    NSString *FBname;
    NSString *FBemail;
    NSNumber *kmran;
    NSNumber *act;
}
@synthesize activityId,postDataBtn,parseLabel;

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
    postDataBtn.hidden=YES;

    parseLabel.hidden=YES;
    //Facebook Request
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            NSLog(@"user info: %@", result);
            
            FBname = [result valueForKey:@"first_name"];
            FBemail=[result valueForKeyPath:@"email"];
            
            NSLog(@"%@",FBname);
            NSLog(@"%@",FBemail);
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
    
    
    
   

    [super viewDidLoad];
    
    
    
    
    [self showSpinner];
    [[FRDStravaClient sharedInstance] fetchActivityWithId:self.activityId
                                        includeAllEfforts:NO
                                                  success:^(StravaActivity *activity) {
                                                      [self hideSpinner];
                                                       kmran=[NSNumber numberWithFloat:[activity distance]];
                                                      self.rawTextView.textColor=[UIColor grayColor];
                                                      self.rawTextView.textAlignment=NSTextAlignmentCenter;
                                                      self.rawTextView.text = [NSString stringWithFormat:@"Meters ran = %@",kmran.stringValue];
                                                      self.activity = activity;
                                                      
                                                      NSLog(@"activity id :- %ld", (long)self.activityId);
                                                      kmran=[NSNumber numberWithFloat:[activity distance]];
                                                      act=[NSNumber numberWithLong:self.activityId];
                                                      
                                                      [self checkparse];

                                                  }
                                                  failure:^(NSError *error) {
                                                      [self hideSpinner];
                                                      UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"FAILED"
                                                  message:error.localizedDescription
                                                  delegate:nil
                                                  cancelButtonTitle:@"Close"
                                                                                         otherButtonTitles: nil];
                                                      [av show];
                                                  }];
    

    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setActivityId:)]) {
        [segue.destinationViewController setActivityId:self.activityId];
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setGearId:)]) {
        [segue.destinationViewController setGearId:self.activity.gearId];
    }
    if ([segue.identifier isEqualToString:@"ActivityToKudoers"]) {
        UINavigationController *navVC = segue.destinationViewController;
        AthleteHeadShotsCollectionViewController *vc = navVC.childViewControllers.firstObject;
        vc.activityId = self.activityId;
        vc.headShotListType = HeadShotListTypeKudoers;
    }
}

-(void) showSpinner
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
}

-(void) hideSpinner
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (IBAction)postBtn:(id)sender
{

    NSLog(@"fbname- %@  fbemail- %@ activity id- %@ meters ran- %@",FBname,FBemail,act,kmran);
    
    PFObject *Strava_Activities= [PFObject objectWithClassName:@"Strava_Activities"];
    // testObject[@"foo"] = @"bar";
    Strava_Activities[@"fbname"]=FBname;
    Strava_Activities[@"fbemail"]=FBemail;
    Strava_Activities[@"Activity_Id"]=act;
    Strava_Activities[@"meters_ran"]=kmran;
//    StravaData[@"activityID"]=;
    [Strava_Activities saveInBackground];
    NSLog(@"data sent");
    
    postDataBtn.hidden=YES;
    parseLabel.hidden=NO;
    
    
    [[PFUser currentUser]setEmail:FBemail];
    [[PFUser currentUser]saveInBackground];
    
    
    
//    //Testing object creation
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    // testObject[@"foo"] = @"bar";
//    testObject[@"fbname"]=FBname;
//    testObject[@"fbemail"]=FBemail;
//    [testObject saveInBackground];
//    NSLog(@"data sent");


}


-(void)checkparse
{
    //Parse updation
    PFQuery *query = [PFQuery queryWithClassName:@"Strava_Activities"];
    [query whereKey:@"Activity_Id" equalTo:act];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * StravauserStats, NSError *error) {
        if (!error) {
            // Found UserStats
            //            [StravauserStats setObject:kmran2 forKey:@"meters_ran"];
            //            UIAlertView *alert1=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Activity ID exists" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //            [alert1 show];
            //            // Save
            //            [StravauserStats saveInBackground];
            parseLabel.hidden=NO;
        }
        else
        {
            postDataBtn.hidden=NO;
            // Did not find any UserStats for the current user
            NSLog(@"Error: %@", error);
        }
    }];



}
@end
