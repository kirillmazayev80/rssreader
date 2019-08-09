//
//  Feed+CoreDataProperties.h
//  
//
//  Created by Kirill Mazaev on 21.12.2018.
//
//

#import "Feed.h"

NS_ASSUME_NONNULL_BEGIN

@interface Feed (CoreDataProperties)

+ (NSFetchRequest<Feed *> *)fetchRequest;

// image url
@property (nullable, nonatomic, copy) NSString *image_url;
// feeds url in web
@property (nullable, nonatomic, copy) NSString *link_url;
// date of publishing
@property (nullable, nonatomic, copy) NSDate *publication_date;
// brief summary (description)
@property (nullable, nonatomic, copy) NSString *summary;
// feed's title
@property (nullable, nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
