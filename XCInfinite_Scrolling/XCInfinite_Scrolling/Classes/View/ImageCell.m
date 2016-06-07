//
//  ImageCell.m
//  XCInfinite_Scrolling
//
//  Created by 小蔡 on 16/6/7.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "ImageCell.h"
#import "UIView+SDAutoLayout.h"
#import "Newes.h"

@interface ImageCell()

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIImageView *imageView;

@end


@implementation ImageCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addChildView];
    }
    return self;
}

/** 添加子控件 */
- (void)addChildView{
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    self.imageView = imageView;
    imageView.sd_layout.leftSpaceToView(self, 1).rightSpaceToView(self, 1).topEqualToView(self).bottomEqualToView(self);
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont boldSystemFontOfSize:20.0];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    nameLabel.sd_layout.leftEqualToView(self).rightEqualToView(self).topEqualToView(self).heightIs(44);
    
}

- (void)setNewes:(Newes *)newes{
    _newes = newes;
    self.nameLabel.text = [NSString stringWithFormat:@"  %@", newes.title];
    self.imageView.image = [UIImage imageNamed:newes.icon];
}

@end
