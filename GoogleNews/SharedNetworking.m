//
//  SharedNetworking.m
//  GoogleNews
//
//  Created by Jocelyn on 2/13/15.
//  Copyright (c) 2015 Jocelyn. All rights reserved.
//

#import "SharedNetworking.h"
#import <UIKit/UIKit.h>

@implementation SharedNetworking

+ (id)sharedNetworking
{
    static dispatch_once_t pred;
    static SharedNetworking *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init
{
    if ( self = [super init] ) {
        
    }
    return self;
}

#pragma - Requests

- (void)getFeedForURL:(NSString*)url
<<<<<<< HEAD
              success:(void (^)(NSDictionary *dic, NSError *error))successCompletion
              failure:(void (^)(void))failureCompletion
=======
                 success:(void (^)(NSDictionary *dic, NSError *error))successCompletion
                 failure:(void (^)(void))failureCompletion
>>>>>>> b37e938d3f751438909f1ab15b173752e92a54c1
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url]
                                 completionHandler:^(NSData *data,
                                                     NSURLResponse *response,
                                                     NSError *error) {
                                     
                                     // handle response
<<<<<<< HEAD
                                     //                                     NSLog(@"Data:%@",data);
                                     //                                     NSLog(@"Response:%@",response);
                                     //                                     NSLog(@"Error:%@",[error localizedDescription]);
=======
//                                     NSLog(@"Data:%@",data);
//                                     NSLog(@"Response:%@",response);
//                                     NSLog(@"Error:%@",[error localizedDescription]);
>>>>>>> b37e938d3f751438909f1ab15b173752e92a54c1
                                     
                                     NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                     if (httpResp.statusCode == 200) {
                                         NSError *jsonError;
                                         
                                         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
<<<<<<< HEAD
                                         //                                         NSLog(@"DownloadeData:%@ \n--- ",dic);
                                         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             successCompletion(dic,nil);
                                         });
=======
//                                         NSLog(@"DownloadeData:%@ \n--- ",dic);
                                         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                         successCompletion(dic,nil);
>>>>>>> b37e938d3f751438909f1ab15b173752e92a54c1
                                     } else {
                                         NSLog(@"Fail Not 200:");
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             if (failureCompletion) failureCompletion();
                                         });
                                     }
                                 }] resume];
}
@end
