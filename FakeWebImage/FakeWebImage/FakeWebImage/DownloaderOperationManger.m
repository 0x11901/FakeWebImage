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
@property(nonatomic,strong) NSMutableDictionary* downloadingImages;//a global dictionary use for judge the image download if needly
@property(strong,nonatomic) NSOperation* lastOperation;
@end

@implementation DownloaderOperationManger

/**
 override this method to initialize something needs to prepare

 @return a shared instance
 */
- (instancetype)init{
    if (self = [super init]) {
        _downloadingImages = [NSMutableDictionary dictionary];
    }
    return self;
}

/**
 use the manger to mange the download queue

 @param urlString    image URL from VC
 @param successBlock the block for call-back image
 */
- (void)manger_donwloadImageWithURL:(NSString *)urlString successBlock:(void (^)(UIImage *))successBlock{
    if (urlString != nil){
        if (_downloadingImages.count > 0  && _lastOperation != nil) {
            NSLog(@"cancel last operation,download new image:%@",[urlString lastPathComponent]);
            [_lastOperation cancel];
        }
    }else{
        NSLog(@"urlString connot be nil,cancel this operation");
        return;
    }
    [_downloadingImages setObject:urlString forKey:urlString];
    _lastOperation = [DownloaderOperation donwloadImageWithURL:urlString successBlock:^(UIImage* image){
        successBlock(image);
        [_downloadingImages removeObjectForKey:urlString];
        NSLog(@"remove the key for image(%@) whith alraedy downloaded(%zd)",[urlString lastPathComponent],_downloadingImages.count);
    }];
    [self.queue addOperation:_lastOperation];
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

/**
 everyone who learn OC should kown this method for

 @return a shared instance
 */
+ (instancetype)sharedManger{
    static DownloaderOperationManger* instance;
    static long flag = 0;
    dispatch_once(&flag, ^{
        instance = [DownloaderOperationManger new];
    });
    return instance;
}
@end
