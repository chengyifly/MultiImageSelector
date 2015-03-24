//
//  ELCAssetCollectionPicker.m
//  JinYuanBao
//
//  Created by 易达正丰 on 14-6-26.
//  Copyright (c) 2014年 Easymob.com.cn. All rights reserved.
//

#import "ELCAssetCollectionPicker.h"
#import "ELCImagePickerController.h"
#import "ELCAssetCollectionCell.h"
#import "ELCAsset.h"
#import "JYBMacros.h"
#import "UIView+Ext.h"

@interface ELCAssetCollectionPicker ()

@property (nonatomic, assign) NSUInteger     currentCount;
@property (nonatomic, assign) NSUInteger     choosedCount;
@property (nonatomic, strong) NSMutableArray *elcAssets;
@property (nonatomic, strong) NSMutableArray *choosedImages;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ELCAssetCollectionPicker

- (void)viewDidLoad
{
    self.hideBackBtn = YES;
    [super viewDidLoad];
    [self.collectionView registerClass:[ELCAssetCollectionCell class] forCellWithReuseIdentifier:@"Cell"];
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    [self.navigationItem setRightBarButtonItem:doneButtonItem];
    
    self.currentCount = ((ELCImagePickerController *)self.navigationController).currentCount;
    [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showLoadingStatus];
    StatusBarStyleDefault(YES)
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.collectionView.contentSize.height > self.collectionView.height) {
        [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentSize.height - self.collectionView.height) animated:NO];
    }
    [self hideLoadingStatus];
}


#pragma mark - Control
- (void)doneAction:(id)sender
{
    if (self.choosedImages.count) {
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self showLoadingStatusWithTipText:@"正在处理..."];
        [self.parent selectedAssets:self.choosedImages];
    } else {
        [self showTip:@"您还没选择照片呢" dismissDelay:1];
    }
}

#pragma mark - Data
- (void)preparePhotos
{
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result == nil) {
            return;
        }

        ELCAsset *asset = [[ELCAsset alloc] initWithAsset:result];
        [self.elcAssets addObject:asset];
    }];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}


#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.elcAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ELCAssetCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    ELCAsset *asset     = self.elcAssets[indexPath.row];
    cell.asset          = asset;
    cell.overlay.hidden = !asset.isChoosed;
    
    return cell;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ELCAssetCollectionCell *cell = (ELCAssetCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.asset.choosed) {
        [self.choosedImages removeObject:cell.asset.asset];
        self.choosedCount --;
    } else {
        if (self.currentCount + self.choosedCount >= 12) {
            [self showTip:@"最多只能上传12张图片" dismissDelay:1];
            return;
        }
        [self.choosedImages addObject:cell.asset.asset];
        self.choosedCount ++;
    }
    self.title = [NSString stringWithFormat:@"已选择%@/12", @(self.currentCount + self.choosedCount)];
    cell.asset.choosed  = !cell.asset.choosed;
    cell.overlay.hidden = !cell.overlay.hidden;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(75*LayoutWidthRatio, 75*LayoutWidthRatio);
}

#pragma mark - Initialization
- (NSMutableArray *)elcAssets
{
    if (!_elcAssets) {
        _elcAssets = [NSMutableArray array];
    }
    return _elcAssets;
}

- (NSMutableArray *)choosedImages
{
    if (!_choosedImages) {
        _choosedImages = [NSMutableArray array];
    }
    return _choosedImages;
}

@end
