//
//  UIImageView+webCaches.m
//  FakeWebImage
//
//  Created by 王靖凯 on 2016/10/24.
//  Copyright © 2016年 王靖凯. All rights reserved.
//

#import "UIImageView+webCaches.h"
#import "DownloaderOperationManger.h"

@implementation UIImageView (webCaches)

/**
 main method to download image and save caches in sanbox

 @param URLString image's URL
 */
- (void)fake_setImageWithURLString:(NSString *)URLString{
    [[DownloaderOperationManger sharedManger] manger_donwloadImageWithURL:URLString successBlock:^(UIImage *image){
        self.image = image;
    }];
}

@end
