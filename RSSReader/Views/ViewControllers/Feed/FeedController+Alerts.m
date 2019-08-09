//
//  FeedController+Alerts.m
//  RSSReader
//
//  Created by Kirill Mazaev on 08.08.2019.
//  Copyright © 2019 mazaev. All rights reserved.
//

#import "FeedController.h"
#import "FeedController+Alerts.h"
#import <UIKit/UIKit.h>
// project files
#import "FeedViewModel.h"
#import "Helper.h"

@implementation FeedController(Alerts)

// changing rss channel method ("Washington Post" or "Daily Mirror")
- (void)changeRssChannelAlert {
    __weak FeedController *weakSelf = self;
    __block NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // action sheet customize
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:[self.helper getLocalizedString:@"Select channel"]
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    // initialize "Washington Post Channel" choosing action
    UIAlertAction *bbsPickChannelAction = [UIAlertAction actionWithTitle:@"Washington Post"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     NSString *currentChannel = [userDefaults valueForKey:@"current_channel"];
                                                                     // change channel to "WP" if current channel is "Daily Mirror"
                                                                     if ([currentChannel isEqualToString:@"daily_mirror"]) {
                                                                         // getting bbc url
                                                                         NSURL *newUrl = [weakSelf.helper getWashPostUrl];
                                                                         // set bbc url and channel name in user defaults storage
                                                                         [userDefaults setURL:newUrl forKey:@"current_url"];
                                                                         [userDefaults setObject:@"wp" forKey:@"current_channel"];
                                                                         // load feeds from bbc channel
                                                                         [weakSelf.feedViewModel loadFeedsbyURL:newUrl];
                                                                     }
                                                                 }];
    // initialize "Daily Mirror" choosing action
    UIAlertAction *dailyMirrorPickChannelAction = [UIAlertAction actionWithTitle:@"Daily Mirror"
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                             NSString *currentChannel = [userDefaults valueForKey:@"current_channel"];
                                                                             // change channel to "Daily Mirror" if current channel is "Washington Post"
                                                                             if ([currentChannel isEqualToString:@"wp"]) {
                                                                                 // getting daily mirror url
                                                                                 NSURL *newUrl = [weakSelf.helper getDailyMirrorUrl];
                                                                                 // set daily mirror url and channel name in user defaults
                                                                                 [userDefaults setURL:newUrl forKey:@"current_url"];
                                                                                 [userDefaults setObject:@"daily_mirror" forKey:@"current_channel"];
                                                                                 // load feeds from "Daily Mirror Channel"
                                                                                 [weakSelf.feedViewModel loadFeedsbyURL:newUrl];
                                                                             }
                                                                         }];
    // setting cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[self.helper getLocalizedString:@"Cancel"]
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [actionSheet addAction:bbsPickChannelAction];
    [actionSheet addAction:dailyMirrorPickChannelAction];
    [actionSheet addAction:cancelAction];
    
    // present selecting channel action sheet
    [self presentViewController:actionSheet animated:true completion:nil];
}

// fetch feeds from database if internet has disconnected
- (void)fetchFromDBIfDisconnectedAlert {
    __weak FeedController *weakSelf = self;
    BOOL isDisconnected = [self.feedViewModel.isDisconnected boolValue];
    if (isDisconnected) {
        NSString *title = [self.helper getLocalizedString:@"WARNING"];
        NSString *msg = [self.helper getLocalizedString:@"There is no internet connection"];
        // show warning message
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:title
                                            message:msg
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction =
        [UIAlertAction actionWithTitle:[self.helper getLocalizedString:@"Ok"]
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   [weakSelf.feedViewModel fetchAllFeedSortedByAttribute];
                               }];
        [alert addAction:okAction];
        [self presentViewController:alert
                           animated:true
                         completion:nil];
        
    } else {
        // if connection has recovered
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSURL *currentUrl = [userDefaults URLForKey:@"current_url"];
        if (currentUrl) {
            // load feeds by url
            [self.feedViewModel loadFeedsbyURL:currentUrl];
        }
    }
}

- (void)showRequestErrorAlert {
    if ([self.feedViewModel.hasReceivedError boolValue]) {
        __weak FeedController *weakSelf = self;
        NSString *title = [self.helper getLocalizedString:@"REQUEST ERROR"];
        NSString *msg = [self.helper getLocalizedString:@"Something went wrong. Please try again later"];
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:title
                                            message:msg
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction =
        [UIAlertAction actionWithTitle:[self.helper getLocalizedString:@"Ok"]
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   [weakSelf.feedViewModel fetchAllFeedSortedByAttribute];
                               }];
        [alert addAction:okAction];
        [self presentViewController:alert
                           animated:true
                         completion:nil];
    } else {
        return;
    }
}

@end
