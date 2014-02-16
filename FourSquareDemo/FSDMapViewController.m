//
//  FSDMapViewController.m
//  FourSquareDemo
//
//  Created by abbasi on 2/16/14.
//  Copyright (c) 2014 abbasi. All rights reserved.
//

#import "FSDMapViewController.h"

#import "PlaceAnnotation.h"

#define METERS_PER_MILE 1609.344

@interface FSDMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation FSDMapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (self.venueDictionary!=nil)
    {
        
        NSString* name = [self.venueDictionary valueForKey:@"name"];
        
        NSString* latitude = [self.venueDictionary valueForKeyPath:@"location.lat"];
        NSString* longitude = [self.venueDictionary valueForKeyPath:@"location.lng"];
        
        CLLocationCoordinate2D coorindate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coorindate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        [self.mapView setRegion:viewRegion animated:YES];
        
        NSString* url = [self.venueDictionary valueForKey:@"url"];
        
        
        self.title = name;
        
        // add the single annotation to our map
        PlaceAnnotation *annotation = [[PlaceAnnotation alloc] init];
        //annotation.coordinate = mapItem.placemark.location.coordinate;
        annotation.coordinate = coorindate;
        annotation.title = name;
        annotation.url = [NSURL URLWithString:url];
        [self.mapView addAnnotation:annotation];
        
        // we have only one annotation, select it's callout
        [self.mapView selectAnnotation:[self.mapView.annotations objectAtIndex:0] animated:YES];
        
        // center the region around this map item's coordinate
        self.mapView.centerCoordinate = coorindate;
    }
}


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKPinAnnotationView *annotationView = nil;
	if ([annotation isKindOfClass:[PlaceAnnotation class]])
	{
		annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
		if (annotationView == nil)
		{
			annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
			annotationView.canShowCallout = YES;
			annotationView.animatesDrop = YES;
		}
	}
	return annotationView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
