//
//  ViewController.m
//  PhotoTest
//
//  Created by 孙兴祥 on 2017/7/10.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import "ViewController.h"
#import "SunPhotoNavgController.h"
#import "SunPhotoViewController.h"
#import "SunPhotoTool.h"

@interface ViewController ()

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageView.backgroundColor = [UIColor grayColor];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    __weak typeof(self) weakSelf = self;
    [SunPhotoTool checkAuthorizationWithBlock:^(BOOL isCanAccess) {
        if(isCanAccess){
            
            SunPhotoViewController *vc = [[SunPhotoViewController alloc] init];
            vc.selectImageBlock = ^(NSArray<UIImage *> *images) {
                weakSelf.imageView.image = images[0];
            };
            SunPhotoNavgController *navgVC = [[SunPhotoNavgController alloc] initWithRootViewController:vc];
            [self presentViewController:navgVC animated:YES completion:NULL];
        }
    }];
}


@end
