//
//  SunAlbumsViewController.m
//  PhotoTest
//
//  Created by 孙兴祥 on 2017/7/10.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import "SunAlbumsViewController.h"
#import "SunPhotoTool.h"
#import <Photos/Photos.h>

@interface SunAlbumsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray<NSString *> *names;
@property (nonatomic,strong) NSMutableArray<PHFetchResult *> *fetchResults;

@end

@implementation SunAlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBar];
    
    [self.view addSubview:self.tableView];
    [self getAlbums];
}

- (void)getAlbums {
    
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO]];
    
    _names = [NSMutableArray array];
    _fetchResults = [NSMutableArray array];
    
    [_names addObject:@"所有图片"];
    PHFetchResult *allImage = [PHAsset fetchAssetsWithMediaType:(PHAssetMediaTypeImage) options:option];
    [_fetchResults addObject:allImage];
    
    NSArray *albums = [SunPhotoTool getAlbums];
    for(PHAssetCollection *assetCollection in albums){
        
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
        [_names addObject:assetCollection.localizedTitle];
        [_fetchResults addObject:result];
    }
    [self.tableView reloadData];
}

- (void)setNavigationBar {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.title = @"相册";
}

#pragma mark - 取消
- (void)cancelAction {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return (_names?_names.count:0);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SunAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SunAlbumCell"];
    
    PHFetchResult *result = _fetchResults[indexPath.row];
    
    cell.albumNameLabel.text = _names[indexPath.row];
    cell.countLabel.text = [NSString stringWithFormat:@"%ld张",result.count];
    
    //设置封面图
    PHAsset *asset = result[0];
    if(cell.tag){
        [[PHImageManager defaultManager] cancelImageRequest:(int)cell.tag];
    }
    
    cell.tag = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        if(result){
            cell.imgView.image = result;
        }
    }];

    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(_selectAlbumBlock){
        _selectAlbumBlock(_fetchResults[indexPath.row]);
    }
    _tableView = nil;
    _names = nil;
    _fetchResults = nil;
    [self.navigationController popViewControllerAnimated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

#pragma mark - getter
- (UITableView *)tableView {
    
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[SunAlbumCell class] forCellReuseIdentifier:@"SunAlbumCell"];
    }
    return _tableView;
}

@end




@implementation SunAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.albumNameLabel];
        [self.contentView addSubview:self.countLabel];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)imgView {

    if(_imgView == nil){
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 90, 90)];
        _imgView.backgroundColor = [UIColor grayColor];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}

- (UILabel *)albumNameLabel {
    
    if(_albumNameLabel == nil){
        _albumNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 200, 30)];
        _albumNameLabel.font = [UIFont systemFontOfSize:18];
        _albumNameLabel.textColor = [UIColor blackColor];
    }
    return _albumNameLabel;
}

- (UILabel *)countLabel {
    
    if(_countLabel == nil){
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 60, 200, 30)];
        _countLabel.font = [UIFont systemFontOfSize:15];
        _countLabel.textColor = [UIColor lightGrayColor];
    }
    return _countLabel;
}

@end
