//
//  DetailController.m
//  RSSReader
//
//  Created by Kirill Mazaev on 20.12.2018.
//  Copyright © 2018 mazaev. All rights reserved.
//

#import "DetailController.h"
#import "DetailController+ImageGestures.h"
// libraries
#import "UIImageView+AFNetworking.h"
// project files
#import "BrowserController.h"
#import "Helper.h"

// storyboard name
static NSString * const STORYBOARD_NAME = @"Browser";
// controller identifier
static NSString * const CONTROLLER_ID = @"BrowserControllerID";

@implementation DetailController 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUserInterface];
}

# pragma mark - Setup User Interface
- (void)setupUserInterface {
    // setting title
    self.navigationItem.title = [[Helper sharedInstance] getLocalizedString:@"Details"];
    // setting custom right button
    [self setCustomRightBarButtonItem];
    // setting custom back button
    [self setCustomBackBarButtonItem];
    // setting image tap gesture
    [self setTapGesture];
    // setting interface by feed model
    if (self.feed) {
        [self showDetailedFeed];
    }
}

// setting views by feed model
- (void)showDetailedFeed {
    self.detailTitleLbl.text = self.feed.title;
    NSURL *imageUrl = [NSURL URLWithString:self.feed.image_url];
    [self.detailImageImg setImageWithURL:imageUrl];
    self.detailDescrTxt.text = self.feed.summary;
}

// setting custom right navigation bar button
- (void)setCustomRightBarButtonItem {
    // getting image
    UIImage *browseButtonIcon = [UIImage imageNamed:@"browse_icon"];
    // setting button by image
    UIBarButtonItem *browseBtn = [[UIBarButtonItem alloc]
                                  initWithImage:browseButtonIcon
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(browseInWeb)];
    self.navigationItem.rightBarButtonItem = browseBtn;
}

// setting custom back button
- (void)setCustomBackBarButtonItem {
    UIBarButtonItem *backItem = [UIBarButtonItem new];
    backItem.title = @"";
    [self.navigationItem setBackBarButtonItem:backItem];
}

# pragma mark - Segue to BrowserController
// segue into BrowserController
- (void)browseInWeb {
    // initialize browser storyboard
    UIStoryboard *browserStoryboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    // initialize browser controller by controller identifier
    BrowserController *browserVC = [browserStoryboard instantiateViewControllerWithIdentifier:CONTROLLER_ID];
    browserVC.feedUrlStr = self.feed.link_url;
    // push into BrowserController
    UINavigationController *navigationVC = self.navigationController;
    [navigationVC pushViewController:browserVC animated:true];
}

@end
