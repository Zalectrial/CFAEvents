//
//  NSError+Extended.h
//  CFAEvents
//
//  Created by Robyn Van Deventer on 25/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  An error extension for the purpose of creating custom error messages
 */
@interface NSError (Extended)

/**
 *  Create a custom error with the message that is passed in
 *
 *  @param message The message to display to the user
 *
 *  @return The custom error
 */
+ (NSError *)createErrorWithMessage:(NSString *)message;

@end
