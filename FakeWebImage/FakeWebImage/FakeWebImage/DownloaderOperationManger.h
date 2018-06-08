//
//  DownloaderOperationManger.h
//  FakeWebImage
//
//  Created by 王靖凯 on 2016/10/23.
//  Copyright © 2016年 王靖凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloaderOperationManger : NSObject
+ (instancetype)sharedManger;
- (void)manger_donwloadImageWithURL:(NSString *)urlString
                       successBlock:(void (^)(UIImage *image))successBlock;
@end
