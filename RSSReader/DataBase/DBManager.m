//
//  DBManager.m
//  RSSReader
//
//  Created by Kirill Mazaev on 07.08.2019.
//  Copyright © 2019 mazaev. All rights reserved.
//

#import "DBManager.h"
// libraries
#import <MagicalRecord/MagicalRecord.h>
// project files
#import "Feed.h"

@implementation DBManager

// saving feeds into local database using Magical Record
- (void)save:(NSArray *) feed withHandler:(void (^)(BOOL didSave, NSError* _Nullable error)) block {
    // save feeds with local context in background thread
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        if (feed){
            // remove all old feeds from database
            [Feed MR_truncateAllInContext:localContext];
            // save all feeds form feeds array into local database
            for (FeedModelAPI *feedModelApi in feed) {
                // save feed into database in local context (in background thread)
                Feed *feed = [Feed MR_createEntityInContext:localContext];
                [feed createFrom:feedModelApi];
            }
        }
    }
    completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        // return result of operation
        if (error) {
            NSLog(@"Error: %@", error);
            block(false, error);
        } else {
            block(contextDidSave, nil);
        }
    }];
}

// fetch all feeds from data base sorted by publishing date
- (NSArray*)fetchAllSortedFeed {
    // get all feeds and set their in fetched feeds array
    NSArray *feedsArray = [Feed MR_findAllSortedBy:@"publication_date" ascending:false];
    return feedsArray;
}

@end
