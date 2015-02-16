//
//  MasterViewController.m
//  GoogleNews
//
//  Created by Jocelyn on 2/13/15.
//  Copyright (c) 2015 Jocelyn. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SharedNetworking.h"

@interface MasterViewController () {
NSArray *topStories;
NSMutableDictionary *link;
NSMutableString *title;

}
@property NSMutableArray *objects;
@property (strong,nonatomic) NSMutableArray *issueData;
@end

@implementation MasterViewController


- (void)awakeFromNib {
    [super awakeFromNib];
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"download starts");
    [self downloadStories];
    
}

-(void)downloadStories {
    
    SharedNetworking *singleton = [SharedNetworking sharedNetworking];
    [singleton getFeedForURL:@"http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=8&q=http%3A%2F%2Fnews.google.com%2Fnews%3Foutput%3Drss"
                     success:^(NSDictionary *dic, NSError *error) {
                         topStories =[[[dic objectForKey:@"responseData"] objectForKey:@"feed"] objectForKey:@"entries"];
                         
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



- (void)viewDidLoad {
    [super viewDidLoad];
  //  refresh control
    UIRefreshControl *pullToRefresh = [[UIRefreshControl alloc] init];
    pullToRefresh.tintColor = [UIColor blueColor];
    [pullToRefresh addTarget:self action:@selector(refreshAction) forControlEvents: UIControlEventValueChanged];
    self.refreshControl = pullToRefresh;
    topStories = [topStories init];

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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSLog(@"%@", [topStories objectAtIndex:indexPath.row]);
    NSString *story = [[topStories objectAtIndex:indexPath.row] objectForKey:@"title"];
    NSString *detail = [[topStories objectAtIndex:indexPath.row] objectForKey:@"contentSnippet"];
    NSString *pDate = [[topStories objectAtIndex:indexPath.row] objectForKey:@"publishedDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE,dd MMM yyyy HH:mm:ss ZZZ"];
    NSDate *date  = [dateFormatter dateFromString:pDate];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDate = [dateFormatter stringFromDate:date];
    cell.textLabel.text = story;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@", newDate, detail];
    return cell;
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
