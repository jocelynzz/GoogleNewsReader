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
#import "SplashScreenViewController.h"

@interface DetailViewController : UIViewController <BookmarkToWebViewDelegate, UIWebViewDelegate,UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSDictionary *detailItem;
@property (weak, nonatomic) IBOutlet UIImageView *star;
//@property (weak, nonatomic) SplashScreenViewController *splashScreen;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorObject;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (strong, nonatomic) UIView *UIView;
@property(nonatomic) BOOL masterDownloaded;
@end

