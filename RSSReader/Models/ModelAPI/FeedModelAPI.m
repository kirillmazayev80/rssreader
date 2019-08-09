//
//  FeedModelAPI.m
//  RSSReader
//
//  Created by Kirill Mazaev on 19.12.2018.
//  Copyright © 2018 mazaev. All rights reserved.
//

#import "FeedModelAPI.h"
#import "NSString+Date.h"

@implementation FeedModelAPI

// Initializer
- (instancetype)initWith:(NSDictionary*) item {
    self = [super init];
    if (self) {
        // getting feed items: title, description, link url
        if (item[@"title"]) _title = item[@"title"];
        if (item[@"description"]) _summary = item[@"description"];
        if (item[@"link"]) _linkUrl = item[@"link"];
        // getting image url
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"current_channel"] isEqualToString:@"wp"]) {
            // if current channel is "Washigton Post" getting image url by key "thumbnail"
            if (item[@"thumbnail"]) _imageUrl = item[@"thumbnail"];
        } else {
            // if current channel is "Daily Mirror" getting image url by keys "enclosure" & "link"
            if (item[@"enclosure"]) {
                NSDictionary *enclosure = item[@"enclosure"];
                _imageUrl = enclosure[@"link"];
            }
        }
        // getting publishing date
        if (item[@"pubDate"]) {
            NSString *publicationDateString = item[@"pubDate"];
            _publicationDate = [publicationDateString getDate];
        }
    }
    return self;
}

@end
