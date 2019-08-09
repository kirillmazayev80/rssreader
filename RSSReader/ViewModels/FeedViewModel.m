//
//  FeedViewModel.m
//  RSSReader
//
//  Created by Kirill Mazaev on 19.12.2018.
//  Copyright © 2018 mazaev. All rights reserved.
//

#import "FeedViewModel.h"
// libraries
#import <AFNetworking/AFNetworking.h>
#import "FBKVOController.h"
#import <KVOController/NSObject+FBKVOController.h>
// project files
#import "APIManager.h"
#import "DBManager.h"
#import "FeedModelAPI.h"
#import "Feed.h"

@interface FeedViewModel ()
@property (strong, nonatomic) NSArray *fetchedFeeds;
@property (strong, nonatomic) APIManager *apiManager;
@property (strong, nonatomic) DBManager *dbManager;
@end

@implementation FeedViewModel

// Initializer
- (instancetype)init {
    self = [super init];
    if (self) {
        _apiManager = [APIManager new];
        _dbManager = [DBManager new];
        [self setupMonitoringReachability];
    }
    return self;
}

// setting monitoring reachability (checking internet connection)
- (void)setupMonitoringReachability {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]
     setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
         NSLog(@"Reachability changed: %@", AFStringFromNetworkReachabilityStatus(status));
         // checking reachability
         if (status == AFNetworkReachabilityStatusNotReachable) {
             // Not connected
             NSNumber *isDisconnected = [NSNumber numberWithBool:true];
             [self setValue:isDisconnected forKeyPath:@"isDisconnected"];
         } else {
             // Connected
             NSNumber *isDisconnected = [NSNumber numberWithBool:false];
             [self setValue:isDisconnected forKeyPath:@"isDisconnected"];
         }
     }];
}

// load feeds from channel by url
- (void)loadFeedsbyURL:(NSURL *) url {
    __weak FeedViewModel *weakSelf = self;

    [self.apiManager getFeedsWithURL:url
                        handler:^(NSArray * _Nullable fetchedFeed, NSError * _Nullable error) {
        if (error) {
            // getting load error
            [weakSelf errorSignalize:error];
        } else {
            // getting fetched feed
            NSArray *feedsArr = fetchedFeed;
            // save feeds into local database
            [weakSelf.dbManager save:feedsArr
                         withHandler:^(BOOL didSave, NSError * _Nullable error) {
                             if (error) {
                                 // error of data saving
                                 [weakSelf errorSignalize:error];
                             } else {
                                 if (didSave) {
                                     // saving feeds into local database using Magical Record
                                     [weakSelf fetchAllFeedSortedByAttribute];
                                     if (weakSelf.hasReceivedError) {
                                         [weakSelf setValue:[NSNumber numberWithBool:false] forKeyPath:@"hasReceivedError"];
                                     }
                                 }
                             }
                         }];
            // getting channel title
            [weakSelf setTitle];
        }
    }];
}

//
- (void)errorSignalize:(NSError*) error {
    NSLog(@"Error: %@", error);
    NSNumber *hasReceivedError = [NSNumber numberWithBool:true];
    [self setValue:hasReceivedError forKeyPath:@"hasReceivedError"];
}

- (void)setTitle {
    NSString *currChannel = [[NSUserDefaults standardUserDefaults] valueForKey:@"current_channel"];
    if (currChannel) {
        if ([currChannel isEqualToString:@"wp"]) {
            [self setValue:@"Washington Post" forKey:@"channelTitle"];
        } else {
            [self setValue:@"Daily Mirror" forKey:@"channelTitle"];
        }
    }
}

// fetch all feeds from data base sorted by publishing date
- (void)fetchAllFeedSortedByAttribute {
    // remove all feeds from feeds array
    if (self.feedsArray.count > 0) {
        [self.feedsArray removeAllObjects];
    }
    // get all feeds and set their in fetched feeds array
    NSArray *feedsArray = [self.dbManager fetchAllSortedFeed];
    [[self mutableArrayValueForKeyPath:@"feedsArray"] addObjectsFromArray:feedsArray];
    self.fetchedFeeds = feedsArray;
}

// searching feeds in array by prefix of title
- (void)searchFeedByTitlePrefix:(NSString *) prefix {
    // init temporary array
    NSMutableArray *tempArr = [NSMutableArray new];
    // search feeds by title prefix and adding into temporary array
    for (Feed *feed in self.feedsArray){
        if ([feed.title hasPrefix:prefix]) {
            [tempArr addObject:feed];
        }
    }
    // setting searched feeds into feeds array
    if ([tempArr count] != 0) {
        [self.feedsArray removeAllObjects];
        [[self mutableArrayValueForKeyPath:@"feedsArray"] addObjectsFromArray:tempArr];
    }
}

@end
