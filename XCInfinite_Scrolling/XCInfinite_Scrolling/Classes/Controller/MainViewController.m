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
@property (nonatomic, weak) UICollectionView *collectionView;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 分页提示 */
@property (nonatomic, weak) UIPageControl *page;

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
    
    [self addTimer];
}
/**
 *  控制器显示的时候
 */
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //在控制器显示的时候, 跳转到中间的那组
    NSIndexPath *beginIndexPath = [NSIndexPath indexPathForItem:0 inSection:XCMaxSections/2];
    [self.collectionView scrollToItemAtIndexPath:beginIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
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
    
    //设置每个item的尺寸
    CGFloat itemWidth = [UIScreen mainScreen].bounds.size.width - 2 * magin;
    flowLayout.itemSize = CGSizeMake(itemWidth, CollectionHeight);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor blueColor];
    //设置代理和数据源方法
    collectionView.dataSource = self;
    collectionView.delegate = self;
    //隐藏滑动条
    collectionView.showsHorizontalScrollIndicator = NO;
    //设置分页
    collectionView.pagingEnabled = YES;
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    //注册cell
    [collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:ID];
    
    //自动布局
    collectionView.sd_layout.leftSpaceToView(self.view, magin).rightSpaceToView(self.view, magin).topSpaceToView(self.view, 40).heightIs(CollectionHeight);
    
    //添加分页控制器
    
}

/**
 *  添加定时器
 */
- (void)addTimer{
    //添加定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  销毁定时器
 */
- (void)clearTimer{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

/**
 *  下一张图片
 */
- (void)nextImage{
    
    //当前正在展示的位置
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    
    NSIndexPath *resetIndexPath = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:currentIndexPath.section];
    [self.collectionView scrollToItemAtIndexPath:resetIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    //计算出下一个位置
    NSInteger nextItem = resetIndexPath.item + 1;
    NSInteger nextSection = resetIndexPath.section;
    if (nextItem == self.newesArr.count) {
        nextItem = 0;
        nextSection += 1;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    //滚动到下一个位置
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
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

#pragma mark - UICollectionViewDelegate
/**
 *  即将拖拽
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self clearTimer];
}
/**
 *  停止拖拽
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}

@end
