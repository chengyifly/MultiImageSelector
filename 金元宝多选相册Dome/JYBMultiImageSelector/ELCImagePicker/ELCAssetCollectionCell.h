//
//  ELCAssetCollectionCell.h
//  JinYuanBao
//
//  Created by 易达正丰 on 14-6-26.
//  Copyright (c) 2014年 Easymob.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ELCAsset.h"

@interface ELCAssetCollectionCell : UICollectionViewCell

@property (nonatomic, strong) ELCAsset    *asset;
@property (nonatomic, strong) UIImageView *overlay;

@end
