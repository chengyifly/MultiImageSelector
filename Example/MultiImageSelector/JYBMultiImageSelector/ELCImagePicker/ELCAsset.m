//
//  ELCAsset.m
//  JinYuanBao
//
//  Created by 易达正丰 on 14-6-27.
//  Copyright (c) 2014年 Easymob.com.cn. All rights reserved.
//

#import "ELCAsset.h"

@implementation ELCAsset

- (instancetype)initWithAsset:(ALAsset *)asset
{
    self = [super init];
    if (self) {
        self.asset = asset;
    }
    return self;
}

@end
