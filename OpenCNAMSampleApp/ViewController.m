//
//  ViewController.m
//  OpenCNAMSampleApp
//
//  Created by Matt Sencenbaugh on 12/23/12.
//  Copyright (c) 2012 Matt Sencenbaugh. All rights reserved.
//

#import "ViewController.h"
#import "OpenCNAM.h"

@interface ViewController ()
{
    OpenCNAM *_openCNAM;
}

@end

@implementation ViewController
@synthesize phoneTextField = _phoneTextField, resultLabel = _resultLabel, activityIndicator = _activityIndicator;

- (void)viewDidLoad
{
    _openCNAM = [[OpenCNAM alloc] initWithAccountSID:nil withAuthToken:nil];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)lookupButtonPressed:(id)sender {
    [self.activityIndicator startAnimating];
    [_openCNAM submitRequestForPhoneNumber:self.phoneTextField.text responseHandler:^(NSDictionary *response){
        NSString *name = [response objectForKey:@"name"];
        self.resultLabel.text = name;
        [self.activityIndicator stopAnimating];
    } errorHandler:^(NSError *error, NSNumber *statusCode, NSString *readableError){
        NSString *errorToDisplay = (error) ? error.localizedDescription : readableError;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:errorToDisplay delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [self.activityIndicator stopAnimating];
    }];
}
@end
