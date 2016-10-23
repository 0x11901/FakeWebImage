//
//  ViewController.m
//  FakeWebImage
//
//  Created by 王靖凯 on 2016/10/23.
//  Copyright © 2016年 王靖凯. All rights reserved.
//

#import "ViewController.h"
#import "DownloaderOperation.h"
#import "AFNetworking.h"
#import "YYModel.h"
#import "URLModel.h"

@interface ViewController ()
@property(nonatomic,strong) NSOperationQueue* queue;//a global concurrent queue
@property(nonatomic,copy) NSArray<URLModel *>* URLInfos;//a global array to save models
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor cyanColor];
    [self getURL];
}

/**
 test project by this method
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    char n = arc4random_uniform((int)_URLInfos.count);
    [self donwloadWithURLString:_URLInfos[n].URLString successBlock:^(UIImage *image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self.view addSubview:imageView];
        CGFloat newHeight = imageView.bounds.size.height * [UIScreen mainScreen].bounds.size.width / imageView.bounds.size.width;
        imageView.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, newHeight);
        NSLog(@"download done...");
        [self.view layoutIfNeeded];
    }];
    NSLog(@"start downloading");
}

/**
 the method to dowoload image from URL
 */
- (void)donwloadWithURLString: (NSString*)URLString successBlock: (void(^)(UIImage *image))successBlock{
    DownloaderOperation *op = [DownloaderOperation new];
    op.urlString = URLString;
    op.sucessBlock= successBlock;
    [self.queue addOperation:op];
}

/**
 get URL infos
 */
- (void)getURL {
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger GET:@"https://raw.githubusercontent.com/wjk930726/super-train/master/apps.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _URLInfos = [NSArray yy_modelArrayWithClass:[URLModel class] json:responseObject].copy;
        NSLog(@"already got URL infos");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"download ULRInfo.json failure => %@",error);
    }];
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
