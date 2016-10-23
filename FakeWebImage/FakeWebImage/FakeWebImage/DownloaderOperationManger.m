//
//  DownloaderOperationManger.m
//  FakeWebImage
//
//  Created by 王靖凯 on 2016/10/23.
//  Copyright © 2016年 王靖凯. All rights reserved.
//

#import "DownloaderOperationManger.h"
#import "DownloaderOperation.h"

@interface DownloaderOperationManger ()
@property(nonatomic,strong) NSOperationQueue* queue;//a global concurrent queue
@end

@implementation DownloaderOperationManger
+ (instancetype)sharedManger{
    static DownloaderOperationManger* instance;
    static long flag = 0;
    dispatch_once(&flag, ^{
        instance = [DownloaderOperationManger new];
    });
    return instance;
}

/**
 use the manger to mange the download queue

 @param urlString    image URL from VC
 @param successBlock the block for call-back image
 */
- (void)manger_donwloadImageWithURL:(NSString *)urlString successBlock:(void (^)(UIImage *))successBlock{
        [self.queue addOperation:[DownloaderOperation donwloadImageWithURL:urlString successBlock:successBlock]];
}
/**
 lazy load the global concurrent queue
 
 @return global concurrent queue
 */
- (NSOperationQueue *)queue{
    if (!_queue) {
        _queue = [NSOperationQueue new];
    }
    return _queue;
}
@end
