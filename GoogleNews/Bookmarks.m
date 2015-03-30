//
//  MasterViewController.m
//  GoogleNews
//
//  Created by Jocelyn on 2/22/15.
//  Copyright (c) 2015 Jocelyn. All rights reserved.
//


#import "Bookmarks.h"

@interface Bookmarks()
@property (strong,nonatomic)NSMutableArray *bookmarks;
@end

@implementation Bookmarks


- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.bookmarks forKey:@"bookmarks"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self.bookmarks = [decoder decodeObjectForKey:@"bookmarks"];
    return self;
}

- (NSMutableArray*)getBookmarks {
    return _bookmarks;
}

- (void)initBookmarks {
    _bookmarks = [NSMutableArray array];
}

@end
