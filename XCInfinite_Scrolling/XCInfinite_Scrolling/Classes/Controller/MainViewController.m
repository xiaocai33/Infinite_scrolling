//
//  MainViewController.m
//  XCInfinite_Scrolling
//
//  Created by 小蔡 on 16/6/6.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MainViewController.h"
#import "UIView+SDAutoLayout.h"
#import "ImageCell.h"
#import "MJExtension.h"
#import "Newes.h"
#define XCMaxSections 10
#define CollectionHeight 250
#define magin 20

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *newesArr;

@end


@implementation MainViewController

static NSString *ID = @"cell";
/**
 *  懒加载数据模型
 */
- (NSArray *)newesArr{
    if (_newesArr == nil) {
        _newesArr = [Newes objectArrayWithFilename:@"newses.plist"];
    }
    return _newesArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    //添加CollectionView
    [self addCollectionView];
}

/**
 *  添加CollectionView
 */
- (void)addCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //设置各行的间距为0
    flowLayout.minimumLineSpacing = 0;
    //设置滚动方向(水平)
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor blueColor];
    //设置代理和数据源方法
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    
    [self.view addSubview:collectionView];
    
    //注册cell
    [collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:ID];
    
    //自动布局
    collectionView.sd_layout.leftSpaceToView(self.view, magin).rightSpaceToView(self.view, magin).topSpaceToView(self.view, 40).heightIs(CollectionHeight);
    NSLog(@"%@", NSStringFromCGRect(collectionView.bounds));
    CGFloat itemWidth = [UIScreen mainScreen].bounds.size.width - 2 * magin;
    flowLayout.itemSize = CGSizeMake(itemWidth, CollectionHeight);
}

#pragma mark - UICollectionViewDataSource
/**
 *  多少组
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return XCMaxSections;
}

/**
 *  每组多少个数据
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.newesArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.newes = self.newesArr[indexPath.item];
    
    return cell;
}

@end
