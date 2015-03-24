//
//  ELCAssetCollectionPicker.h
//  JinYuanBao
//
//  Created by 易达正丰 on 14-6-26.
//  Copyright (c) 2014年 Easymob.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ELCAssetSelectionDelegate.h"
#import "JYBBaseViewController.h"

@interface ELCAssetCollectionPicker : JYBBaseViewController

@property (nonatomic, strong) ALAssetsGroup *assetGroup;
@property (nonatomic, weak) id <ELCAssetSelectionDelegate> parent;

@end
