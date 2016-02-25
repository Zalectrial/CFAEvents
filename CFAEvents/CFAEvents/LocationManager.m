//
//  LocationManager.m
//  CFAEvents
//
//  Created by Robyn Van Deventer on 24/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation LocationManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.distanceFilter = 10;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [self.locationManager requestAlwaysAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

+ (instancetype)sharedManager
{
    static LocationManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[LocationManager alloc] init];
    });
    
    return _sharedManager;
}

- (CLLocation *)getCurrentLocation
{
    return self.locationManager.location;
}

- (void)getDistanceFromIncidentLocation:(CLLocationCoordinate2D)incidentLocation toCurrentLocationWithCompletionHandler:(void (^)(CGFloat distance, NSError *error))completionHandler
{
    CLLocation *incident = [[CLLocation alloc] initWithLatitude:incidentLocation.latitude longitude:incidentLocation.longitude];
    CGFloat distanceBetweenLocations = [self.locationManager.location distanceFromLocation:incident];
    distanceBetweenLocations = distanceBetweenLocations / 1000;
    if (distanceBetweenLocations)
    {
        completionHandler(distanceBetweenLocations, nil);
    }
    else if (!self.locationManager.location)
    {
        completionHandler(0, [NSError createErrorWithMessage:@"Could not get your location"]);
    }
}

@end
