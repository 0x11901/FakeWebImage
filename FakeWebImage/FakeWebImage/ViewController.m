//
//  ViewController.m
//  FakeWebImage
//
//  Created by 王靖凯 on 2016/10/23.
//  Copyright © 2016年 王靖凯. All rights reserved.
//

#import "ViewController.h"
#import "DownloaderOperation.h"

@interface ViewController ()
@property(nonatomic,strong) NSOperationQueue* queue;//a global concurrent queue
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self donwloadURL];
}

/**
 the method to dowoload image from URL
 */
- (void)donwloadURL {
    DownloaderOperation *op = [DownloaderOperation new];
    op.urlString = @"https://en.wikipedia.org/wiki/Lenna#/media/File:Lenna.png";
    [op setSucessBlock:^(UIImage *image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self.view addSubview:imageView];
        imageView.center = self.view.center;
    }];
    [self.queue addOperation:op];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
