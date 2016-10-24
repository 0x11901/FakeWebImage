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
@property(strong,nonatomic) NSOperation* lastOperation;//a pointer to record last operation
@property(nonatomic,copy) NSString* lastURLString;//a pointer to record last URL
@property(nonatomic,strong) NSMutableDictionary* memeryImages;//a mutableArray for load images in memery
@end

@implementation DownloaderOperationManger

/**
 override this method to initialize something needs to prepare

 @return a shared instance
 */
- (instancetype)init{
    if (self = [super init]) {
        _downloadingImages = [NSMutableDictionary dictionary];
        _memeryImages = [NSMutableDictionary dictionary];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllMemeryCaches) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}


- (void)removeAllMemeryCaches {
    [_memeryImages removeAllObjects];
}

/**
 use the manger to mange the download queue

 @param urlString    image URL from VC
 @param successBlock the block for call-back image
 */
- (void)manger_donwloadImageWithURL:(NSString *)urlString successBlock:(void (^)(UIImage *))successBlock{
    if (urlString != nil){
        if (_memeryImages[urlString]){
            NSLog(@"load image in memory");
            successBlock(_memeryImages[urlString]);
            return;
        }else if (_downloadingImages.count > 0  && _lastOperation != nil) {
            NSLog(@"cancel last operation,download new image:%@",[urlString lastPathComponent]);
            [_downloadingImages removeObjectForKey:_lastURLString];
            [_lastOperation cancel];
            return;
        }
    }else{
        NSLog(@"urlString connot be nil,cancel this operation");
        return;
    }
    [_downloadingImages setObject:urlString forKey:urlString];
    _lastURLString = urlString;
    _lastOperation = [DownloaderOperation donwloadImageWithURL:urlString successBlock:^(UIImage* image){
        successBlock(image);
        [_memeryImages setObject:image forKey:urlString];
        [_downloadingImages removeObjectForKey:urlString];
        NSLog(@"remove the key for image(%@) which alraedy downloaded(%zd)",[urlString lastPathComponent],_downloadingImages.count);
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
