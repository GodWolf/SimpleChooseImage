//
//  SunAlbumsViewController.h
//  PhotoTest
//
//  Created by 孙兴祥 on 2017/7/10.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAssetCollection,PHFetchResult;
@interface SunAlbumsViewController : UIViewController

@property (nonatomic,copy) void(^selectAlbumBlock)(PHFetchResult *fetchResult);

@end


@interface SunAlbumCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *albumNameLabel;
@property (nonatomic,strong) UILabel *countLabel;

@end
