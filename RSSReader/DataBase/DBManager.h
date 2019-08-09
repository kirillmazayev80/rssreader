//
//  DBManager.h
//  RSSReader
//
//  Created by Kirill Mazaev on 07.08.2019.
//  Copyright © 2019 mazaev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject
- (void)save:(NSArray *) feed withHandler:(void (^)(BOOL didSave, NSError* _Nullable error)) block;
- (NSArray*)fetchAllSortedFeed;
@end

NS_ASSUME_NONNULL_END
