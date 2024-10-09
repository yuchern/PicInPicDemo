//
//  PicInPicScreenView.m
//  TestDemo
//
//  Created by Esen on 2024/9/20.
//

#import "PicInPicScreenView.h"
#import "Masonry.h"

@interface PicInPicScreenView()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIView *lineView;


@end

@implementation PicInPicScreenView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.bgView];
    [self addSubview:self.contentLabel];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(16);
        make.top.mas_equalTo(self).offset(16);
        make.right.mas_equalTo(self).offset(-16);
        make.bottom.mas_equalTo(self).offset(-16);
    }];
}

- (void)updateContent:(NSString *)content {
    self.contentLabel.text = content ?: @"";
}


#pragma mark - lazy load

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (_titleLabel== nil) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"标题";
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel== nil) {
        _contentLabel = [UILabel new];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.text = @"内容";
    }
    return _contentLabel;
}

@end
