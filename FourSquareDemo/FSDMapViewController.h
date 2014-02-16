//
//  FSDMapViewController.h
//  FourSquareDemo
//
//  Created by abbasi on 2/16/14.
//  Copyright (c) 2014 abbasi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface FSDMapViewController : UIViewController<MKMapViewDelegate>

@property (nonatomic, strong) NSMutableDictionary* venueDictionary;

@end
