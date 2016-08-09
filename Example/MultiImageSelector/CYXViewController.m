//
//  CYXViewController.m
//  MultiImageSelector
//
//  Created by CYFly on 08/05/2016.
//  Copyright (c) 2016 CYFly. All rights reserved.
//

#import "CYXViewController.h"
#import "JYBMultiImageSelector.h"

@interface CYXViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, JYBMultiImageViewDelegate, ELCImagePickerControllerDelegate>

@property (nonatomic, strong) JYBMultiImageView *multiImageView;

@end

@implementation CYXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCenterUI];
}

- (void)setupCenterUI
{
    // 创建图片显示区域
    self.multiImageView = [[JYBMultiImageView alloc] initWithFrame:CGRectMake(10, 120, self.view.frame.size.width-20, 100)];
    self.multiImageView.delegate = self;
    [self.view addSubview:self.multiImageView];
}


#pragma mark -
#pragma mark - Control

/**
 *  拍照
 *  相册
 *  @param showCamare
 */
- (void)showImagePickerWithCamare:(BOOL)showCamare
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (showCamare) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    if(![UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        NSLog(@"不支持拍照");
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;   // 设置委托
    imagePickerController.sourceType = sourceType;
    imagePickerController.allowsEditing = showCamare;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

/**
 *  调起可多选图片相册，选择图片
 */
- (void)multiSelectImagesFromPhotoLibrary
{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    elcPicker.imagePickerDelegate  = self;
    elcPicker.currentCount         = self.multiImageView.images_MARR.count;
    [self presentViewController:elcPicker animated:YES completion:nil];
}


#pragma mark -
#pragma mark - Delegate


#pragma mark - JYBMultiImageView Delegate
- (void)addButtonDidTap
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"手机相册", nil];
    [sheet showInView:self.view];
}

- (void)multiImageBtn:(NSInteger)index withImage:(UIImage *)image
{
    // 图片放大显示，或删除等操作
    NSLog(@"index => %ld", (long)index);
}


#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self showImagePickerWithCamare:YES];
            break;
        case 1:
            [self multiSelectImagesFromPhotoLibrary];
            break;
    }
}


#pragma mark - ELCImagePickerController Delegate
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in info) {
            UIImage *image = dic[UIImagePickerControllerOriginalImage];
            [array addObject:image];
        }
        [self addMoreImages:array];
    }];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self addMoreImages:@[info[UIImagePickerControllerEditedImage]]];
    }];
}




#pragma mark -
#pragma mark - Logic

/**
 *  添加新图片到显示区域
 *
 *  @param images 图片数组
 */
- (void)addMoreImages:(NSArray *)images
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.multiImageView.images_MARR];
    [arr addObjectsFromArray:images];
    [self.multiImageView.images_MARR removeAllObjects];
    self.multiImageView.images_MARR = arr;
}



@end
