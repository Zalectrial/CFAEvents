//
//  NetworkManager.h
//  CFAEvents
//
//  Created by Robyn Van Deventer on 24/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Creates a shared network manager for the purpose of downloading the CFA incidents data
 */
@interface NetworkManager : NSObject

/**
 *  Creates an istance of the shared manager
 *
 *  @return The shared manager
 */
+ (instancetype)sharedManager;

/**
 *  Downloads the CFA incident data from the given URL and then parses the xml data into a file
 *
 *  @param completionHandler Returns either a dictionary of the incidents or an error
 */
- (void)getCFAEventsWithCompletionHandler:(void (^)(NSDictionary *incidents, NSError *error))completionHandler;

@end
