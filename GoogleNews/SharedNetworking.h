//
//  SharedNetworking.h
//  GoogleNews
//
//  Created by Jocelyn on 2/13/15.
//  Copyright (c) 2015 Jocelyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedNetworking : NSObject
+(id)sharedNetworking;
- (void)getFeedForURL:(NSString*)url
                 success:(void (^)(NSDictionary *dic, NSError *error))successCompletion
                 failure:(void (^)(void))failureCompletion;

@end

