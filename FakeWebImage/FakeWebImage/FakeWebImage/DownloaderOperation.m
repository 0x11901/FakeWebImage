//
//  DownloaderOperation.m
//  FakeWebImage
//
//  Created by 王靖凯 on 2016/10/23.
//  Copyright © 2016年 王靖凯. All rights reserved.
//

#import "DownloaderOperation.h"

@interface DownloaderOperation ()
@property(nonatomic,copy) NSString* urlString;//the imageURL string
@property(nonatomic,copy) void(^sucessBlock)(UIImage *);//call-bake image by block;
@end

@implementation DownloaderOperation

+ (instancetype)donwloadImageWithURL:(NSString *)urlString successBlock:(void (^)(UIImage *))successBlock{
    DownloaderOperation* op = [DownloaderOperation new];
    op.urlString = urlString;
    op.sucessBlock = successBlock;
    return op;
}

/**
 override this method to concurrent download image
 */
- (void)main{
    // get the sanbox address
    NSString *caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *path = [caches stringByAppendingPathComponent:[self.urlString lastPathComponent]];
    NSData* sanbox = [NSData dataWithContentsOfFile:path];
    if (sanbox) {
        NSLog(@"load image in sanbox");
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            _sucessBlock([UIImage imageWithData:sanbox]);
        }];
        return;
    }
    NSAssert(self.urlString != nil, @"urlString can't be nil");
    NSURL* url = [NSURL URLWithString:self.urlString];
    if (self.cancelled)
        return;
    NSData* data = [NSData dataWithContentsOfURL:url];
    if (self.cancelled)
        return;
    UIImage* image = [UIImage imageWithData:data];
    if (self.cancelled)
        return;
    
    NSAssert(self.sucessBlock != nil, @"sucessBlock can't be nil");
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (data) {
            [data writeToFile:path atomically:YES];
            NSLog(@"write to sanbox");
        }
        _sucessBlock(image);
    }];
}

@end
