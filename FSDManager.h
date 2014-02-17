//
//  FSDManager.h
//  FourSquareDemo
//
//  Created by abbasi on 2/16/14.
//  Copyright (c) 2014 abbasi. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface FSDManager : NSObject

+(FSDManager*) instance;

-(void)search:(NSString*)searchString success:(void (^)(id response))success
      failure:(void (^)(NSError *error))failure;

-(void)getImageMetaDataForVenue:(NSString*)venueID success:(void (^)(id response))success
    failure:(void (^)(NSError *error))failure;

-(NSArray*)dataFromLocalCache:(NSString*)searchString;
@end
