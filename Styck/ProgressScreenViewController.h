//
//  ProgressScreenViewController.h
//  Styck
//
//  Created by Ravinderjeet Singh on 7/7/14.
//  Copyright (c) 2014 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EColumnChart.h"

@interface ProgressScreenViewController : UIViewController <EColumnChartDelegate, EColumnChartDataSource>

@property (strong, nonatomic) IBOutlet UILabel *atheleteIDLbl;
@property (strong, nonatomic) IBOutlet UILabel *authTokenLbl;


@property (nonatomic, weak) NSString * athleteId2;
@property (nonatomic, strong) NSString *token2;

@property (strong, nonatomic) EColumnChart *eColumnChart;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;



@end
