//
//  Image.h
//  FavoritePhotos
//
//  Created by Justin Haar on 3/28/15.
//  Copyright (c) 2015 Justin Haar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface Image : NSObject

@property UIImage *instagramImage;
@property CLLocationCoordinate2D coordinate;
@property BOOL isFavorite;

@end

