//
//  LocationManager.h
//  CFAEvents
//
//  Created by Robyn Van Deventer on 24/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A shared location manager for the purpose of handling location information
 */
@interface LocationManager : NSObject

/**
 *  Creates an instance of the shared manager
 *
 *  @return The shared manager
 */
+ (instancetype)sharedManager;

/**
 *  Gets the current location from the location manager
 *
 *  @return The current location
 */
- (CLLocation *)getCurrentLocation;

/**
 *  Gets the distanct in kilometers between the user's current location and the incident location
 *
 *  @param incidentLocation  The location of the incident
 */
- (CGFloat)getDistanceFromCurrentLocationToIncidentLocation:(CLLocationCoordinate2D)incidentLocation;

@end
