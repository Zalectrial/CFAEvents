//
//  NetworkManager.m
//  CFAEvents
//
//  Created by Robyn Van Deventer on 24/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "NetworkManager.h"
#import "XMLDictionary.h"

static NSString *const CFAEventsURL = @"http://osom.cfa.vic.gov.au/public/osom/IN_COMING.xml";

@interface NetworkManager()

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *task;

@end

@implementation NetworkManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.url = [NSURL URLWithString:CFAEventsURL];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

+ (instancetype)sharedManager {
    static NetworkManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[NetworkManager alloc] init];
    });
    
    return _sharedManager;
}

- (void)getCFAEventsWithCompletionHandler:(void (^)(NSDictionary *incidents, NSError *))completionHandler
{
    self.task = [self.session downloadTaskWithURL:self.url completionHandler:^(NSURL * _Nullable localFile, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if (error)
        {
            completionHandler(nil, error);
        }
        else
        {
            NSString *path = [localFile path];
            NSDictionary *dictionary = [NSDictionary dictionaryWithXMLFile:path];
            completionHandler(dictionary, nil);
        }
    }];
    
    [self.task resume];
}

@end
