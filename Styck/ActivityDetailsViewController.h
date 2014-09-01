//
//  ActivityDetailsViewController.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/5/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailsViewController : UITableViewController
{

}
@property  NSInteger activityId;
- (IBAction)postBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *postDataBtn;
@property (strong, nonatomic) IBOutlet UILabel *parseLabel;

@end
