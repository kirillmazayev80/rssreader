//
//  FeedController.m
//  RSSReader
//
//  Created by Kirill Mazaev on 19.12.2018.
//  Copyright © 2018 mazaev. All rights reserved.
//

#import "FeedController.h"
#import "FeedController+Alerts.h"
#import <UIKit/UIKit.h>
// libraies
#import "FBKVOController.h"
#import <KVOController/NSObject+FBKVOController.h>
// project files
#import "DetailController.h"
#import "Feed.h"
#import "FeedViewModel.h"
#import "FeedCell.h"
#import "Helper.h"

// feed cell identifier
static NSString * const CELL_IDENTIFIER  = @"feed_cell";
// cell height
static const CGFloat CELL_HEIGHT = 150.f;
// storyboard name
static NSString * const STORYBORAD_NAME = @"Detail";
// controller id
static NSString * const CONTROLLER_ID = @"DetailControllerID";

@interface FeedController()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) FBKVOController *kvoController;
@end

@implementation FeedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // get helper instance
    self.helper = [Helper sharedInstance];
    // setting user interface
    [self setupUserInterface];
    // setting kvo controller
    self.kvoController = [FBKVOController controllerWithObserver:self];

    // initializing feed viewmodel
    self.feedViewModel = [FeedViewModel new];
    // initializing feeds array
    self.feedViewModel.feedsArray = [NSMutableArray new];
    // initializing internet connection flag
    self.feedViewModel.isDisconnected = [NSNumber numberWithBool:true];
    
    // setting observes
    [self setupObservers];
}


# pragma mark - Setup User Interface
- (void)setupUserInterface {
    // getting offset for hiding search bar
    CGFloat originX = 0;
    CGFloat originY = 44;
    self.tableView.contentOffset = CGPointMake(originX, originY);
    // setting right button in navigation bar
    [self setCustomRightBarButtonItem];
    // setting back button in navigation bar
    [self setCustomBackBarButtonItem];
}

// setting custom right button
- (void)setCustomRightBarButtonItem {
    // get button image
    UIImage *browseButtonIcon = [UIImage imageNamed:@"settings_icon"];
    // set button with image
    UIBarButtonItem *browseBtn = [[UIBarButtonItem alloc]
                                  initWithImage:browseButtonIcon
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(changeRssChannelAlert)];
    self.navigationItem.rightBarButtonItem = browseBtn;
}

// setting custom back button
- (void)setCustomBackBarButtonItem {
    UIBarButtonItem *backItem = [UIBarButtonItem new];
    backItem.title = @"";
    [self.navigationItem setBackBarButtonItem:backItem];
}

// setting up observers
- (void)setupObservers {
    // setting up observer on channel title property
    [self.kvoController observe:self.feedViewModel
                        keyPath:@"channelTitle"
                        options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
                         action:@selector(setTitle)];
    // setting up observer on feeds array property
    [self.kvoController observe:self.feedViewModel
                        keyPath:@"feedsArray"
                        options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
                         action:@selector(reloadTableview)];
    // setting up observer on internet connection property
    [self.kvoController observe:self.feedViewModel
                        keyPath:@"isDisconnected"
                        options:NSKeyValueObservingOptionNew
                         action:@selector(fetchFromDBIfDisconnectedAlert)];
    // setting up observer on has received error
    [self.kvoController observe:self.feedViewModel
                        keyPath:@"hasReceivedError"
                        options:NSKeyValueObservingOptionNew
                         action:@selector(showRequestErrorAlert)];
}

// tableview reloading
- (void)reloadTableview {
    [self.tableView reloadData];
}

// setting title
- (void)setTitle {
    self.navigationItem.title = self.feedViewModel.channelTitle;
}

# pragma mark - UITableViewDataSource
// get number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedViewModel.feedsArray.count;
}

// setting tableview cell by feed model
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER
                                                          forIndexPath:indexPath];
    Feed *feed = self.feedViewModel.feedsArray[indexPath.row];
    [cell configureCellWith:feed];
    return cell;
}


# pragma mark - UITableViewDelegate
// getting custom cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

#pragma mark - UISearchBarDelegate
// perform if text in search bar did changed
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([self.searchBar.text length] > 0) {
        [self doSearch];
    } else {
        [self.feedViewModel fetchAllFeedSortedByAttribute];
    }
}

// perform if cancel button has clicked
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    self.searchBar.showsCancelButton = false;
    [self.feedViewModel fetchAllFeedSortedByAttribute];
}

// perform if text begin editing
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = true;
}

// perform if search button has clicked
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self doSearch];
}

// search feeds by prefix of title
- (void)doSearch {
    NSString *searchText = self.searchBar.text;
    [self.feedViewModel searchFeedByTitlePrefix:searchText];
}

# pragma mark - Segue to DetailController
// segue to DetailController by cell taping
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // deselect row
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
    // initialize storyborad with name
    UIStoryboard *detailStoryboard = [UIStoryboard storyboardWithName:STORYBORAD_NAME bundle:nil];
    // instantiate DetailController by controller identifier
    DetailController *detailVC = [detailStoryboard instantiateViewControllerWithIdentifier:CONTROLLER_ID];
    detailVC.feed = self.feedViewModel.feedsArray[indexPath.row];
    // push to DetailController
    UINavigationController *navigationVC = self.navigationController;
    [navigationVC pushViewController:detailVC animated:true];
}

# pragma mark - Deallocation
- (void)dealloc {
    // unobserve all observers
    [self.kvoController unobserveAll];
}

@end
