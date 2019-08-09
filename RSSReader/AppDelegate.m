//
//  AppDelegate.m
//  RSSReader
//
//  Created by Kirill Mazaev on 19.12.2018.
//  Copyright © 2018 mazaev. All rights reserved.
//

#import "AppDelegate.h"
#import "Helper.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // set MagicalRecord
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Feed"];
    // set current channel url
    [self setCurrentUrl];
    return YES;
}

# pragma mark - Custom functions
// initialize current url with bbc url
- (void)setCurrentUrl {
    // get user defaults manager
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // if application has launched first time - set bbc url
    if ([userDefaults URLForKey:@"current_url"] == nil) {
        // get bbc url from helper
        Helper *helper = [Helper sharedInstance];
        NSURL *initialUrl = [helper getWashPostUrl];
        // set current channel url to user defaults storage
        [userDefaults setURL:initialUrl forKey:@"current_url"];
        [userDefaults setObject:@"wp" forKey:@"current_channel"];
    }
}

@end
