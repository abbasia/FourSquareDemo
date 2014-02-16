//
//  FSDCollectionViewCell.m
//  FourSquareDemo
//
//  Created by abbasi on 2/16/14.
//  Copyright (c) 2014 abbasi. All rights reserved.
//

#import "FSDCollectionViewCell.h"

@implementation FSDCollectionViewCell

-(void)updateContentWithDictionary:(NSDictionary*)dictionary{
    
    NSString* name = [dictionary valueForKey:@"name"];
    
    NSString* address = [dictionary valueForKeyPath:@"location.address"];
    
    NSString* url = [dictionary valueForKey:@"url"];
    
    [self.titleLabel setText:name];
    
    [self.addressLabel setText:address];
    
    [self.urlLabel setText:url];
    
}
@end
