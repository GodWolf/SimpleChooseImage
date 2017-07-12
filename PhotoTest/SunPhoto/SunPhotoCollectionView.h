//
//  SunPhotoCollectionView.h
//  PhotoTest
//
//  Created by 孙兴祥 on 2017/7/10.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SunPhotoModel;
@interface SunPhotoCollectionView : UICollectionView

@property (nonatomic,strong) NSArray<SunPhotoModel *> *photoAssets;

@end



@interface SunPhotoCell : UICollectionViewCell

@property (nonatomic,strong) SunPhotoModel *photoModel;

@property (nonatomic,assign) int32_t requestId;
@property (nonatomic,strong) UIImageView *imgView;

@property (nonatomic,strong) UIView *selectView;

- (void)selectAction;

@end
