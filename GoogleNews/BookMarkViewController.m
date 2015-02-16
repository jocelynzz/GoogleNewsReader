//
//  BookMarkViewController.m
//  GoogleNews
//
<<<<<<< HEAD
//  Created by Jocelyn Zhang on 2/15/15.
=======
//  Created by Jocelyn on 2/15/15.
>>>>>>> b37e938d3f751438909f1ab15b173752e92a54c1
//  Copyright (c) 2015 Jocelyn. All rights reserved.
//

#import "BookMarkViewController.h"
#import "BookmarkToWebViewDelegate.h"

<<<<<<< HEAD
=======
//swipe left to edit/delete favs

>>>>>>> b37e938d3f751438909f1ab15b173752e92a54c1
@interface BookMarkViewController ()
@property (strong,nonatomic)NSMutableArray *bookmarks;
@property (weak) id <BookmarkToWebViewDelegate> dataReceiver;
@end

@implementation BookMarkViewController

- (void)addBookMark:(NSDictionary *)bookmark {
    [self loadBookmarks];
    [_bookmarks addObject:bookmark];
    [self saveBookmarks];
    [self.tableView setNeedsDisplay];
}

- (void)loadBookmarks {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _bookmarks = [defaults objectForKey:@"bookmarks"];
    if (_bookmarks == nil) {
        _bookmarks = [NSMutableArray array];
    }
}

- (void)saveBookmarks {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_bookmarks forKey:@"bookmarks"];
    [defaults synchronize];
}

- (void)setDelegate:(id)delegate {
    _dataReceiver = delegate;
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadBookmarks];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
<<<<<<< HEAD
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
=======
>>>>>>> b37e938d3f751438909f1ab15b173752e92a54c1
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
<<<<<<< HEAD
    // Dispose of any resources that can be recreated.
=======
>>>>>>> b37e938d3f751438909f1ab15b173752e92a54c1
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
<<<<<<< HEAD

    // Return the number of sections.
=======
>>>>>>> b37e938d3f751438909f1ab15b173752e92a54c1
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
<<<<<<< HEAD

    // Return the number of rows in the section.
=======
>>>>>>> b37e938d3f751438909f1ab15b173752e92a54c1
    return [_bookmarks count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestBookMarkCell" forIndexPath:indexPath];
    [[cell textLabel] setText:[[_bookmarks objectAtIndex:indexPath.row] objectForKey:@"title"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *url = [[_bookmarks objectAtIndex:indexPath.row] objectForKey:@"link"];
    [_dataReceiver bookmark:self sendsURL:[NSURL URLWithString:url]];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_bookmarks removeObjectAtIndex:indexPath.row];
        [self saveBookmarks];
        [tableView reloadData];
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
