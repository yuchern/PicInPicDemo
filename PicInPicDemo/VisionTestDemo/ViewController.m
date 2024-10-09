//
//  ViewController.m
//  VisionTestDemo
//
//  Created by Esen on 11/23/23.
//

#import "ViewController.h"
#import "PicInPicViewController.h"
#import "Masonry.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor darkGrayColor];
    button.layer.cornerRadius = 16;
    button.layer.masksToBounds = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [button setTitle:@"点击跳转" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(jumpButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(150, 80));
    }];
}

- (void)jumpButtonAction {
    UIViewController *testVC = [[PicInPicViewController alloc] init];
    [self.navigationController pushViewController:testVC animated:YES];
}


@end
