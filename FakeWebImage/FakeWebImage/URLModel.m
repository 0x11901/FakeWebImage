//
//  URLModel.m
//  FakeWebImage
//
//  Created by 王靖凯 on 2016/10/23.
//  Copyright © 2016年 王靖凯. All rights reserved.
//

#import "URLModel.h"

@interface URLModel ()
@property(nonatomic,copy) NSString* icon;
@end

@implementation URLModel
- (void)setIcon:(NSString *)icon{
    _URLString = icon;
    _icon = icon;
}

- (NSString *)description{
    return self.URLString.description;
}
@end
