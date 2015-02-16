//
//  DetailViewController.m
//  GoogleNews
//
//  Created by Jocelyn on 2/13/15.
//  Copyright (c) 2015 Jocelyn. All rights reserved.
//

#import "DetailViewController.h"
#import "BookmarkToWebViewDelegate.h"
#import "BookMarkViewController.h"
#import "MasterViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *bookMark;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fav;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(NSDictionary *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        [self configureView];
    }
}

- (void)configureView {
    if (self.detailItem) {
        NSURL *url = [NSURL URLWithString:self.detailItem[@"link"]];
        [self.webView loadRequest:[NSURLRequest requestWithURL: url]];
    }
}


- (IBAction)favPressed:(id)sender {
    [self performSegueWithIdentifier:@"MySeg" sender:_fav];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  //  [self loadFirstNews];
    [_fav setAction:@selector(favPressed:)];
    [self configureView];
}

//- (void)loadFirstNews {
//    NSLog(@"loadFirstNews");
//    NSURL *firstStory = [[_topNews objectAtIndex:0] objectForKey:@"link"];
//    NSLog( @"url is %@", [firstStory absoluteString]);
//    [self.webView loadRequest:[NSURLRequest requestWithURL:firstStory]];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)bookmark:(id)sender sendsURL:(NSURL *)url {
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender == self.bookMark){
        NSLog(@"bookmark");
        BookMarkViewController *controller = (BookMarkViewController *)[segue destinationViewController];
        [controller setDelegate:self];
    } else if (sender == self.fav) {
        NSLog(@"favourite");
        if (_detailItem) {
            BookMarkViewController *controller = (BookMarkViewController *)[segue destinationViewController];
            [controller setDelegate:self];
            [controller addBookMark:_detailItem];
            
        }
    }
}

- (IBAction)sendTweet:(UIBarButtonItem *)sender {
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    NSString *title = self.detailItem[@"title"];
    NSString *url = self.detailItem[@"link"];
    NSString *tweetContent = [NSString stringWithFormat:@"%@: %@", title, url];
    [tweetSheet setInitialText:tweetContent];
    [self presentViewController:tweetSheet animated:YES completion:nil];
}

@end
