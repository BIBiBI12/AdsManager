//
//  SplashPlaceholderView.m
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/7/5.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import "SplashPlaceholderView.h"
#import "Masonry.h"

@interface SplashPlaceholderView()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, assign) CGSize logoSize;

@end

@implementation SplashPlaceholderView

- (instancetype)initWithLogoImage:(UIImage *)logoImage logoSize:(CGSize )logoSize{
    self = [self init];
    if (self) {
        _logoSize = logoSize;
        self.logoImageView.image = logoImage;
        self.logoSize = logoSize;
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.logoImageView];
    self.frame = [UIScreen mainScreen].bounds;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(self.logoSize);
    }];
}

#pragma mark -- lazy
- (UIImageView *)logoImageView{
    if (nil == _logoImageView) {
        _logoImageView = [UIImageView new];
        _logoImageView.backgroundColor = [UIColor clearColor];
    }
    return _logoImageView;
}
@end
