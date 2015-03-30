//
//  BookMarkViewController.m
//  GoogleNews
//
//  Created by Jocelyn Zhang on 2/15/15.
//  Copyright (c) 2015 Jocelyn. All rights reserved.
//

#import "BookMarkViewController.h"
#import "BookmarkToWebViewDelegate.h"
#import "Bookmarks.h"

@interface BookMarkViewController ()
@property (strong,nonatomic) Bookmarks *bookmarks;
@property (weak) id <BookmarkToWebViewDelegate> dataReceiver;
@end

@implementation BookMarkViewController

- (void)awakeFromNib
{
    self.preferredContentSize = CGSizeMake(500.0, 500.0);
    [super awakeFromNib];
}

- (void)addBookMark:(NSDictionary *)bookmark {
    [self loadBookmarks];
    [[_bookmarks getBookmarks] addObject:bookmark];
    [self saveBookmarks];
    [self.tableView setNeedsDisplay];
}

- (void)loadBookmarks {
    NSError* err = nil;
    NSURL *docs = [[NSFileManager new] URLForDirectory:NSDocumentDirectory
                                              inDomain:NSUserDomainMask appropriateForURL:nil
                                                create:YES error:&err];
    NSURL* file = [docs URLByAppendingPathComponent:@"bookmarks2.plist"];
    NSData* data = [[NSData alloc] initWithContentsOfURL:file];
    _bookmarks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (_bookmarks == nil) {
        _bookmarks = [Bookmarks alloc];
        [_bookmarks initBookmarks];
    }
}

- (void)saveBookmarks {
    NSError* err = nil;
    NSURL *docs = [[NSFileManager new] URLForDirectory:NSDocumentDirectory
                   inDomain:NSUserDomainMask appropriateForURL:nil
                                                create:YES error:&err];
    NSData* bookmarkData = [NSKeyedArchiver archivedDataWithRootObject:_bookmarks];
    NSURL* file = [docs URLByAppendingPathComponent:@"bookmarks2.plist"];
    [bookmarkData writeToURL:file atomically:NO];
    NSLog(@"DOCS:%@",file);
}

- (void)setDelegate:(id)delegate {
    _dataReceiver = delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBookmarks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[_bookmarks getBookmarks] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestBookMarkCell" forIndexPath:indexPath];
    [[cell textLabel] setText:[[[_bookmarks getBookmarks] objectAtIndex:indexPath.row] objectForKey:@"title"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *urlDict = [[_bookmarks getBookmarks] objectAtIndex:indexPath.row];
    [_dataReceiver bookmark:self sendsURL:urlDict];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[_bookmarks getBookmarks] removeObjectAtIndex:indexPath.row];
        [self saveBookmarks];
        [tableView reloadData];
    }   
}

@end
