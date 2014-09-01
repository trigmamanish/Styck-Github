//
//  KmranViewController.m
//  Styck
//
//  Created by Ravinderjeet Singh on 8/11/14.
//  Copyright (c) 2014 trigma. All rights reserved.
//

#import "KmranViewController.h"

#import "FRDStravaClientImports.h"
#import <Parse/Parse.h>
#import "ActivityHelper.h"
#import "IconHelper.h"
#import "UIImageView+WebCache.h"

@interface KmranViewController ()
@property (nonatomic, strong) NSMutableArray *activitie;

@end

@implementation KmranViewController
{
    NSString *fbname;
    NSString *fbemail;
    int sum;
    NSMutableArray *smarray;

}
@synthesize kmranLbl;
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
    //Facebook updation
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            NSLog(@"user info: %@", result);
            
            fbname = [result valueForKey:@"first_name"];
            fbemail=[result valueForKeyPath:@"email"];
            
            NSLog(@"%@",fbname);
            NSLog(@"%@",fbemail);
            [[PFUser currentUser]setEmail:fbemail];
            [[PFUser currentUser]setValue:fbname forKey:@"name"];
            [[PFUser currentUser]saveInBackground];

                      NSLog(@"fbemail updated");
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
    
    
    [self fetchdata];
    
    
    [self performSelector:@selector(getDataFromParse) withObject:nil afterDelay:10.0];
    
    
    
    
 
    
    
    
    

  //  [self getDataFromParse];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) fetchdata
{
    
    void(^successBlock)(NSArray *activities) = ^(NSArray *activities) {
        NSLog(@"%@",activities);
        
        if (activities == nil || [activities count] == 0)
        {
            
        kmranLbl.text=@"No data";
        
        }
        else
        {
            
        
        
        self.activitie = [[NSMutableArray alloc] init];
//        self.pageIndex++;
        for(int i = 0 ; i < activities.count ; i ++){
            StravaActivity * ac = [activities objectAtIndex:i];
            if(ac.type == kActivityTypeRun){
                [self.activitie addObject:[activities objectAtIndex:i]];
                
                NSLog(@"activity id- %ld", (long)ac.id);
                NSLog(@"start date- %@", ac.startDate);
                NSLog(@"activity distance- %f", ac.distance);
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                dateFormatter.dateFormat = @"MM yyyy";
                NSDate *date = ac.startDate;
                NSString *activityMonthString = [dateFormatter stringFromDate:date];
                NSLog(@"dateString: %@",activityMonthString);
                [self checkparse:[NSNumber numberWithLong:ac.id] :[NSNumber numberWithFloat:ac.distance] :[NSString stringWithFormat:@"%@", ac.startDate] :activityMonthString];
            }
        }
        
        // self.activities = [self.activities arrayByAddingObjectsFromArray:activities];
       // [self.tableView reloadData];
        
        //  [self getDataFromParse];
        
//        NSInteger lastRow = self.activities.count-1;
//        if (lastRow > 0) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
//            [self.tableView scrollToRowAtIndexPath:indexPath
//                                  atScrollPosition:UITableViewScrollPositionMiddle
//                                          animated:YES];
//        for (int i=0; i< self.activitie.count; i++)
//        {
//            NSLog(@"%ld",(long)self.activitie.id);
//            
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//            dateFormatter.dateFormat = @"MM yyyy";
//            
//            NSDate *date = activity.startDate;
//            NSString *activityMonthString = [dateFormatter stringFromDate:date];
//            
//            NSLog(@"dateString: %@",activityMonthString);
//            
//            
//            
//            [self checkparse : [NSNumber numberWithLong:activity.id] : [NSNumber numberWithFloat:activity.distance] : [NSString stringWithFormat:@"%@",activity.startDate] : activityMonthString];
//        }
        NSLog(@"activities array %@",self.activitie);
        NSLog(@"%lu",(unsigned long)[self.activitie count]);
        }
        };


    void(^failureBlock)(NSError *error) = ^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Miserable failure (not you, the call)"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"Close"
                                                  otherButtonTitles:nil];
        [alertView show];
    
    };

    
[[FRDStravaClient sharedInstance]fetchActivitiesForCurrentAthleteWithSuccess:successBlock failure:failureBlock ];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)checkparse : (NSNumber *) acti : (NSNumber *) dis : (NSString *) strtDate : (NSString *) actmnth
{
//    NSLog(@"yoyo   %@   %@",act,kmran);
    
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
            Strava_Activities[@"fbname"]=fbname;
            Strava_Activities[@"fbemail"]=fbemail;
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
    [fetchQuery whereKey:@"fbemail" equalTo:fbemail];
    
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
            NSLog(@"%lu",(unsigned long)arraycount);
            
            
            float sumi=0.0;
            for (i=0; i<arraycount; i++) {
                sumi=sumi+[[[objects objectAtIndex:i] objectForKey:@"meters_ran"] floatValue] ;
            }
            float sm=sumi/1000;
            
            NSLog(@"sum i is== %f",sumi);
            kmranLbl.text=[NSString stringWithFormat:@"Total km's ran - %.2f KM", sm];
            
//            for (i=0; i<arraycount; i++)
//            {
//                
//                NSString *value;
//                value =[[objects objectAtIndex:i] objectForKey:@"meters_ran"];
//                NSLog(@"%@",value);
//                [smarray addObject:value];
//                //                NSLog(@"%d",sum);
//                //                NSLog(@"%@", [[objects objectAtIndex:i] objectForKey:@"meters_ran"]);
//                //                x=[[objects objectAtIndex:i] objectForKey:@"meters_ran"];
//                //                sum=sum+x;
//                //                NSLog(@"%d",sum);
//            }
//            NSLog(@"%@",smarray);
//            for (int u = 0; u < [smarray count]; u++)
//            {
//                x = [[smarray objectAtIndex:u] integerValue];
//                
//                summ =[smarray objectAtIndex:u] ;
//                sum = sum + [summ integerValue];
//            }
//            NSLog(@"%d",sum);
//            
//            float sm = sum/1000;
//            //  UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"Total KM ran this month" message:[NSString stringWithFormat:@"%.1f KM",sm] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            // [al show];
//            NSLog(@"sumofkm- %f",sm);
//          //  totalKmLbl.text=[NSString stringWithFormat:@"Total KM ran this month- %.1f KM",sm];
////            [viewRefer addSubview:totalKmLbl];
        }
        else
        {
            
            NSLog(@"Error: %@", error);
        }
    }];
    
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
