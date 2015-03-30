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
#import "SplashScreenViewController.h"
#import "Bookmarks.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *bookMark;
@property(nonatomic) BOOL currentMode;
@property (strong, nonatomic) NSDictionary *lastVisited;
@property (strong,nonatomic)NSMutableArray *visited;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fav;
@property (strong, nonatomic) NSString *currURL;
@property (strong, nonatomic) NSString *currTitle;
@property (nonatomic) NSInteger *loads;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(NSDictionary *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        [self configureView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(downloadFinished:) name:@"downloadFinished" object:nil];
    NSNumber *currentState =  [NSNumber numberWithBool:_masterDownloaded];
    NSLog(@"before notification: %@", currentState);

    
}

-(void) firstNews:(NSNotification *) notification {
    NSString *URL =[[notification userInfo] objectForKey:@"link"];
    NSURL *uRL = [[NSURL alloc] initWithString:URL];
    _currURL = URL;
    _currTitle = [[notification userInfo] objectForKey:@"link"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:uRL]];
}

- (void)configureView {
    if (self.detailItem) {
        NSURL *url = [NSURL URLWithString:self.detailItem[@"link"]];
        [self.webView loadRequest:[NSURLRequest requestWithURL: url]];
        [self addVisited: self.detailItem];

    }
}

- (void)addVisited:(NSDictionary *)WebPage {
    [self loadVisited];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *visitedCopy= [[NSMutableArray alloc]initWithArray:_visited];
    [visitedCopy addObject:WebPage];
    [defaults setObject:visitedCopy forKey:@"visited"];
    [defaults synchronize];
    NSLog(@"add webpage: %@", WebPage);
    [self.webView setNeedsDisplay];
}

- (void)loadVisited {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _visited = [defaults objectForKey:@"visited"];
    NSLog(@"Count %lu",(unsigned long)[_visited count]);
    if (_visited == nil) {
        _visited = [NSMutableArray array];
    }
}


-(NSDictionary*)findLastVisited {
    NSLog(@"findlastlisted");
    [self loadVisited];
    if (_visited != nil &&[_visited count] != 0) {
        NSUInteger size = [_visited count];
        NSUInteger index = size-1;
        NSLog(@"visited list %@", _visited);
        _lastVisited = [_visited objectAtIndex:index];
    }
    NSLog(@"last visited detail: %@", _lastVisited);
    return _lastVisited;
}

- (IBAction)favPressed:(id)sender {
    [self performSegueWithIdentifier:@"MySeg" sender:_fav];
}


-(BOOL)isFav//:(NSDictionary *currDict)
{
    BOOL isFav = NO;
    NSString *currentPage;
    NSError* err = nil;
    NSURL *docs = [[NSFileManager new] URLForDirectory:NSDocumentDirectory
                                              inDomain:NSUserDomainMask appropriateForURL:nil
                                                create:YES error:&err];
    NSURL* file = [docs URLByAppendingPathComponent:@"bookmarks2.plist"];
    NSData* data = [[NSData alloc] initWithContentsOfURL:file];
    Bookmarks *bookmarks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (bookmarks == nil) {
        bookmarks = [Bookmarks alloc];
        [bookmarks initBookmarks];
    }
    NSArray *favList = [bookmarks getBookmarks];
    if (_detailItem != nil) {
        currentPage = self.detailItem[@"link"];
    }
    else {
        currentPage = _currURL;
    }
    NSLog(@"currentPage:%@",currentPage);
    NSUInteger size = [favList count];
    for (int i = 0; i < size; i++) {
        NSString *url = [[favList objectAtIndex:i] objectForKey:@"link"];
        NSLog(@"favList:%@",favList);
        if ([url isEqualToString:currentPage]) {
            NSLog(@"this is article is starred");
            isFav = YES;
        }
    }
    return isFav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadVisited];
    _webView.delegate = self;

    _star.hidden = YES;
    NSLog(@"detail item %@", _detailItem);
    if ((_visited == nil|| [_visited count] == 0)&&_detailItem == nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstNews:) name:@"firstNews" object:nil];
    }
    else {
        NSLog(@"initial detail item: %@", _detailItem);
        NSString *lastPage = [[self findLastVisited] objectForKey:@"link"];
        NSURL *url = [[NSURL alloc] initWithString:lastPage];
        NSLog(@"last visited: %@", url);
        _currURL = lastPage;
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        NSString *lastTitle = [[self findLastVisited] objectForKey:@"title"];
        _currTitle = lastTitle;
    }
    [_fav setAction:@selector(favPressed:)];
    [self configureView];
    if ([self isFav]) {
        NSLog(@"show the star");
        _star.hidden = NO;
    }
}

-(void)initUIView {
    _UIView=[[UIView alloc]init];
    [_UIView setBackgroundColor:[UIColor grayColor]];
    [_UIView setTranslatesAutoresizingMaskIntoConstraints:NO];
    _UIView.alpha = 0.5;
    [self.view addSubview:_UIView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_UIView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:0.5
                                                           constant:0]];
    
    // Height constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_UIView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.5
                                                           constant:0]];
    
    // Center horizontally
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_UIView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    // Center vertically
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_UIView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    
    _activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    [_UIView addSubview:_loadingLabel];
    [_UIView addSubview:_activityIndicatorObject];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    CGFloat width=_UIView.bounds.size.width;
    CGFloat height = _UIView.bounds.size.height;
    _activityIndicatorObject.center = CGPointMake(width/2, height/2);
    NSLog(@"widthofuiview %f", width);
    NSLog(@"heightofuiview %f", height);
    
    
    _loadingLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, height/2+15, width, height/10)];
    NSString *LoadingText = @"Loading...";
    _loadingLabel.text = LoadingText;
    _loadingLabel.textAlignment = NSTextAlignmentCenter;
    _loadingLabel.textColor = [UIColor blackColor];
    
    [_activityIndicatorObject startAnimating];
    if (_loads == 0) {
        [self initUIView];
    }
    _loads++;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    _loads--;
    if (_loads == 0) {
        [_activityIndicatorObject stopAnimating];
        _UIView.hidden = YES;
        [_UIView removeFromSuperview];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    _loads--;
    if (_loads == 0) {
        [_activityIndicatorObject stopAnimating];
        _UIView.hidden = YES;
       [_UIView removeFromSuperview];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)bookmark:(id)sender sendsURL:(NSDictionary *)urlDict {
    NSString *myURL = [urlDict objectForKey:@"link"];
    NSURL *url = [NSURL URLWithString:myURL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self addVisited:urlDict];
    _detailItem = urlDict;
    NSLog(@"urlDict %@", _detailItem);
    _star.hidden = NO;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender == self.bookMark){
        NSLog(@"bookmark");
        BookMarkViewController *controller = (BookMarkViewController *)[segue destinationViewController];
        [controller popoverPresentationController].delegate = self;
        [controller setDelegate:self];
    }
    else if (sender == self.fav) {
        NSLog(@"favourite");
        if (_detailItem) {
            BookMarkViewController *controller = (BookMarkViewController *)[segue destinationViewController];
            [controller popoverPresentationController].delegate = self;
            [controller setDelegate:self];
            [controller addBookMark:_detailItem];
            _star.hidden = NO;
        }
        else {
            NSDictionary *lastVisited = [self findLastVisited];
            BookMarkViewController *controller = (BookMarkViewController *)[segue destinationViewController];
            [controller popoverPresentationController].delegate = self;
            [controller setDelegate:self];
            [controller addBookMark:lastVisited];
            _star.hidden = NO;
        }
    }
}

- (IBAction)sendTweet:(UIBarButtonItem *)sender {
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    if (_detailItem != nil) {
        _currURL = self.detailItem[@"link"];
        _currTitle = self.detailItem[@"title"];
    }
    NSLog(@"tweet %@", _currURL);
    NSString *tweetContent = [NSString stringWithFormat:@"%@: %@", _currTitle, _currURL];
    [tweetSheet setInitialText:tweetContent];
    [self presentViewController:tweetSheet animated:YES completion:nil];
}

- (void)downloadFinished: (NSNotification *) notification {
    NSNumber *download = [notification object];
    NSNumber *num = [NSNumber numberWithInt:1];
    NSLog(@"download state: %@", download);
    if ([notification.object isKindOfClass:[NSNumber class]]
        && download.intValue == num.intValue) {
        _masterDownloaded = YES;
        NSLog(@"hidesplash");
        NSNumber *currentState =  [NSNumber numberWithBool:_masterDownloaded];
        NSLog(@"downloadFinished master: %@", currentState);
    }
}


//-(void)hideSplash {
//        [UIView animateWithDuration: 5.0
//                              delay: 0.5
//                            options:UIViewAnimationOptionTransitionCrossDissolve
//                         animations: ^{
//                             self.splashScreen.view.alpha = 0;
//                             NSLog(@"hiding starts");
//                         }
//                         completion:^(BOOL finished) {
//                             self.splashScreen.view.hidden = YES;
//                             [self.splashScreen.view removeFromSuperview];
//                             NSLog(@"hiding completed");
//                             
//                         }];
//    }



-(UIModalPresentationStyle) adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

@end
