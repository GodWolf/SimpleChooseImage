//
//  SunPhotoViewController.h
//  PhotoTest
//
//  Created by 孙兴祥 on 2017/7/10.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SunPhotoViewController : UIViewController

@property (nonatomic,copy) void(^selectImageBlock)(NSArray<UIImage *> *images);

@end
