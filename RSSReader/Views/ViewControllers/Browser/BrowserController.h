//
//  BrowserController.h
//  RSSReader
//
//  Created by Kirill Mazaev on 20.12.2018.
//  Copyright © 2018 mazaev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BrowserController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSString *feedUrlStr;

@end

NS_ASSUME_NONNULL_END
