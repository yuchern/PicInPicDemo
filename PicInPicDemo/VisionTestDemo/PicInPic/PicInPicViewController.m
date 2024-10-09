//
//  PicInPicViewController.m
//  VisionTestDemo
//
//  Created by Esen on 2024/10/9.
//

#import "PicInPicViewController.h"
#import "PicInPicScreenManager.h"
#import "Masonry.h"

@interface PicInPicViewController ()

@property (nonatomic, strong) PicInPicScreenManager *manager;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PicInPicViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [self createButtonWithTitle:@"更新内容"];
    [button addTarget:self action:@selector(jumpButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(200);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(150, 50));
    }];
    
    /// 已适配自动切后台开启画中画，请按照实际需求是否需要APP主动调起画中画
    button = [self createButtonWithTitle:@"手动开关画中画"];
    [button addTarget:self action:@selector(jumpButtonAction1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(300);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(150, 50));
    }];
    
    
    button = [self createButtonWithTitle:@"切换大小"];
    [button addTarget:self action:@selector(jumpButtonAction2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(400);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(150, 50));
    }];
    
    [self.manager addScreenViewOnView:self.view];
    [self.manager picInPicAutoOpen:YES];
}

- (void)jumpButtonAction {
    __block NSInteger index = 0;
    __weak typeof(self) weakSelf = self;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSString *content = [NSString stringWithFormat:@"内容:%ld", index];
        [weakSelf.manager updateContent:content];
        index++;
    }];
}

- (void)jumpButtonAction1 {
    [self.manager manalChangePicInPic];
}

- (void)jumpButtonAction2 {
    [self.manager changePicFrame];
}

- (UIButton *)createButtonWithTitle:(NSString *)title {
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor darkGrayColor];
    button.layer.cornerRadius = 6;
    button.layer.masksToBounds = YES;
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (PicInPicScreenManager *)manager {
    if (_manager == nil) {
        _manager = [PicInPicScreenManager new];
    }
    return _manager;
}

@end
