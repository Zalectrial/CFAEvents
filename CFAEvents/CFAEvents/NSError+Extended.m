//
//  NSError+Extended.m
//  CFAEvents
//
//  Created by Robyn Van Deventer on 25/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "NSError+Extended.h"

@implementation NSError (Extended)

+ (NSError *)createErrorWithMessage:(NSString *)message
{
    NSError *error = [NSError errorWithDomain:@"CFAEvents Error" code:01 userInfo:@{ NSLocalizedDescriptionKey : message }];
    
    return error;
}

@end
