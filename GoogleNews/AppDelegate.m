//
//  AppDelegate.m
//  GoogleNews
//
//  Created by Jocelyn on 2/13/15.
//  Copyright (c) 2015 Jocelyn. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MasterViewController.h"
#import "UIStyleController.h"
#import "SplashScreenViewController.h"

@interface AppDelegate () <UISplitViewControllerDelegate>
@property (weak, nonatomic) SplashScreenViewController *splashScreen;
@property (strong, nonatomic) UIView *splash;
@end

@implementation AppDelegate

- (void)awakeFromNib {
    [super awakeFromNib];

    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //initialize values
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(! [defaults objectForKey:@"night_mode_preference"])
        [defaults setBool:NO forKey:@"night_mode_preference"];
    [defaults synchronize];
  
    BOOL cMode=[defaults boolForKey:@"night_mode_preference"];
    NSLog(@"currentmode: %d",cMode);
    
    [UIStyleController applyUIStyle];
    
    //create a splash screen
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [_window makeKeyAndVisible];
    [_window addSubview:_splashScreen.view];
    _splashScreen = [mainstoryboard instantiateViewControllerWithIdentifier:@"SplashScreenViewController"];
    _splash = [_splashScreen view];
    _splashScreen.delegate = self;
    _masterDownloaded = NO;
    
//   // finish downloading
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self selector:@selector(downloadFinished:) name:@"downloadFinished" object:nil];
    [self hideSplash];

    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    return YES;
}

- (void)downloadFinished: (NSNotification *) notification {
    NSNumber *download = [notification object];
    NSNumber *num = [NSNumber numberWithInt:1];
    NSLog(@"download state: %@", download);
    if ([notification.object isKindOfClass:[NSNumber class]]
        && download.intValue == num.intValue) {
        _masterDownloaded = YES;
        NSLog(@"hidesplash");
        [self hideSplash];
        NSNumber *currentState =  [NSNumber numberWithBool:_masterDownloaded];
        NSLog(@"downloadFinished master: %@", currentState);
    }
}

-(void)hideSplash {
    if (_masterDownloaded == YES) {
        [UIView animateWithDuration: 5.0
                              delay: 0.5
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations: ^{
                             _splash.alpha = 0;
                             NSLog(@"hiding starts");
                             [self.window setNeedsDisplay];
                         }
                         completion:^(BOOL finished) {
                             _splash.hidden = YES;
                             [_splash removeFromSuperview];
                             NSLog(@"hiding completed");
                             [self.window setNeedsDisplay];
                             
                         }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

@end
