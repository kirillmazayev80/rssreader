//
//  FeedController.h
//  RSSReader
//
//  Created by Kirill Mazaev on 19.12.2018.
//  Copyright © 2018 mazaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedViewModel.h"
#import "Helper.h"

@interface FeedController : UITableViewController <UISearchBarDelegate>
@property (strong, nonatomic) Helper *helper;
@property (strong, nonatomic) FeedViewModel *feedViewModel;
@end

