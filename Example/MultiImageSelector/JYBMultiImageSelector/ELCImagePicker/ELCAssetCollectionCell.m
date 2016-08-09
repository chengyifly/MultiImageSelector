//
//  ELCAssetCollectionCell.m
//  JinYuanBao
//
//  Created by 易达正丰 on 14-6-26.
//  Copyright (c) 2014年 Easymob.com.cn. All rights reserved.
//

#import "ELCAssetCollectionCell.h"

@implementation ELCAssetCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.overlay = [[UIImageView alloc] initWithFrame:self.bounds];
        self.overlay.image = [UIImage imageNamed:@"Overlay"];
        self.overlay.hidden = YES;
        [self.contentView addSubview:self.overlay];
    }
    return self;
}

- (void)setAsset:(ELCAsset *)asset
{
    _asset = asset;
    
    UIImage *image = [UIImage imageWithCGImage:asset.asset.thumbnail];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.bounds];
    iv.image = image;
    self.backgroundView = iv;
}


@end
