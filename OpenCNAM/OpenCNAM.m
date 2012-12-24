//
//  OpenCNAM.m
//
//  Created by Matt Sencenbaugh (www.sencedev.com) on 12/23/12.
//
//

#import "OpenCNAM.h"

@interface OpenCNAM ()
{
    NSString *_accountSID;
    NSString *_authToken;
    NSString *_baseURL;
    NSString *_format;
}

@end

@implementation OpenCNAM
@synthesize asynchronous = _asynchronous;

-(id)initWithAccountSID:(NSString *)accountSID withAuthToken:(NSString *)authToken
{
    self = [super init];
    if (self) {
        _accountSID = accountSID;
        _authToken = authToken;
        _format = @"?format=json";
        _baseURL = @"https://api.opencnam.com/v2/phone/";
        
        //Default to asynchronous
        self.asynchronous = YES;
    }
    return self;
}

-(void)submitRequestForPhoneNumber:(NSString *)phoneNumber responseHandler:(OpenCNAMResponseHandler)callback errorHandler:(OpenCNAMErrorResponseHandler)errorCallback
{
    NSString *proAccountAuthAppend = nil;
    NSURL *url = nil;
    if (_accountSID && _authToken) {
        proAccountAuthAppend = [NSString stringWithFormat:@"&account_sid=%@&auth_token=%@",_accountSID,_authToken];
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@%@",_baseURL,phoneNumber,_format,proAccountAuthAppend]];
    } else {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",_baseURL,phoneNumber,_format]];
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    if (self.asynchronous) {
        [self sendAsynchronousRequest:request responseHandler:callback errorHandler:errorCallback];
    } else {
        [self sendSynchronousRequest:request responseHandler:callback errorHandler:errorCallback];
    }
}

-(void)sendAsynchronousRequest:(NSMutableURLRequest *)request responseHandler:(OpenCNAMResponseHandler)callback errorHandler:(OpenCNAMErrorResponseHandler)errorCallback
{
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error) {
        [self parseResponse:urlResponse withData:data withError:error responseHandler:callback errorResponseHandler:errorCallback];
    }];
}

-(void)sendSynchronousRequest:(NSMutableURLRequest *)request responseHandler:(OpenCNAMResponseHandler)callback errorHandler:(OpenCNAMErrorResponseHandler)errorCallback
{
    //Use __autoreleasing because these are passed by reference (See ARC transition guide for more info)
    NSURLResponse __autoreleasing *response = nil;
    NSError __autoreleasing *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [self parseResponse:response withData:data withError:error responseHandler:callback errorResponseHandler:errorCallback];    
}

-(void)parseResponse:(NSURLResponse *)response withData:(NSData *)data withError:(NSError *)error responseHandler:(OpenCNAMResponseHandler)callback errorResponseHandler:(OpenCNAMErrorResponseHandler)errorCallback
{
    //Check for connection error
    if (error) {
        errorCallback(error, [NSNumber numberWithInt:-1], error.localizedDescription);
        return;
    }
    
    //Check for status code errors from OpenCNAM
    NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
    if (urlResponse.statusCode != 200) {
        NSString *readableError = [self getReadableErrorFromURLResponse:urlResponse];
        NSNumber *numberStatuscode = [NSNumber numberWithInt:urlResponse.statusCode];
        errorCallback(nil,numberStatuscode,readableError);
        return;
    }
    
    //Parse response and pass back NSDictionary
    NSError *parseError = nil;
    NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
    
    if (parseError) {
        errorCallback(parseError, [NSNumber numberWithInt:-1], parseError.localizedDescription);
        return;
    }
    
    callback(responseJson);
}

-(NSString *)getReadableErrorFromURLResponse:(NSHTTPURLResponse *)urlResponse
{
    NSString *readableError = nil;
    switch (urlResponse.statusCode) {
        case 400:
            readableError = @"The phone number entered is invalid. Please ensure you have correctly entered a 10 digit phone number";
            break;
            
        case 401:
            readableError = @"You are unauthorized to view this information, please check your account SID and authorization token.";
            break;
            
        case 402:
            readableError = @"You don't have enough money in your account for this query. Please add more money to your OpenCNAM account.";
            break;
            
        case 403:
            readableError = @"You have hit your hourly usage limit, please wait an hour and try again or upgrade your OpenCNAM account";
            break;
        case 404:
            readableError = @"There is no information currently available for the phone number entered";
            break;
            
        default:
            readableError = @"Sorry something went wrong";
            break;
    }
    return readableError;
}

@end
