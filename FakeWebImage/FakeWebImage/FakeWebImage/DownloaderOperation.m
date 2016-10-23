//
//  DownloaderOperation.m
//  FakeWebImage
//
//  Created by 王靖凯 on 2016/10/23.
//  Copyright © 2016年 王靖凯. All rights reserved.
//

#import "DownloaderOperation.h"

@implementation DownloaderOperation

/**
 override this method to concurrent download image
 */
- (void)main{
    if (self.urlString) {
        NSURL* url = [NSURL URLWithString:self.urlString];
        NSData* date = [NSData dataWithContentsOfURL:url];
        UIImage* image = [UIImage imageWithData:date];
        NSLog(@"%@",[NSThread currentThread]);
        if (self.sucessBlock) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                _sucessBlock(image);
                NSLog(@"%@",[NSThread currentThread]);
            }];
        }

    }
}

@end
