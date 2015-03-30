//
//  BookMarkViewController.h
//  GoogleNews
//
//  Created by Jocelyn Zhang on 2/15/15.
//  Copyright (c) 2015 Jocelyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookMarkViewController : UITableViewController

-(void)addBookMark:(NSDictionary*)bookmark;
-(void)setDelegate:(id)delegate;
@end
