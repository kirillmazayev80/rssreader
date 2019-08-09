//
//  BrowserController.m
//  RSSReader
//
//  Created by Kirill Mazaev on 20.12.2018.
//  Copyright © 2018 mazaev. All rights reserved.
//

#import "BrowserController.h"

#import "Helper.h"

@interface BrowserController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityInd;

@end

@implementation BrowserController

# pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUserInterface];
}

# pragma mark - Setup User Interface
// setting up user interface
- (void)setupUserInterface {
    Helper *helper = [Helper sharedInstance];
    self.navigationItem.title = [helper getLocalizedString:@"Browse"];
    [self showNewsInBrowser];
}

// load feed by link url
- (void)showNewsInBrowser {
    if (self.feedUrlStr) {
        NSURL *feedUrl = [NSURL URLWithString:self.feedUrlStr];
        NSURLRequest *webRequest = [NSURLRequest requestWithURL:feedUrl];
        [self.webView loadRequest:webRequest];
    }
}

# pragma mark - UIWebViewDelegate
// perform when feed did start loading
- (void)webViewDidStartLoad:(UIWebView *)webView {
    // start animating activity indicator
    [self.activityInd startAnimating];
}

// perform when feed did finish loading
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // stop animating activity indicator
    [self.activityInd stopAnimating];
}

// perform when feed did fail loading with error
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error web loading: %@", error);
    // stop animating activity indicator
    [self.activityInd stopAnimating];
    // return to DetailsController
    [self.navigationController popViewControllerAnimated:true];
}

@end
