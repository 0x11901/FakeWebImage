//
//  DownloaderOperation.h
//  FakeWebImage
//
//  Created by 王靖凯 on 2016/10/23.
//  Copyright © 2016年 王靖凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloaderOperation : NSOperation

/**
 quick way to use download an image

 @param urlString          image's url string
 @param successBlock block to call-back an image
 */
+ (instancetype)donwloadImageWithURL:(NSString *)urlString successBlock: (void(^)(UIImage *image))successBlock;

@end
