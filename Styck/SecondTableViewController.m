//
//  SecondTableViewController.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/29/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "SecondTableViewController.h"
#import "ActivitiesTableViewController.h"

@interface SecondTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *authTokenLabel;
@property (weak, nonatomic) IBOutlet UILabel *athleteIdLabel;

@end

@implementation SecondTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSLog(@"secondviewdata %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"AthleteDetail"]);
    NSLog(@"secondviewdata token  %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"AccessToken"]);
    
    
    self.athleteId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AthleteDetail"] integerValue];
    self.token=[[NSUserDefaults standardUserDefaults]objectForKey:@"AccessToken" ];
    
    
    self.authTokenLabel.text = self.token;
    self.athleteIdLabel.text = [NSString stringWithFormat:@"%ld", (long)self.athleteId];
    
   // [self performSegueWithIdentifier:@"xyx" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setAthleteId:)]) {
        [segue.destinationViewController setAthleteId:self.athleteId];
    }
    
    if ([segue.identifier isEqualToString:@"AthleteActivitiesSegue"]) {
        [segue.destinationViewController setMode:ActivitiesListModeCurrentAthlete];
    } else if ([segue.identifier isEqualToString:@"FriendActivitiesSegue"]) {
        [segue.destinationViewController setMode:ActivitiesListModeFeed];
        
    }
}



@end
