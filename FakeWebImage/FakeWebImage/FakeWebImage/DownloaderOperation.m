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
    NSAssert(self.urlString != nil, @"urlString can't be nil");
    NSURL* url = [NSURL URLWithString:self.urlString];
    NSData* data = [NSData dataWithContentsOfURL:url];
    UIImage* image = [UIImage imageWithData:data];
    NSLog(@"%@",[NSThread currentThread]);
    
    NSAssert(self.sucessBlock != nil, @"sucessBlock can't be nil");
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _sucessBlock(image);
        NSLog(@"%@",[NSThread currentThread]);
    }];
}

@end
