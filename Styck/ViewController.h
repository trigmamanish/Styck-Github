//
//  ViewController.h
//  Styck
//
//  Created by Ravinderjeet Singh on 7/1/14.
//  Copyright (c) 2014 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)FacebookLoginBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *fbBtnOutlet;
@property (strong, nonatomic) IBOutlet UILabel *signLbl;

-(void) gotoNavigation;
@end
