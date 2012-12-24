//
//  OpenCNAMSampleAppTests.m
//  OpenCNAMSampleAppTests
//
//  Created by Matt Sencenbaugh on 12/23/12.
//  Copyright (c) 2012 Matt Sencenbaugh. All rights reserved.
//

#import "OpenCNAMSampleAppTests.h"
#import "OpenCNAM.h"

@implementation OpenCNAMSampleAppTests

- (void)setUp
{
    self.openCNAM = [[OpenCNAM alloc] initWithAccountSID:nil withAuthToken:nil];
    self.openCNAM.asynchronous = NO;
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

-(void)testValidPhoneNumber
{
    [self.openCNAM submitRequestForPhoneNumber:@"+16502530000" responseHandler:^(NSDictionary *response){
        NSLog(@"%@",response);
        STAssertNotNil(response, @"Response should be a dictionary object");
    } errorHandler:^(NSError *error, NSNumber *statusCode, NSString *readableError){
        STFail(@"Response should have succeeded");
    }];
}

-(void)testInvalidPhoneNumber
{
    [self.openCNAM submitRequestForPhoneNumber:@"650253000" responseHandler:^(NSDictionary *response){
        STFail(@"Response should have failed");
    } errorHandler:^(NSError *error, NSNumber *statusCode, NSString *readableError){
        STAssertTrue([statusCode intValue] == 400, @"Error should return phone number format invalid");
    }];
}



@end
