//
//  Helper.h
//  RSSReader
//
//  Created by Kirill Mazaev on 22.12.2018.
//  Copyright © 2018 mazaev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Helper : NSObject

+ (id)sharedInstance;
- (NSURL *)getWashPostUrl;
- (NSURL *)getDailyMirrorUrl;
- (NSString *)getLocalizedString:(NSString *) key;
    
@end

NS_ASSUME_NONNULL_END
