//
//  SunPhotoTool.m
//  PhotoTest
//
//  Created by 孙兴祥 on 2017/7/10.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import "SunPhotoTool.h"
#import "SunPhotoModel.h"

@implementation SunPhotoTool

+ (instancetype)shareInstance {
    
    static SunPhotoTool *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[SunPhotoTool alloc] init];
    });
    return shareInstance;
}


#pragma mark - 获取所有照片
+ (NSArray<SunPhotoModel *> *)getAllImagesWithAscending:(BOOL)ascending {
    

    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:ascending]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    NSMutableArray<SunPhotoModel *> *assets = [self getModelWithFestchResults:result];

    option = nil;
    result = nil;
    
    return assets;
}

+ (NSMutableArray<SunPhotoModel *> *)getModelWithFestchResults:(PHFetchResult *)result {
    
    NSMutableArray<SunPhotoModel *> *assets = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SunPhotoModel *model = [[SunPhotoModel alloc] init];
        model.photoAsset = obj;
        [assets addObject:model];
    }];
    return assets;
}

#pragma mark - 从指定相册中获取照片
+ (NSArray<SunPhotoModel *> *)getImageFromAlbum:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending {
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:ascending]];
    
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    
    NSMutableArray<SunPhotoModel *> *assets = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SunPhotoModel *model = [[SunPhotoModel alloc] init];
        model.photoAsset = obj;
        [assets addObject:model];
    }];
    
    option = nil;
    result = nil;
    
    return assets;
}

#pragma mark - 获取相册
+ (NSArray<PHAssetCollection *> *)getAlbums {
    
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    NSMutableArray<PHAssetCollection *> *albums = [NSMutableArray array];
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [albums addObject:obj];
    }];
    
    result = nil;
    
    return albums;
}


#pragma mark - 检查访问状态
+ (void)checkAuthorizationWithBlock:(void(^)(BOOL isCanAccess))block {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined:
        case PHAuthorizationStatusDenied:{//弹出提示继续请求
            
            [self requestAuthorizationWithBlock:block];
            break;
        }
        case PHAuthorizationStatusRestricted:{
            
            if(block){
                block(NO);
            }
            break;
        }
        case PHAuthorizationStatusAuthorized:{
            
            if(block){
                block(YES);
            }
            break;
        }
        default:
            break;
    }
}

//请求访问相册
+ (void)requestAuthorizationWithBlock:(void(^)(BOOL isCanAccess))block {

    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        if(status == PHAuthorizationStatusAuthorized){
            
            if(block){
                block(YES);
            }
        }else{
            //拒绝访问相册
            if(block){
                block(NO);
            }
        }
    }];
}


@end
