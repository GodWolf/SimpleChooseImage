//
//  SunPhotoModel.h
//  PhotoTest
//
//  Created by 孙兴祥 on 2017/7/10.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PHAsset;
@interface SunPhotoModel : NSObject

@property (nonatomic,strong) PHAsset *photoAsset;
@property (nonatomic,assign) BOOL isSelected;

@end
