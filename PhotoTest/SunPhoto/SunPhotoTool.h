//
//  SunPhotoTool.h
//  PhotoTest
//
//  Created by 孙兴祥 on 2017/7/10.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@class SunPhotoModel;
@interface SunPhotoTool : NSObject


/**
 获取单利
 */
+ (instancetype)shareInstance;

/**
 检查访问权限
 */
+ (void)checkAuthorizationWithBlock:(void(^)(BOOL isCanAccess))block;


/**
 获取所有照片

 @param ascending YES最久的照片在，NO最新修改的照片在前面
 */
+ (NSArray<SunPhotoModel *> *)getAllImagesWithAscending:(BOOL)ascending;

/**
 从指定相册中获取照片
 
 @param ascending YES最久的照片在前面，NO最新修改的照片在前面
 */
+ (NSArray<SunPhotoModel *> *)getImageFromAlbum:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;

/**
 获取相册
 */
+ (NSArray<PHAssetCollection *> *)getAlbums;


/**
 组装model
 */
+ (NSMutableArray<SunPhotoModel *> *)getModelWithFestchResults:(PHFetchResult *)result;


@end
