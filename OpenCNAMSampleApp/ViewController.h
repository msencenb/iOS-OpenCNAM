//
//  ViewController.h
//  OpenCNAMSampleApp
//
//  Created by Matt Sencenbaugh on 12/23/12.
//  Copyright (c) 2012 Matt Sencenbaugh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)lookupButtonPressed:(id)sender;

@end
