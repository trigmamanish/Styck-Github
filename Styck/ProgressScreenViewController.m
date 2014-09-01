//
//  ProgressScreenViewController.m
//  Styck
//
//  Created by Ravinderjeet Singh on 7/7/14.
//  Copyright (c) 2014 trigma. All rights reserved.
//

#import "ProgressScreenViewController.h"
#import "FRDStravaClientImports.h"
#import "EColumnChart.h"


@interface ProgressScreenViewController ()
@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) EColumn *eColumnSelected;
@property (nonatomic, strong) UIColor *tempColor;




@end

@implementation ProgressScreenViewController
@synthesize authTokenLbl,athleteId2,token2;
@synthesize data = _data;
@synthesize tempColor = _tempColor;
@synthesize eColumnChart = _eColumnChart;
@synthesize eColumnSelected = _eColumnSelected;
@synthesize valueLabel = _valueLabel;



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
//    NSMutableArray *temp = [NSMutableArray array];
//    for (int i = 0; i < 50; i++)
//    {
//        int value = 30;
//        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:[NSString stringWithFormat:@"%d", i] value:value index:i unit:@"km"];
//        [temp addObject:eColumnDataModel];
//    }
//    _data = [NSArray arrayWithArray:temp];
//    
//    
//    _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(50, 200, 250, 200)];
//    [_eColumnChart setDelegate:self];
//    [_eColumnChart setDataSource:self];
//    
//    [self.view addSubview:_eColumnChart];
    
    
    [super viewDidLoad];
    
   // self.authTokenLbl.text = self.token2;
    self.authTokenLbl.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"];
   // NSLog(@"%@",athleteId2);
   
  //  self.atheleteIDLbl.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"AthleteDetail"];
    
   // self.atheleIDLbl.text = [NSString stringWithFormat:@"%ld", (long)self.athleteId2];
    
   // NSString *aid=[NSString stringWithFormat:@"%ld", (long)self.athleteId2];
   // NSLog(aid);
    // Do any additional setup after loading the view.
    [self fetchNextPage];
    

    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) fetchNextPage
{
    
    void(^successBlock)(NSArray *activities) = ^(NSArray *activities)
    {
        NSLog(@"%@",activities);
        
        NSLog(@"%@",[activities valueForKey:@"distance"]);
        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"propertyName == %@", @"value"];
//        NSArray *filteredArray = [activities filteredArrayUsingPredicate:predicate];
//        
       
//        self.activities = [self.activities arrayByAddingObjectsFromArray:activities];
//        [self.tableView reloadData];
//        NSInteger lastRow = self.activities.count-1;
//        if (lastRow > 0) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
//            [self.tableView scrollToRowAtIndexPath:indexPath
//                                  atScrollPosition:UITableViewScrollPositionMiddle
//                                          animated:YES];
//        }
//        [self showMoreButton];
    };
    
    void(^failureBlock)(NSError *error) = ^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Miserable failure (not you, the call)"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"Close"
                                                  otherButtonTitles:nil];
        [alertView show];
//        [self showMoreButton];
    };
    
        [[FRDStravaClient sharedInstance] fetchActivitiesForCurrentAthleteWithPageSize:5
                                                                             pageIndex:1
                                                                               success:successBlock
                                                                               failure:failureBlock];
    
       
    //[[FRDStravaClient sharedInstance]fetchActivitiesForCurrentAthleteWithSuccess:successBlock failure:failureBlock];
    
    
    
    
    
    
  
}




#pragma -mark- EColumnChartDataSource

/** How many Columns are there in total.*/
- (NSInteger) numberOfColumnsInEColumnChart:(EColumnChart *) eColumnChart
{
    return 1;
}

/** How many Columns should be presented on the screen each time*/
- (NSInteger) numberOfColumnsPresentedEveryTime:(EColumnChart *) eColumnChart
{
    return 1;
}

/** The highest value among the whole chart*/
- (EColumnDataModel *)     highestValueEColumnChart:(EColumnChart *) eColumnChart
{
    EColumnDataModel *maxDataModel = nil;
    float maxValue = -FLT_MIN;
    for (EColumnDataModel *dataModel in _data)
    {
        if (dataModel.value > maxValue)
        {
            maxValue = dataModel.value;
            maxDataModel = dataModel;
        }
    }
    return maxDataModel;
}

/** Value for each column*/
- (EColumnDataModel *)     eColumnChart:(EColumnChart *) eColumnChart
                          valueForIndex:(NSInteger)index
{
    if (index >= [_data count] || index < 0) return nil;
    return [_data objectAtIndex:index];
    
}







- (UIColor *)colorForEColumn:(EColumn *)eColumn
{
//    if (eColumn.eColumnDataModel.index < 5)
//    {
//        return [UIColor purpleColor];
//    }
//    else
//    {
//        return [UIColor redColor];
//    }
    return [UIColor purpleColor];

}

#pragma -mark- EColumnChartDelegate
- (void)eColumnChart:(EColumnChart *)eColumnChart
     didSelectColumn:(EColumn *)eColumn
{
    NSLog(@"Index: %d  Value: %f", eColumn.eColumnDataModel.index, eColumn.eColumnDataModel.value);
    
    if (_eColumnSelected)
    {
        _eColumnSelected.barColor = _tempColor;
    }
    _eColumnSelected = eColumn;
    _tempColor = eColumn.barColor;
    eColumn.barColor = [UIColor colorWithRed:41/255 green:107/255 blue:255/255 alpha:1];
    
    _valueLabel.text = [NSString stringWithFormat:@"%.1f",eColumn.eColumnDataModel.value];
}

- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidEnterColumn:(EColumn *)eColumn
{
//    /**The EFloatBox here, is just to show an example of
//     taking adventage of the event handling system of the Echart.
//     You can do even better effects here, according to your needs.*/
//    NSLog(@"Finger did enter %d", eColumn.eColumnDataModel.index);
//    CGFloat eFloatBoxX = eColumn.frame.origin.x + eColumn.frame.size.width * 1.25;
//    CGFloat eFloatBoxY = eColumn.frame.origin.y + eColumn.frame.size.height * (1-eColumn.grade);
//    if (_eFloatBox)
//    {
//        [_eFloatBox removeFromSuperview];
//        _eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
//        [_eFloatBox setValue:eColumn.eColumnDataModel.value];
//        [eColumnChart addSubview:_eFloatBox];
//    }
//    else
//    {
//        _eFloatBox = [[EFloatBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:eColumn.eColumnDataModel.value unit:@"kWh" title:@"Title"];
//        _eFloatBox.alpha = 0.0;
//        [eColumnChart addSubview:_eFloatBox];
//        
//    }
//    eFloatBoxY -= (_eFloatBox.frame.size.height + eColumn.frame.size.width * 0.25);
//    _eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
//    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
//        _eFloatBox.alpha = 1.0;
//        
//    } completion:^(BOOL finished) {
//    }];
    
}

- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidLeaveColumn:(EColumn *)eColumn
{
//    NSLog(@"Finger did leave %d", eColumn.eColumnDataModel.index);
    
}

- (void)fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart
{
//    if (_eFloatBox)
//    {
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
//            _eFloatBox.alpha = 0.0;
//            _eFloatBox.frame = CGRectMake(_eFloatBox.frame.origin.x, _eFloatBox.frame.origin.y + _eFloatBox.frame.size.height, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
//        } completion:^(BOOL finished) {
//            [_eFloatBox removeFromSuperview];
//            _eFloatBox = nil;
//        }];
//        
//    }
    
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
