//
//  FeedCell.m
//  RSSReader
//
//  Created by Kirill Mazaev on 19.12.2018.
//  Copyright © 2018 mazaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

#import "FeedCell.h"
#import "Feed.h"

@interface FeedCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@end

@implementation FeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellWith:(Feed *)feed {
    self.titleLbl.text = feed.title;
    if (feed.image_url) {
        // set image url if image url doesn't equal nil
        NSURL *imageURL = [NSURL URLWithString:feed.image_url];
        [self.imageImg setImageWithURL:imageURL];
    } else {
        // set noimage if image url is equal nil
        UIImage* noImage = [UIImage imageNamed:@"noimage"];
        [self.imageImg setImage:noImage];
    }
}

@end
