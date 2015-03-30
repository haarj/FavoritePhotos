//
//  MapViewController.m
//  FavoritePhotos
//
//  Created by Justin Haar on 3/29/15.
//  Copyright (c) 2015 Justin Haar. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "Image.h"

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView.delegate = self;
    [self loadImages];
}


-(void)loadImages
{
    for (Image *image in self.arrayOfImages)
    {
        MKPointAnnotation *imageAnnotation = [[MKPointAnnotation alloc]init];
        if (image.coordinate.latitude >-90)
        {
        imageAnnotation.coordinate = image.coordinate;
        [self.mapView addAnnotation:imageAnnotation];
        [self.mapView showAnnotations:self.arrayOfImages animated:YES];
        }
    }
}

//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
//    //THIS SETS THE IMAGE TO JUST THE MOBILE MAKERS LOCATION AND THE  ADD ANNOTATION AND USERLOCATION TO DEFAULT
//    if ([annotation isEqual:self.imageAnnotation]) {
//        pinAnnotation.image = [UIImage imageNamed:@"bikeImage"];
//    } else if ([annotation isEqual:mapView.userLocation])
//    {
//        return nil;
//    }
//    pinAnnotation.canShowCallout = YES;
//    pinAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    return pinAnnotation;
//}
@end
