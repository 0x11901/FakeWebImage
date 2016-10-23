//
//  ViewController.m
//  FakeWebImage
//
//  Created by 王靖凯 on 2016/10/23.
//  Copyright © 2016年 王靖凯. All rights reserved.
//

#import "ViewController.h"
#import "DownloaderOperationManger.h"
#import "AFNetworking.h"
#import "YYModel.h"
#import "URLModel.h"

@interface ViewController ()
@property(nonatomic,copy) NSArray<URLModel *>* URLInfos;//a global array to save models
@property(weak,nonatomic) UIImageView* showImageView;//a global imageView to test download method
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
        self.showImageView.image = image;
        NSLog(@"download done...");
        [self.view layoutIfNeeded];
    }];
    NSLog(@"start downloading");
}

/**
 the method to dowoload image from URL
 */
- (void)donwloadWithURLString: (NSString*)URLString successBlock: (void(^)(UIImage *image))successBlock{
    [[DownloaderOperationManger sharedManger] manger_donwloadImageWithURL:URLString successBlock:successBlock];
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
 lazy load the global test imageView

 @return global test imageView
 */
- (UIImageView *)showImageView{
    if (!_showImageView) {
        UIImageView *imageView = [UIImageView new];
        [self.view addSubview:imageView];
//        CGFloat newHeight = imageView.bounds.size.height * [UIScreen mainScreen].bounds.size.width / imageView.bounds.size.width;
        imageView.frame = CGRectMake(0, 0, 60, 60);
        imageView.center = self.view.center;
        _showImageView = imageView;
    }
    return _showImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
