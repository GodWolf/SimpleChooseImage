//
//  SunPhotoCollectionView.m
//  PhotoTest
//
//  Created by 孙兴祥 on 2017/7/10.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import "SunPhotoCollectionView.h"
#import <Photos/Photos.h>
#import "SunPhotoModel.h"

@interface SunPhotoCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,assign) CGFloat itemW;
@property (nonatomic,strong) PHImageRequestOptions *requestOption;

@end
@implementation SunPhotoCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    flowLayout.minimumLineSpacing = 4;
    flowLayout.minimumInteritemSpacing = 4;
    CGFloat itemW = (frame.size.width - 4*3 - 5*2)/4.0;
    flowLayout.itemSize = CGSizeMake(itemW, itemW);
    
    if(self = [super initWithFrame:frame collectionViewLayout:flowLayout]){
        
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        self.delegate = self;
        self.itemW = itemW;
        self.allowsMultipleSelection = YES;
        [self registerClass:[SunPhotoCell class] forCellWithReuseIdentifier:@"SunPhotoCell"];
        _requestOption = [[PHImageRequestOptions alloc] init];
        _requestOption.networkAccessAllowed = YES;
        _requestOption.resizeMode = PHImageRequestOptionsResizeModeNone;
        _requestOption.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    }
    return self;
}


- (void)setPhotoAssets:(NSArray<SunPhotoModel *> *)photoAssets {
    
    _photoAssets = photoAssets;
    [self reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return (_photoAssets?_photoAssets.count:0);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    SunPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SunPhotoCell" forIndexPath:indexPath];
    
    SunPhotoModel *model = _photoAssets[indexPath.item];
    cell.photoModel = model;
    
    if(cell.requestId){
        [[PHImageManager defaultManager] cancelImageRequest:cell.requestId];
    }
    
    cell.requestId = [[PHImageManager defaultManager] requestImageForAsset:model.photoAsset targetSize:CGSizeMake(model.photoAsset.pixelWidth/2.0, model.photoAsset.pixelHeight/2.0) contentMode:PHImageContentModeAspectFit options:_requestOption resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
       
        if(result){
            cell.imgView.image = result;
        }
    }];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SunPhotoCell *cell = (SunPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [cell selectAction];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SunPhotoCell *cell = (SunPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [cell selectAction];
}

@end





@implementation SunPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.selectView];
    }
    return self;
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    self.imgView.image = nil;
}

- (void)selectAction {
    
    _photoModel.isSelected = !_photoModel.isSelected;
    self.selectView.hidden = !_photoModel.isSelected;
}


- (void)setPhotoModel:(SunPhotoModel *)photoModel {
    
    _photoModel = photoModel;
    self.selectView.hidden = !_photoModel.isSelected;
}

#pragma mark - getter
- (UIImageView *)imgView {
    
    if(_imgView == nil){
        _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        _imgView.backgroundColor = [UIColor whiteColor];
    }
    return _imgView;
}

- (UIView *)selectView {
    
    if(_selectView == nil){
        _selectView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width-15, 5, 10, 10)];
        _selectView.backgroundColor = [UIColor greenColor];
        _selectView.layer.cornerRadius = 5;
        _selectView.clipsToBounds = YES;
        _selectView.hidden = YES;
    }
    return _selectView;
}

@end
