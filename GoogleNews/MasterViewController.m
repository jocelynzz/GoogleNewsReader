//
//  MasterViewController.m
//  GoogleNews
//
//  Created by Jocelyn on 2/13/15.
//  Copyright (c) 2015 Jocelyn. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SplashScreenViewController.h"
#import "SharedNetworking.h"
#import "MasterCell.h"
static NSString * const MasterCellIdentifier = @"MasterCell";

@interface MasterViewController () {
NSArray *topStories;
NSMutableDictionary *link;
NSMutableString *title;

}
@property NSMutableArray *objects;
@property (strong,nonatomic) NSMutableArray *issueData;
@property(nonatomic) BOOL currentMode;
@end

@implementation MasterViewController


- (void)awakeFromNib {
    [super awakeFromNib];
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self downloadStories];
    
    [self adjustMode];
    //  refresh control
    UIRefreshControl *pullToRefresh = [[UIRefreshControl alloc] init];
    pullToRefresh.tintColor = [UIColor blueColor];
    [pullToRefresh addTarget:self action:@selector(refreshAction) forControlEvents: UIControlEventValueChanged];
    self.refreshControl = pullToRefresh;
    topStories = [topStories init];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIContentSizeCategoryDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self.tableView reloadData];
    }];
    
    NSLog(@"loadmasterview");
}


-(void)downloadStories {
    
    SharedNetworking *singleton = [SharedNetworking sharedNetworking];
    [singleton getFeedForURL:@"http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=8&q=http%3A%2F%2Fnews.google.com%2Fnews%3Foutput%3Drss"
                     success:^(NSDictionary *dic, NSError *error) {
                         topStories =[[[dic objectForKey:@"responseData"] objectForKey:@"feed"] objectForKey:@"entries"];
                         
                         _viewDownloaded = YES;
                         NSNumber *state = [NSNumber numberWithBool:_viewDownloaded];
                         
                         //send topStories to detail view application
                         [[NSNotificationCenter defaultCenter]
                          postNotificationName:@"downloadFinished" object:state];
                         NSLog(@"post downloadFinished");
                         
                         //send notificatino to splash screen
                         [[NSNotificationCenter defaultCenter]
                          postNotificationName:@"firstNews" object:nil userInfo:[topStories objectAtIndex:0]];
                         
                         //reload data instead of setNeedsplay, which is for init
                         [self.tableView reloadData];
                     }
                     failure:^(){
                         [self showAlert];
                         return;
                     }];
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
}

- (BOOL)readerMode {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _currentMode = [defaults boolForKey:@"night_mode_preference"];
    NSLog(@"current mode is: %d", _currentMode);
    return _currentMode;
    
}

-(void)adjustMode {
    [self readerMode];
    if (_currentMode == YES) {
        [self.tableView setBackgroundColor:[UIColor blackColor]];
    }
}


- (void)refreshAction {
    NSLog(@"Pull to refresh action");
    [self downloadStories];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *story = [topStories objectAtIndex:indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:story];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return topStories.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self basicCellAtIndexPath:indexPath];
}

- (MasterCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath {
    MasterCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MasterCellIdentifier forIndexPath:indexPath];
    [self configureBasicCell:cell atIndexPath:indexPath];
        [self readerMode];
    
        if (_currentMode == 1) {
            cell.titleLabel.textColor = [UIColor whiteColor];
            cell.subtitleLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor blackColor];
        }
        else {
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.backgroundColor = [UIColor whiteColor];
        }
    return cell;
}

- (void)configureBasicCell:(MasterCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* currDetails = [topStories objectAtIndex:indexPath.row];
    [self setTitleForCell:cell item :currDetails];
    [self setSubtitleForCell:cell item :currDetails];
}

- (void)setTitleForCell:(MasterCell *)cell item:(NSDictionary *)details {
    
    NSString *story = [details objectForKey:@"title"];
    cell.titleLabel.text = story;
   // [self setTitleForCell:cell item:item];
    NSLog(@"title is %@", story);
    [cell.titleLabel setText:story];
    NSString *text =cell.titleLabel.text;
    NSLog(@"text is %@", text);
    cell.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSubtitleForCell:(MasterCell *)cell item:(NSDictionary *)details {
    
    NSString *detail = [details objectForKey:@"contentSnippet"];
    
    NSString *pDate = [details objectForKey:@"publishedDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE,dd MMM yyyy HH:mm:ss ZZZ"];
    NSDate *date  = [dateFormatter dateFromString:pDate];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDate = [dateFormatter stringFromDate:date];
    
    NSString *subtitles =  [NSString stringWithFormat:@"%@  %@", newDate, detail];
    
    if (subtitles.length > 200) {
        subtitles = [NSString stringWithFormat:@"%@...", [subtitles substringToIndex:200]];
    }
    NSLog(@"subtitile is %@", subtitles);
    
    cell.subtitleLabel.text = subtitles;
    cell.subtitleLabel.adjustsFontSizeToFitWidth = YES;
    cell.subtitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static MasterCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:MasterCellIdentifier];
    });
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell{
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds));

    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                    message:@"Failed To Connect"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

}


@end
