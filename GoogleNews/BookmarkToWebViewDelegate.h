//
//  BookmarkToWebViewDelegate.h
//  GoogleNews
//
//  Created by Jocelyn Zhang on 2/15/15.
//  Copyright (c) 2015 Jocelyn. All rights reserved.
//

#ifndef GoogleNews_BookmarkToWebViewDelegate_h
#define GoogleNews_BookmarkToWebViewDelegate_h

@protocol BookmarkToWebViewDelegate <NSObject>
@required
- (void)bookmark:(id)sender sendsURL:(NSURL*)url;
@end

#endif
