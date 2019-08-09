//
//  DetailController.h
//  RSSReader
//
//  Created by Kirill Mazaev on 20.12.2018.
//  Copyright © 2018 mazaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *detailImageImg;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLbl;
@property (weak, nonatomic) IBOutlet UITextView *detailDescrTxt;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinchGesture;
@property (assign, nonatomic) CGFloat currentScale;
@property (assign, nonatomic) BOOL isFullScreen;
@property (strong, nonatomic) Feed *feed;

@end

NS_ASSUME_NONNULL_END
