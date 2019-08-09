//
//  FeedController+Alerts.h
//  RSSReader
//
//  Created by Kirill Mazaev on 08.08.2019.
//  Copyright © 2019 mazaev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedController(Alerts)
- (void)changeRssChannelAlert;
- (void)fetchFromDBIfDisconnectedAlert;
- (void)showRequestErrorAlert;
@end

NS_ASSUME_NONNULL_END
