//
//  SunPhotoViewController.m
//  PhotoTest
//
//  Created by 孙兴祥 on 2017/7/10.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import "SunPhotoViewController.h"
#import "SunAlbumsViewController.h"
#import "SunPhotoTool.h"
#import "SunPhotoCollectionView.h"
#import "SunPhotoModel.h"

@interface SunPhotoViewController ()

@property (nonatomic,strong) SunPhotoCollectionView *collectionView;
@property (nonatomic,strong) UIView *bottomBar;

@end

@implementation SunPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self getPhotos];
    [self.view addSubview:self.bottomBar];
}

- (void)dealloc {
    
    NSLog(@"######################");
}

#pragma mark - 确定
- (void)finishSelectAction:(UIButton *)btn {
    
    NSArray *selectIndexPaths = [_collectionView indexPathsForSelectedItems];
    if(selectIndexPaths && _selectImageBlock){
        
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.networkAccessAllowed = YES;
        option.resizeMode = PHImageRequestOptionsResizeModeNone;
        option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        option.synchronous = YES;
        
        NSMutableArray<UIImage *> *images = [NSMutableArray array];
        for(NSIndexPath *indexPath in selectIndexPaths){
            
            SunPhotoModel *model = _collectionView.photoAssets[indexPath.item];
            CGSize targetSize = CGSizeMake(model.photoAsset.pixelWidth*[UIScreen mainScreen].scale, model.photoAsset.pixelHeight*[UIScreen mainScreen].scale);
            [[PHImageManager defaultManager] requestImageForAsset:model.photoAsset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
               
                if(result){
                    [images addObject:result];
                }
            }];
        }
        
        _selectImageBlock(images);
        
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - 获取所有图片
- (void)getPhotos {
    
    self.collectionView.photoAssets = [SunPhotoTool getAllImagesWithAscending:NO];
}

- (void)setNavigationBar {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(showAlbums)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.title = @"所有图片";
}

#pragma mark - 相册
- (void)showAlbums {
    
    __weak typeof(self) weakSelf = self;
    SunAlbumsViewController *albumVC = [[SunAlbumsViewController alloc] init];
    albumVC.selectAlbumBlock = ^(PHFetchResult *fetchResult) {
        
        weakSelf.collectionView.photoAssets = [SunPhotoTool getModelWithFestchResults:fetchResult];
    };
    [self.navigationController pushViewController:albumVC animated:NO];
}

#pragma mark - 取消
- (void)cancelAction {

    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - getter
- (SunPhotoCollectionView *)collectionView {
    
    if(_collectionView == nil){
        _collectionView = [[SunPhotoCollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64-40)];
    }
    return _collectionView;
}

- (UIView *)bottomBar {
    
    if(_bottomBar == nil){
        _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-40, self.view.bounds.size.width, 40)];
        _bottomBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        UIButton *finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(_bottomBar.bounds.size.width-60, 8, 50, 24)];
        finishBtn.backgroundColor = [UIColor greenColor];
        finishBtn.layer.cornerRadius = 3;
        finishBtn.clipsToBounds = YES;
        [finishBtn setTitle:@"确定" forState:UIControlStateNormal];
        [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [finishBtn addTarget:self action:@selector(finishSelectAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_bottomBar addSubview:finishBtn];
    }
    return _bottomBar;
}

@end
