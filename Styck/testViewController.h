//
//  testViewController.h
//  Styck
//
//  Created by Ravinderjeet Singh on 7/10/14.
//  Copyright (c) 2014 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface testViewController : UIViewController

-(void) exchangeToken:(NSString *)code;
-(void) showAuthFailedWithError:(NSString *)error;

@end
