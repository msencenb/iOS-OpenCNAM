//
//  OpenCNAM.h
//  OpenCNAMSampleApp
//
//  Created by Matt Sencenbaugh on 12/23/12.
//  Copyright (c) 2012 Matt Sencenbaugh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OpenCNAMResponseHandler)(NSDictionary *response);
typedef void (^OpenCNAMErrorResponseHandler)(NSError *error, NSNumber *statusCode, NSString *readableError);


@interface OpenCNAM : NSObject

-(id)initWithAccountSID:(NSString *)accountSID withAuthToken:(NSString *)authToken;
-(void)submitRequestForPhoneNumber:(NSString *)phoneNumber responseHandler:(OpenCNAMResponseHandler)callback errorHandler:(OpenCNAMErrorResponseHandler)errorCallback;

@property(nonatomic, assign)BOOL asynchronous;

@end
