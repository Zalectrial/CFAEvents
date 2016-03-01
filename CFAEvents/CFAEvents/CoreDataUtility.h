//
//  CoreDataUtility.h
//  CFAEvents
//
//  Created by Robyn Van Deventer on 25/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A core data utility with helper methods relating to core data
 */
@interface CoreDataUtility : NSObject

/**
 *  Populates core data with all the incidents retrieved from the network download
 *
 *  @param dictionary        The dictionary of incidents
 *  @param completionHandler Passes back a boolen indicating success or an error
 */
+ (void)createIncidentsFromDictionary:(NSDictionary *)dictionary withCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler;

@end
