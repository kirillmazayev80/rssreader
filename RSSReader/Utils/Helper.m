//
//  Helper.m
//  RSSReader
//
//  Created by Kirill Mazaev on 22.12.2018.
//  Copyright © 2018 mazaev. All rights reserved.
//

#import "Helper.h"

// base url of RSS2JSON api service
static const NSString * BASE_URL = @"https://api.rss2json.com/v1/api.json?rss_url=";
// api key of RSS2JSON api service
static const NSString * API_KEY = @"api_key=nqu7kl4zkjoczmo9jaunbvmwigoztytofsuhymr0";
// count of feeds
static const NSString * FEED_COUNT = @"count=20";
// Washington Post News Channel RSS
static const NSString * WP_RSS_URL = @"http://feeds.washingtonpost.com/rss/world";
// Daily Mirror Channel RSS
static const NSString * DAILY_MIRROR_URL = @"https://www.mirro.co.uk/news/?service=rss";

@implementation Helper

// singleton method initializer
+ (Helper *)sharedInstance {
    static Helper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[Helper alloc] init];
    });
    return helper;
}

// getting Washington Post Channel url
- (NSURL *)getWashPostUrl {
    NSString *bbcUrlString = [NSString stringWithFormat:@"%@%@&%@&%@",
                              BASE_URL, WP_RSS_URL, API_KEY, FEED_COUNT];
    NSURL *bbcUrl = [NSURL URLWithString:bbcUrlString];
    return bbcUrl;
}

// getting Daily Mirror News Channel url
- (NSURL *)getDailyMirrorUrl {
    NSString *dailyMirrorUrlString = [NSString stringWithFormat:@"%@%@&%@&%@",
                                      BASE_URL, DAILY_MIRROR_URL, API_KEY, FEED_COUNT];
    NSURL *dailyMirrorUrl = [NSURL URLWithString:dailyMirrorUrlString];
    return dailyMirrorUrl;
}

// getting localized string by key
- (NSString *)getLocalizedString:(NSString *) key {
    return NSLocalizedString(key, @"");
}

@end
