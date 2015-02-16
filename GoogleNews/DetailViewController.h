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
<<<<<<< HEAD

//@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSDictionary *detailItem;
//@property (copy, nonatomic) NSString *url;

=======

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSDictionary *detailItem;
@property(strong, nonatomic) NSArray *topNews;
>>>>>>> b37e938d3f751438909f1ab15b173752e92a54c1

@end

