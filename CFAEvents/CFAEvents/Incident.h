//
//  Incident.h
//  CFAEvents
//
//  Created by Robyn Van Deventer on 24/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSUInteger, IncidentStatus)
{
    IncidentStatusContained,
    IncidentStatusControlled,
    IncidentStatusGoing,
    IncidentStatusSafe,
    IncidentStatusUnknown
};

NS_ASSUME_NONNULL_BEGIN

/**
 *  Each incident is of type MKAnnotation for the purpose of displaying incident location on a map
 */
@interface Incident : NSManagedObject <MKAnnotation>

/**
 *  Fills all properties of the core data object with values in a dictionary
 *
 *  @param dictionary The dictionary that is passed in
 */
- (void)fillPropertiesFromDictionary:(NSDictionary *)dictionary;

/**
 *  Returns an incident status enum value based on an incident's status
 *
 *  @param incidentStatusString The incident's status
 *
 *  @return An enum value of incident status
 */
- (IncidentStatus)incidentStatusFromString:(NSString *)incidentStatusString;

@end

NS_ASSUME_NONNULL_END

#import "Incident+CoreDataProperties.h"
