//
//  FeedCell.h
//  RSSReader
//
//  Created by Kirill Mazaev on 19.12.2018.
//  Copyright © 2018 mazaev. All rights reserved.
//

#import "Feed.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedCell : UITableViewCell
- (void)configureCellWith:(Feed *)feed;
@end

NS_ASSUME_NONNULL_END
