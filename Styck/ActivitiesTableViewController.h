//
//  ActivitiesTableViewController.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/30/14.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ActivitiesListModes) {
    ActivitiesListModeCurrentAthlete,
    ActivitiesListModeFeed,
    ActivitiesListModeClub
};

@interface ActivitiesTableViewController : UITableViewController
{
    NSMutableArray *array;

}
@property (nonatomic) NSInteger clubId;
@property (nonatomic) ActivitiesListModes mode;
@property (strong, nonatomic) IBOutlet UIView *viewRefer;
@property (strong, nonatomic) IBOutlet UITableView *tableViewRefer;
@property (strong, nonatomic) IBOutlet UILabel *totalKmLbl;



@end
