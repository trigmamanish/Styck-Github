//
//  ActivitiesTableViewController.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/30/14.
//

#import "ActivitiesTableViewController.h"

#import "FRDStravaClientImports.h"
#import <Parse/Parse.h>
#import "ActivityTableViewCell.h"
#import "ActivityHelper.h"
#import "IconHelper.h"
#import "UIImageView+WebCache.h"
#import "ActivityDetailsViewController.h"

@interface ActivitiesTableViewController ()

@property (nonatomic, strong) NSMutableArray *activities;
@property (nonatomic) int pageIndex;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation ActivitiesTableViewController
{
    NSString *FBname;
    NSString *FBemail;
    NSNumber *act;
    NSNumber *kmran;
    int sum;
}
@synthesize tableViewRefer,viewRefer,totalKmLbl;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UITableView*)tableView { return tableViewRefer; }
- (UIView*)view { return viewRefer; }

- (void)viewDidLoad
{
    
    
    array = [[NSMutableArray alloc]init];
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            NSLog(@"user info: %@", result);
            
            FBname = [result valueForKey:@"first_name"];
            FBemail=[result valueForKeyPath:@"email"];
            
            NSLog(@"%@",FBname);
            NSLog(@"%@",FBemail);
            
            [[PFUser currentUser]setEmail:FBemail];
            [[PFUser currentUser]saveInBackground];
            NSLog(@"fbemail updated");
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
    

    
    
    [super viewDidLoad];
    
    //self.activities = [];
  //  NSLog(@"%@",self.activities);
    self.pageIndex = 1;
    [self fetchNextPage];
    
//    
//    viewRefer = [[UIView alloc] initWithFrame:tableViewRefer.frame];
//    [viewRefer setBackgroundColor:[UIColor colorWithRed:72.0/255 green:192.0/255 blue:223.0/255 alpha:1]];
//    viewRefer.autoresizingMask = tableViewRefer.autoresizingMask;
//    // add it as a subview
//    [tableViewRefer addSubview:viewRefer];
//    
//    totalKmLbl.text=[NSString stringWithFormat:@"Loading..."];
//    [viewRefer addSubview:totalKmLbl];
//
    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSDateFormatter *) dateFormatter
{
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    return _dateFormatter;
}

-(void) showMoreButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"more"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(moreAction:)];
}

-(void) showSpinner
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
}


-(void) fetchNextPage
{
    [self showSpinner];
    
    void(^successBlock)(NSArray *activities) = ^(NSArray *activities) {
        NSLog(@"%@",activities);
        
        self.activities = [[NSMutableArray alloc] init];
        self.pageIndex++;
        for(int i = 0 ; i < activities.count ; i ++){
            StravaActivity * ac = [activities objectAtIndex:i];
            if(ac.type == 2){
                [self.activities addObject:[activities objectAtIndex:i]];
            }
        }
        
       // self.activities = [self.activities arrayByAddingObjectsFromArray:activities];
        [self.tableView reloadData];
        
      //  [self getDataFromParse];

        NSInteger lastRow = self.activities.count-1;
        if (lastRow > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionMiddle
                                          animated:YES];
        }
        [self showMoreButton];
    };
    
    void(^failureBlock)(NSError *error) = ^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Miserable failure (not you, the call)"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"Close"
                                                  otherButtonTitles:nil];
        [alertView show];
        [self showMoreButton];
    };
    
    if (self.mode == ActivitiesListModeCurrentAthlete) {
        [[FRDStravaClient sharedInstance] fetchActivitiesForCurrentAthleteWithPageSize:5
                                                              pageIndex:self.pageIndex
                                                                success:successBlock
                                                                failure:failureBlock];
    } else if (self.mode == ActivitiesListModeFeed) {
        [[FRDStravaClient sharedInstance] fetchFriendActivitiesWithPageSize:5
                                                      pageIndex:self.pageIndex
                                                        success:successBlock
                                                        failure:failureBlock];
    } else if (self.mode == ActivitiesListModeClub) {
        [[FRDStravaClient sharedInstance] fetchActivitiesOfClub:self.clubId
                                                       pageSize:5
                                                      pageIndex:self.pageIndex
                                                        success:successBlock
                                                        failure:failureBlock];
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.activities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"
                                                                  forIndexPath:indexPath];
    
    StravaActivity *activity = self.activities[indexPath.row];
    
//    if (activity.type ==2)
//    {
    
    
    
    cell.nameLabel.text = activity.name;
    cell.locationLabel.text = activity.locationCity;
    cell.dateLabel.text = [self.dateFormatter stringFromDate:activity.startDate];

    
    NSMutableString *durationStr= [NSMutableString new];
    int hours = (int)floorf(activity.movingTime / 3600);
    int minutes = (activity.movingTime - hours * 3600)/60.0f;
    
    [durationStr appendFormat:@"%dh%02d", hours, minutes];
    cell.typeColorView.backgroundColor = [ActivityHelper colorForActivityType:activity.type];
    cell.typeColorView.layer.cornerRadius = CGRectGetWidth(cell.typeColorView.frame) / 2.0f;
   // cell.durationLabel.text = durationStr;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.1fKM", activity.distance / 1000];
    [ActivityHelper makeLabel:cell.activityIconLabel activityTypeIconForActivity:activity];
    
    [IconHelper makeThisLabel:cell.chevronIconLabel anIcon:ICON_CHEVRON_RIGHT ofSize:24.0f];
    
    cell.usernameLabel.text = [NSString stringWithFormat:@"%@ %@      ", activity.athlete.firstName, activity.athlete.lastName];
    cell.usernameLabel.hidden = self.mode == ActivitiesListModeCurrentAthlete;
    [cell.detailViewHeightConstraint setConstant:(self.mode == ActivitiesListModeCurrentAthlete) ? 75 : 100];
    
    [cell.userImageView setImageWithURL:[NSURL URLWithString:activity.athlete.profileMediumURL]];
    cell.userImageView.layer.cornerRadius = CGRectGetWidth(cell.userImageView.frame)/2.0f;
    cell.userImageView.clipsToBounds = YES;
    cell.userImageView.hidden = self.mode == ActivitiesListModeCurrentAthlete;
    cell.userWidthConstraint.constant = (self.mode == ActivitiesListModeCurrentAthlete) ? 0.0f : 42.0f;
    
//NSLog(@"activity id= %ld",(long)activity.externalId);
   
    
    NSLog(@"%ld",(long)activity.id);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM yyyy";
    
    NSDate *date = activity.startDate;
    NSString *activityMonthString = [dateFormatter stringFromDate:date];
    
    NSLog(@"dateString: %@",activityMonthString);
    
    
    
    [self checkparse : [NSNumber numberWithLong:activity.id] : [NSNumber numberWithFloat:activity.distance] : [NSString stringWithFormat:@"%@",activity.startDate] : activityMonthString];
    
    return cell;
}

-(void)checkparse : (NSNumber *) acti : (NSNumber *) dis : (NSString *) strtDate : (NSString *) actmnth
{
    NSLog(@"yoyo   %@   %@",act,kmran);

    //Parse updation
    PFQuery *query = [PFQuery queryWithClassName:@"Strava_Activities"];
    [query whereKey:@"Activity_Id" equalTo:acti];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * StravauserStats, NSError *error) {
        if (!error) {
            // Found UserStats
            //            [StravauserStats setObject:kmran2 forKey:@"meters_ran"];
            //            UIAlertView *alert1=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Activity ID exists" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //            [alert1 show];
            //            // Save
            //            [StravauserStats saveInBackground];
           // parseLabel.hidden=NO;
        }
        else
        {
          //  postDataBtn.hidden=NO;
            // Did not find any UserStats for the current user
            PFObject *Strava_Activities= [PFObject objectWithClassName:@"Strava_Activities"];
            // testObject[@"foo"] = @"bar";
            Strava_Activities[@"fbname"]=FBname;
            Strava_Activities[@"fbemail"]=FBemail;
            Strava_Activities[@"Activity_Id"]=acti;
            Strava_Activities[@"meters_ran"]=dis;
            Strava_Activities[@"Start_Date"]=strtDate;
            Strava_Activities[@"Activity_Month"]=actmnth;

            //    StravaData[@"activityID"]=;
            [Strava_Activities saveInBackground];
            NSLog(@"data sent");
            
            
            NSLog(@"Error: %@", error);
        }
    }];
}

-(void)getDataFromParse
{
    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
    dateformat.dateFormat = @"MM yyyy";
    
    NSDate *month=[NSDate date];
    NSString *currentMonth = [dateformat stringFromDate:month];
    
    NSLog(@"%@", currentMonth);
    
    PFQuery *fetchQuery=[PFQuery queryWithClassName:@"Strava_Activities"];
    [fetchQuery whereKey:@"Activity_Month" equalTo:currentMonth];
   // [fetchQuery findObjectsInBackgroundWithBlock:^(NSArray *objects ,NSError *error]
    [fetchQuery findObjectsInBackgroundWithBlock:^(NSArray *objects ,NSError *error) {
        if (!error) {
            // Found UserStats
            //            [StravauserStats setObject:kmran2 forKey:@"meters_ran"];
            //            UIAlertView *alert1=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Activity ID exists" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //            [alert1 show];
            //            // Save
            //            [StravauserStats saveInBackground];
            // parseLabel.hidden=NO;
            NSLog(@"objects array%@",objects);
            NSUInteger arraycount= objects.count;
            int i;
            int x;
            NSString *summ;
            NSLog(@"%@",[[objects objectAtIndex:0] objectForKey:@"meters_ran"]);
             NSLog(@"%@",[[objects objectAtIndex:1] objectForKey:@"meters_ran"]);
            sum=0;
            
            for (i=0; i<arraycount; i++)
            {
                
                NSString *value;
                value =[[objects objectAtIndex:i] objectForKey:@"meters_ran"];
                NSLog(@"%@",value);
                [array addObject:value];
//                NSLog(@"%d",sum);
//                NSLog(@"%@", [[objects objectAtIndex:i] objectForKey:@"meters_ran"]);
//                x=[[objects objectAtIndex:i] objectForKey:@"meters_ran"];
//                sum=sum+x;
//                NSLog(@"%d",sum);
            }
            NSLog(@"%@",array);
            for (int u = 0; u < [array count]; u++)
            {
                x = [[array objectAtIndex:u] integerValue];
                
                summ =[array objectAtIndex:u] ;
                sum = sum + [summ integerValue];
            }
            NSLog(@"%d",sum);
            
            float sm = sum/1000;
          //  UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"Total KM ran this month" message:[NSString stringWithFormat:@"%.1f KM",sm] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
           // [al show];
            totalKmLbl.text=[NSString stringWithFormat:@"Total KM ran this month- %.1f KM",sm];
            [viewRefer addSubview:totalKmLbl];
        }
        else
        {
            
            NSLog(@"Error: %@", error);
        }
    }];
    
}


-(void)postOnParse
{
    
   

}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.mode == ActivitiesListModeCurrentAthlete) ? 90.0f : 110.0f;
}

- (IBAction)moreAction:(id)sender
{
    [self fetchNextPage];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setActivityId:)]) {
        
        // find the indexpath of the cell (sender)
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

        StravaActivity *activity = self.activities[indexPath.row];
        
        [segue.destinationViewController setActivityId:activity.id];
        
    }
}

@end
