//
//  DetailViewController.h
//  GoogleNews
//
//  Created by Jocelyn on 2/13/15.
//  Copyright (c) 2015 Jocelyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkToWebViewDelegate.h"
#import "Social/Social.h"

@interface DetailViewController : UIViewController <BookmarkToWebViewDelegate>

//@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSDictionary *detailItem;
//@property (copy, nonatomic) NSString *url;


@end

