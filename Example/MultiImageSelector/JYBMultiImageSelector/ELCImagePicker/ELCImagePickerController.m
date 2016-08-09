//
//  ELCImagePickerController.m
//  ELCImagePickerDemo
//
//  Created by ELC on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"

@interface ELCImagePickerController ()

@property (nonatomic, assign) NSUInteger count;

@end

@implementation ELCImagePickerController

- (id)initImagePicker
{
    ELCAlbumPickerController *albumPicker = [[ELCAlbumPickerController alloc] initWithStyle:UITableViewStylePlain];
    
    self = [super initWithRootViewController:albumPicker];
    if (self) {
        [albumPicker setParent:self];
    }
    return self;
}

- (void)cancelImagePicker
{
    if ([_imagePickerDelegate respondsToSelector:@selector(elcImagePickerControllerDidCancel:)]) {
        [_imagePickerDelegate performSelector:@selector(elcImagePickerControllerDidCancel:) withObject:self];
    }
}

- (void)selectedAssets:(NSArray *)assets
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSMutableArray *returnArray = [[NSMutableArray alloc] init];
        
        for(ALAsset *asset in assets) {
            id obj = [asset valueForProperty:ALAssetPropertyType];
            if (!obj) {
                continue;
            }
            
            NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];

            ALAssetRepresentation *assetRep = [asset defaultRepresentation];
            
            if(assetRep != nil) {
                CGImageRef imgRef = nil;
                UIImageOrientation orientation = UIImageOrientationUp;

                CGSize imgSize = [assetRep dimensions];
                if (imgSize.height/imgSize.width >= 2) {
                    imgRef = [assetRep fullResolutionImage];
                } else {
                    imgRef = [assetRep fullScreenImage];
                }
                
                UIImage *img = [UIImage imageWithCGImage:imgRef
                                                   scale:1.0f
                                            orientation:orientation];
                
                [workingDictionary setObject:img forKey:UIImagePickerControllerOriginalImage];
                                
                [returnArray addObject:workingDictionary];
            }
            
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_imagePickerDelegate != nil && [_imagePickerDelegate respondsToSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:)]) {
                [_imagePickerDelegate performSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:) withObject:self withObject:returnArray];
            } else {
                [self popToRootViewControllerAnimated:NO];
            }
        });
    });
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
}

@end
