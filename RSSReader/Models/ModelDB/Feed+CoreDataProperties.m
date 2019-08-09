//
//  Feed+CoreDataProperties.m
//  
//
//  Created by Kirill Mazaev on 21.12.2018.
//
//

#import "Feed+CoreDataProperties.h"

@implementation Feed (CoreDataProperties)

+ (NSFetchRequest<Feed *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Feed"];
}

@dynamic image_url;
@dynamic link_url;
@dynamic publication_date;
@dynamic summary;
@dynamic title;

@end
