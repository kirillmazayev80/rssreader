//
//  DetailController+ImageGestures.m
//  RSSReader
//
//  Created by Kirill Mazaev on 07.08.2019.
//  Copyright © 2019 mazaev. All rights reserved.
//

#import "DetailController.h"
#import "DetailController+ImageGestures.h"

// stored image frame before tapping
CGRect firstFrame;
// image height
static const CGFloat IMAGE_HEIGHT = 240.f;
// status bar height
static const CGFloat STATUS_BAR_HEIGHT = 20.f;
// navigation bar height
static const CGFloat NAV_BAR_HEIGHT = 44.f;

@implementation DetailController (ImageGestures)

// setting image tap gesture
- (void)setTapGesture {
    self.isFullScreen = false;
    firstFrame = self.detailImageImg.frame;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(handleTapGesture:)];
    tap.numberOfTapsRequired = 1;
    [self.detailImageImg addGestureRecognizer:tap];
}

// setting image pinch gesture
- (void)setPinchGesture {
    self.pinchGesture = [[UIPinchGestureRecognizer alloc]
                         initWithTarget:self
                         action:@selector(handlePinchGesture:)];
    [self.detailImageImg addGestureRecognizer:self.pinchGesture];
}


# pragma mark - Handle gestures
// handling tap gesture
- (void)handleTapGesture:(UITapGestureRecognizer*) sender {
    __weak DetailController *weakSelf = self;
    // setting image pinch gesture
    [self setPinchGesture];
    if (!self.isFullScreen) {
        // zoom image by tap with animation
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.detailImageImg.frame = [weakSelf getZoomedFrame];
            weakSelf.view.backgroundColor = [UIColor whiteColor];
            weakSelf.detailTitleLbl.alpha = 0;
            weakSelf.detailDescrTxt.alpha = 0;
        }];
        self.isFullScreen = true;
    }
    else {
        // unzoom image by tap with animation
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.detailImageImg.frame = [weakSelf getUnzoomedFrame];
            weakSelf.view.backgroundColor = [UIColor whiteColor];
            weakSelf.detailTitleLbl.alpha = 1;
            weakSelf.detailDescrTxt.alpha = 1;
        }];
        self.isFullScreen = false;
        // remove pinch gesture
        if (self.pinchGesture) {
            [self removePinchGesture];
        }
    }
}

// getting zoomed frame
- (CGRect)getZoomedFrame {
    CGFloat originXZoomed = 0;
    CGFloat originYZoomed = self.view.center.y -
    self.detailImageImg.frame.size.height/2.0 +
    STATUS_BAR_HEIGHT;
    CGFloat zoomedWidth = self.view.frame.size.width;
    CGFloat zoomedHeight = IMAGE_HEIGHT;
    CGRect zoomedFrame = CGRectMake(originXZoomed,
                                    originYZoomed,
                                    zoomedWidth,
                                    zoomedHeight);
    return zoomedFrame;
}

// getting unzoomed frame
- (CGRect)getUnzoomedFrame {
    CGFloat originXUnzoomed = firstFrame.origin.x;
    CGFloat originYUnzoomed = firstFrame.origin.y + NAV_BAR_HEIGHT;
    CGFloat unzoomedWidth = self.view.frame.size.width;
    CGFloat unzoomedHeight = firstFrame.size.height;
    CGRect unzoomedFrame = CGRectMake(originXUnzoomed,
                                      originYUnzoomed,
                                      unzoomedWidth,
                                      unzoomedHeight);
    return unzoomedFrame;
}

// image pinch gesture handling
- (void)handlePinchGesture:(UIPinchGestureRecognizer*) pinchGesture {
    if (pinchGesture.state == UIGestureRecognizerStateBegan) self.currentScale = 1.f;
    CGFloat newScale = 1.f + pinchGesture.scale - self.currentScale;
    CGAffineTransform currentTransform = self.detailImageImg.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, newScale, newScale);
    self.detailImageImg.transform = newTransform;
    self.currentScale = pinchGesture.scale;
}

// removing image pinch gesture
-(void)removePinchGesture{
    for (UIGestureRecognizer *recognizer in self.detailImageImg.gestureRecognizers){
        if ([recognizer isKindOfClass:[UIPinchGestureRecognizer class]]){
            [self.detailImageImg removeGestureRecognizer:recognizer];
        }
    }
}

@end
