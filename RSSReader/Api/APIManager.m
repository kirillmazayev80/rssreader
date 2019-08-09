//
//  ApiManager.m
//  RSSReader
//
//  Created by Kirill Mazaev on 07.08.2019.
//  Copyright © 2019 mazaev. All rights reserved.
//

#import "APIManager.h"
// libraries
#import <AFNetworking/AFNetworking.h>
// project files
#import "FeedModelAPI.h"
#import "NSString+Date.h"

@implementation APIManager

- (void)getFeedsWithURL:(NSURL*) url handler:(void (^)(NSArray* fetchedFeed, NSError* error)) block {
    // getting configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // getting session manager
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    // setting JSON response serializer
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // getting request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // resume feeds loading task
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest: request
                                                   uploadProgress: nil
                                                 downloadProgress: nil
                                                completionHandler:^(NSURLResponse * _Nonnull response,
                                                                    id  _Nullable responseObject,
                                                                    NSError * _Nullable error) {
                                                    if (error) {
                                                        // getting load error
                                                        NSLog(@"Error: %@", error);
                                                        // return block with error
                                                        block(nil, error);
                                                    } else {
                                                        // convert JSON response to dictionary
                                                        NSDictionary *responseDict = (NSDictionary*)responseObject;
                                                        // getting array of fetching feed
                                                        NSArray *feedItems = responseDict[@"items"];
                                                        // feed parsing
                                                        NSMutableArray *fetchedFeed = [NSMutableArray new];
                                                        for (NSDictionary* item in feedItems) {
                                                            FeedModelAPI *feedModelAPI = [[FeedModelAPI alloc] initWith:item];
                                                            [fetchedFeed addObject:feedModelAPI];
                                                        }
                                                        // return block with response object
                                                        block(fetchedFeed, nil);
                                                    }
                                                }];
    [dataTask resume];
}

@end
