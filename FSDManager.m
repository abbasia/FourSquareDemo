//
//  FSDManager.m
//  FourSquareDemo
//
//  Created by abbasi on 2/16/14.
//  Copyright (c) 2014 abbasi. All rights reserved.
//

#import "FSDManager.h"
#import "FSDWebService.h"

@interface FSDManager ()

@property(strong,nonatomic) NSMutableDictionary* dataDictionary;
@end

@implementation FSDManager

-(NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    return [docDirectory stringByAppendingPathComponent:@"data"];
}

-(NSMutableDictionary*)readDataFromDisk{
    
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:[self dataFilePath]];
    
    if (dictionary==nil) dictionary = [NSMutableDictionary dictionary];
    
    return dictionary;
    
}

-(BOOL)writeDataToDisk{
    
    NSString* path = [self dataFilePath];
    
    NSLog(@"fielPath=%@",path);
    
    BOOL success =  [self.dataDictionary writeToFile:[self dataFilePath] atomically:YES];
    
    return success;
}

+(FSDManager*) instance {
    static FSDManager* myInstance = nil;
    if ( myInstance == nil ) {
        myInstance = [[FSDManager alloc] init];
    }
    return myInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.dataDictionary = [self readDataFromDisk];
    
        
    }
    return self;
}

-(NSArray*)dataFromLocalCache:(NSString*)searchString{
    
    NSArray* keys = [self.dataDictionary allKeys];
    
    NSString* substring = [searchString lowercaseString];
    
    NSMutableArray* response = [NSMutableArray array];
    
    for (NSString* key in keys) {
        NSRange textRange;
        textRange =[[key lowercaseString] rangeOfString:substring];
        
        if(textRange.location != NSNotFound)
        {
            [response addObjectsFromArray:[self.dataDictionary valueForKey:key]];
            
        }
    }
    
    if ([response count]>0) {
        return response;
    }
    
    return nil;
    
}


-(NSString*)getLocation{
    
    NSString* location;
    
    // location is fixed to helsinki, cllocationmanager can be used to get the current user location if required
    // right now hardcoding location value
    location = [NSString stringWithFormat:@"60.1708,24.9375"];
    
    return location;
    
}

-(void)search:(NSString*)searchString success:(void (^)(id response))success
      failure:(void (^)(NSError *error))failure{
    
    NSArray* response = [self dataFromLocalCache:searchString];
    
    success(response);
    
    
    
    [[FSDWebService instance] search:searchString forLocation:[self getLocation] success:^(id response) {
        
        NSDictionary* dictionary = [response valueForKey:@"response"];
        
        NSArray* venues = [dictionary valueForKey:@"venues"];
        
        [self.dataDictionary setObject:venues forKey:searchString];
        
        [self writeDataToDisk];
        
        success(venues);
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
}


@end
