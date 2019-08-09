//
//  ApiManager.h
//  RSSReader
//
//  Created by Kirill Mazaev on 07.08.2019.
//  Copyright © 2019 mazaev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject
- (void)getFeedsWithURL:(NSURL*) url handler:(void (^)(NSArray* _Nullable fetchedFeed, NSError* _Nullable error)) block;
@end

NS_ASSUME_NONNULL_END
