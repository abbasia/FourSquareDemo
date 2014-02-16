//
//  FSDWebService.m
//  FourSquareDemo
//
//  Created by abbasi on 2/16/14.
//  Copyright (c) 2014 abbasi. All rights reserved.
//

#import "FSDWebService.h"
#import "AFHTTPSessionManager.h"
// Reusable HTTP client
@interface FSDWebService ()

@property (nonatomic, strong) AFHTTPSessionManager* sessionManager;
@property (nonatomic, strong) NSDateFormatter* dateFormatter;

@end

static NSString *BASEURL = @"https://api.foursquare.com/v2/venues/search";

static NSString* CLIENT_ID = @"BEGBUBLXCMV4K42XQCDEXG4OZNAKTUIVRDHKHDD41LROOXJ1";
static NSString* CLIENT_SECRET = @"HLWU3YAVQC2FXQGN0JXZ5IZXURQETIZGUOPHAOBF3E143KG3";

static NSString* DATE_FORMAT = @"YYYYMMdd";

@implementation FSDWebService

+(FSDWebService*) instance {
    static FSDWebService* myInstance = nil;
    if ( myInstance == nil ) {
        myInstance = [[FSDWebService alloc] init];
    }
    return myInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.sessionManager = [[AFHTTPSessionManager alloc] init];
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:DATE_FORMAT];
    }
    
    return self;
}

-(NSString*)getSearchUrlString:(NSString*)searchString{
    
    NSDate* date = [NSDate date];
    NSString* dateString = [self.dateFormatter stringFromDate:date];
    
    NSString* returnString = [NSString stringWithFormat:@"%@?ll=%@&query=%@&client_id=%@&client_secret=%@&v=%@",BASEURL,@"60.1708,24.9375",searchString,CLIENT_ID,CLIENT_SECRET,dateString];
    
    NSLog(@"search path = %@",returnString);
    
    return returnString;
    
}

-(void)search:(NSString*)searchString success:(void (^)(id response))success
      failure:(void (^)(NSError *error))failure{
    
    
    [self.sessionManager GET:[self getSearchUrlString:searchString] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}
@end
