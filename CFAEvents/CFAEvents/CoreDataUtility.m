//
//  CoreDataUtility.m
//  CFAEvents
//
//  Created by Robyn Van Deventer on 25/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "CoreDataUtility.h"
#import "Incident.h"

@implementation CoreDataUtility

+ (void)createIncidentsFromDictionary:(NSDictionary *)dictionary withCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext)
    {
        [Incident MR_truncateAllInContext:localContext];
        
        for (NSDictionary *event in dictionary[@"publish"])
        {
            Incident *incident = [Incident MR_createEntityInContext:localContext];
            [incident fillPropertiesFromDictionary:event];
        }
    }
    completion:^(BOOL contextDidSave, NSError * _Nullable error)
    {
        if (error)
        {
            completionHandler(NO, [NSError createErrorWithMessage:@"Could not save incidents"]);
        }
        else if (!contextDidSave)
        {
            completionHandler(NO, [NSError createErrorWithMessage:@"Unexpected saving error"]);
        }
        else
        {
            completionHandler(YES, nil);
        }
    }];
}

@end
