//
//  FSDWebService.h
//  FourSquareDemo
//
//  Created by abbasi on 2/16/14.
//  Copyright (c) 2014 abbasi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSDWebService : NSObject

+(FSDWebService*) instance;


-(void)search:(NSString*)searchString success:(void (^)(id response))success
      failure:(void (^)(NSError *error))failure;

@end
