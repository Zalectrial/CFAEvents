//
//  Incident.m
//  CFAEvents
//
//  Created by Robyn Van Deventer on 24/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "Incident.h"

@implementation Incident

- (void)fillPropertiesFromDictionary:(NSDictionary *)dictionary
{
    self.status = [dictionary[@"incidentStatus"] capitalizedString];
    self.size = [dictionary[@"incidentSize"] capitalizedString];
    self.location = [dictionary[@"incidentLocation"] capitalizedString];
    self.owner = dictionary[@"territory"];
    self.resourceCount = @([dictionary[@"resourceCount"] doubleValue]);
    self.latitude = @([dictionary[@"latitude"] doubleValue]);
    self.longitude = @([dictionary[@"longitude"] doubleValue]);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d/MM/yy h:m:s a"];
    self.originDate = [formatter dateFromString:dictionary[@"incidentOriginDate"]];
    self.type = [dictionary[@"incidentType"] capitalizedString];
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

- (NSString *)title
{
    return self.type;
}

- (NSString *)subtitle
{
    return self.status;
}

- (IncidentStatus)incidentStatusFromString:(NSString *)incidentStatusString
{
    if ([incidentStatusString isEqualToString:@"Going"])
    {
        return IncidentStatusGoing;
    }
    else if ([incidentStatusString isEqualToString:@"Controlled"])
    {
        return IncidentStatusControlled;
    }
    else if ([incidentStatusString isEqualToString:@"Contained"])
    {
        return IncidentStatusContained;
    }
    else if ([incidentStatusString isEqualToString:@"Safe"])
    {
        return IncidentStatusSafe;
    }
    else
    {
        return IncidentStatusUnknown;
    }
    
}

@end
