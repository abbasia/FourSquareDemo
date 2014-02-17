//
//  FSDCollectionViewCell.m
//  FourSquareDemo
//
//  Created by abbasi on 2/16/14.
//  Copyright (c) 2014 abbasi. All rights reserved.
//

#import "FSDCollectionViewCell.h"
#import "FSDManager.h"
#import "UIImageView+AFNetworking.h"
@implementation FSDCollectionViewCell

#define kPlaceHolderImage  ([UIImage imageNamed:@"placeholder.jpg"])

-(void)setImageAnimated:(UIImage*)image{
    
    if (image==nil) {
        [self.imageView setImage:nil];
        [self.imageView setAlpha:0.5];
        [self.labelContainerView setAlpha:0.5];
        
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
    }
    else{
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.imageView setImage:image];
            [self.imageView setAlpha:1.0];
            [self.labelContainerView setAlpha:1.0];
            
            
        } completion:^(BOOL finished) {
            
            [self.activityIndicator stopAnimating];
            [self.activityIndicator setHidden:YES];
        }];
        
    }
    
}

-(void)updateContentWithDictionary:(NSDictionary*)dictionary{
    
    [self setImageAnimated:nil];
    
    NSString* venueID = [dictionary valueForKey:@"id"];
    
    NSString* name = [dictionary valueForKey:@"name"];
    
    NSString* address = [dictionary valueForKeyPath:@"location.address"];
    
    NSString* url = [dictionary valueForKey:@"url"];
    
    [self.titleLabel setText:name];
    
    [self.addressLabel setText:address];
    
    [self.urlLabel setText:url];
    
    //NSLog(@"%@",name);
    //NSLog(@"%@",dictionary);
    
    
    [[FSDManager instance] getImageMetaDataForVenue:venueID success:^(id response) {
        
        if (response) {
            NSLog(@"%@ path = %@",name,response);
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:response]];
            
            [self.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                
                if (image==nil) {
                    [self setImageAnimated:kPlaceHolderImage];
                    
                }
                else{
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        CGFloat imageHeight = image.size.height;
                        CGFloat imageWidth = image.size.width;
                        
                        CGSize newSize = self.imageView.bounds.size;
                        CGFloat scaleFactor = newSize.width / imageWidth;
                        newSize.height = imageHeight * scaleFactor;
                        
                        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
                        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                        UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        
                        dispatch_async(dispatch_get_main_queue(),^{
                            [self setImageAnimated:small];
                        });
                    });
                    
                }
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                NSLog(@"error = %@",error);
                
                [self setImageAnimated:kPlaceHolderImage];
            }];
            
        }
        else{
            [self setImageAnimated:kPlaceHolderImage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        
        [self setImageAnimated:kPlaceHolderImage];
    }];
    
    
}
@end
