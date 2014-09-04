//
//  ConnectStravaViewController.h
//  Styck
//
//  Created by Ravinderjeet Singh on 7/2/14.
//  Copyright (c) 2014 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectStravaViewController : UIViewController
{
    
}

-(void) exchangeToken:(NSString *)code;
-(void) showAuthFailedWithError:(NSString *)error;


- (IBAction)StravaConnectBtn:(id)sender;
- (IBAction)newObjectBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIButton *authorizeButton;
@property (strong, nonatomic) IBOutlet UIButton *btnnwOtlt;
@property (strong, nonatomic) IBOutlet UILabel *connectBigLbl;

@end
