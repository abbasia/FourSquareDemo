//
//  FSDWebService.m
//  FourSquareDemo
//
//  Created by abbasi on 2/16/14.
//  Copyright (c) 2014 abbasi. All rights reserved.
//

#import "FSDWebService.h"
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperation.h"
// Reusable HTTP client
@interface FSDWebService ()

@property (nonatomic, strong) AFHTTPSessionManager* sessionManager;
@property (nonatomic, strong) NSDateFormatter* dateFormatter;

@end

static NSString *BASEURL = @"https://api.foursquare.com/v2/venues/";

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
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:DATE_FORMAT];
    }
    
    return self;
}

-(NSString*)getSearchUrlString:(NSString*)searchString forLocation:(NSString*)locationString{
    
    NSDate* date = [NSDate date];
    NSString* dateString = [self.dateFormatter stringFromDate:date];
    
    NSString* returnString = [NSString stringWithFormat:@"search?ll=%@&query=%@&client_id=%@&client_secret=%@&v=%@",locationString,searchString,CLIENT_ID,CLIENT_SECRET,dateString];
    
    NSLog(@"search path = %@",returnString);
    
    return returnString;
    
}

-(void)search:(NSString*)searchString forLocation:(NSString*)locationString success:(void (^)(id response))success
      failure:(void (^)(NSError *error))failure{
    
    
    [self.sessionManager GET:[self getSearchUrlString:searchString forLocation:locationString] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}

-(NSString*)getImageUrlString:(NSString*)venueID{
    NSDate* date = [NSDate date];
    NSString* dateString = [self.dateFormatter stringFromDate:date];
    
    NSString* returnString = [NSString stringWithFormat:@"%@/photos?client_id=%@&client_secret=%@&v=%@&limit=1",
                              venueID,CLIENT_ID,CLIENT_SECRET,dateString];
    
    return returnString;
}

-(void)getImageMetaDataForVenue:(NSString*)venueID success:(void (^)(id response))success
                failure:(void (^)(NSError *error))failure{
    
    [self.sessionManager GET:[self getImageUrlString:venueID] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
    
}

-(void)getImage:(NSString*)urlString success:(void (^)(id response))success
        failure:(void (^)(NSError *error))failure{
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
    /*
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:photourl]];
    AFImageRequestOperation *operation;
    operation = [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                     imageProcessingBlock:nil
                                                                cacheName:nil
                                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                      
                                                                  } 
                                                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                      NSLog(@"%@", [error localizedDescription]);
                                                                  }];
     */
}
@end
