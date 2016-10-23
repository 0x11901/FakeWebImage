//
//  DownloaderOperation.h
//  FakeWebImage
//
//  Created by 王靖凯 on 2016/10/23.
//  Copyright © 2016年 王靖凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloaderOperation : NSOperation
@property(nonatomic,copy) NSString* urlString;//the imageURL string
@property(nonatomic,copy) void(^sucessBlock)(UIImage *);//call-bake image by block;
@end
