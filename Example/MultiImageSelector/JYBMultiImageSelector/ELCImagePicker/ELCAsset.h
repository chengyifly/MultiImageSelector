//
//  ELCAsset.h
//  JinYuanBao
//
//  Created by 易达正丰 on 14-6-27.
//  Copyright (c) 2014年 Easymob.com.cn. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface ELCAsset : NSObject

@property (nonatomic, getter = isChoosed) BOOL    choosed;
@property (nonatomic, strong)             ALAsset *asset;

- (instancetype)initWithAsset:(ALAsset *)asset;

@end
