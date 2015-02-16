//
//  MasterViewController.h
//  GoogleNews
//
//  Created by Jocelyn on 2/13/15.
//  Copyright (c) 2015 Jocelyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *topStories;
@end

