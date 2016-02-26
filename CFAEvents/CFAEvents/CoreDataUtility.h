//
//  CoreDataUtility.h
//  CFAEvents
//
//  Created by Robyn Van Deventer on 25/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataUtility : NSObject

+ (void)createIncidentsFromDictionary:(NSDictionary *)dictionary withCompletionHandler:(void (^)(NSString *todo, NSError *error))completionHandler;

@end
