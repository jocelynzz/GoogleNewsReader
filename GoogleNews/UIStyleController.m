//
//  UIStyleController.m
//  GoogleNews
//
//  Created by Jocelyn on 2/21/15.
//  Copyright (c) 2015 Jocelyn. All rights reserved.
//

#import "UIStyleController.h"

@interface UIStyleController ()

@end

@implementation UIStyleController

+(void)applyUIStyle {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    UIColor *lightBlue = [UIColor colorWithRed: 135.0/255.0 green: 206.0/255.0 blue:255.0/255.0 alpha: 1.0];
    [navigationBarAppearance setTranslucent:NO];
    [navigationBarAppearance setTintColor:lightBlue];
    [navigationBarAppearance setBarTintColor:[UIColor lightGrayColor]];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:lightBlue, NSForegroundColorAttributeName,  [UIFont fontWithName:@"Georgia" size:20.0],
                                    NSFontAttributeName,
                                    nil];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    
    UIToolbar *toolBarAppearance =[UIToolbar appearance];
    [toolBarAppearance setBarTintColor:[UIColor lightGrayColor]];
    [toolBarAppearance setTintColor:lightBlue];
    
    UIBarButtonItem *uiBarButtonAppearance = [UIBarButtonItem appearance];
    [uiBarButtonAppearance setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
}
@end
