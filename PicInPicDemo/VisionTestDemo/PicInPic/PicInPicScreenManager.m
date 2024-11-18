//
//  PicInPicScreenManager.m
//  TestDemo
//
//  Created by Esen on 2024/10/9.
//

#import "PicInPicScreenManager.h"
#import <AVKit/AVKit.h>
#import "PicInPicScreenView.h"
#import "Masonry.h"

@interface PicInPicScreenManager ()<AVPictureInPictureControllerDelegate>

@property (nonatomic, strong) UIWindow *firstWindow;
@property (nonatomic, strong) AVPictureInPictureController *pipController;

@property (nonatomic, strong) PicInPicScreenView *screenView;   //控制器中显示的
@property (nonatomic, strong) PicInPicScreenView *picInPicView; //画中画中现实的
@property (nonatomic, assign) BOOL isOpenPicInPic;
@property (nonatomic, strong) NSMutableArray <UIWindow *>*suspectedWindows;    //疑似画中画的window

@end

@implementation PicInPicScreenManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isOpenPicInPic = YES;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateContent:(NSString *)content{
    [self.screenView updateContent:content];
    [self.picInPicView updateContent:content];
}

#pragma mark - 字幕
- (void)addScreenViewOnView:(UIView *)view {
    [view addSubview:self.screenView];
    [self.screenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(30);
        make.right.mas_equalTo(view).offset(-30);
        make.bottom.mas_equalTo(view).offset(-50);
        make.height.mas_equalTo(50);
    }];
    [view layoutIfNeeded];
    [self preparePicInPicOnView:self.screenView];
}

- (void)removeScreenView {
    [self.screenView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.suspectedWindows removeAllObjects];
}

#pragma mark - 画中画

- (void)preparePicInPicOnView:(UIView *)view {
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    /// 更换视频宽高，可以改变画中画宽高大小！但是有个需要注意的是，只有很宽且高度很低的时候，双击画中画才不会自动缩放！！这里视频宽度是2000，自测发现宽度过小时，双击画中画也会自动缩放，且要考虑pad端的画中画，如果高度大于宽度的1/4左右，双击画中画就会被系统自动缩放宽度的，因此如果要做歌词的，高度不能过高。这里可以自己切换视频原，source文件夹准备了不同高度的视频源。0920-2000700视频双击会自动缩放。这个视频资源可以用“剪映”切
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"0920-2000400" withExtension:@"mp4"];
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithAsset:[AVAsset assetWithURL:url]];
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.screenView.bounds;
    playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [view.layer insertSublayer:playerLayer atIndex:0];
    
    //画中画功能
    self.pipController = [[AVPictureInPictureController alloc] initWithPlayerLayer:playerLayer];
    self.pipController.requiresLinearPlayback = YES;
    [self.pipController setValue:@1 forKey:@"controlsStyle"];
    self.pipController.delegate = self;
    self.pipController.canStartPictureInPictureAutomaticallyFromInline = YES;
    [player play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeVisible:) name:UIWindowDidBecomeVisibleNotification object:nil];
}

- (void)picInPicAutoOpen:(BOOL)isOpen {
    self.isOpenPicInPic = isOpen;
    if (isOpen) {
        /// 画中画的本质是播放的视频，只有视频在播放，滑到后台时，系统才会自动开启画中画
        [self.pipController.playerLayer.player play];
    } else {
        [self.pipController.playerLayer.player pause];
    }
}

- (void)windowDidBecomeVisible:(NSNotification *)notification {
    id object = notification.object;
    if ([object isKindOfClass:NSClassFromString(@"PGHostedWindow")]) {
        self.firstWindow = notification.object;
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIWindowDidBecomeVisibleNotification
                                                      object:nil];
    } else if ([object isKindOfClass:[UIWindow class]]) {
        /// 不要在这里判断window的宽高，这里有可能window都还没渲染，如果还没渲染，则通过level，topwindow，遍历所有windows都不准确
        UIWindow *targetWindow = (UIWindow *)object;
        [self.suspectedWindows addObject:targetWindow];
    }
}

- (UIWindow *)filterTargetWindow {
    for (UIWindow *window in self.suspectedWindows) {
        if ([window isKindOfClass:NSClassFromString(@"PGHostedWindow")]) {
            return window;
        }
    }
    for (UIWindow *window in self.suspectedWindows) {
        if (window.windowLevel == -10000000) {
            return window;
        }
    }
    for (UIWindow *window in self.suspectedWindows) {
        //这里只是根据视频源来大致判断高度，如果视频源更换了高度较大的，要更改这个高度
        if (window.frame.size.height < 300) {
            return window;
        }
    }
    return self.suspectedWindows.firstObject;
}

- (void)changePicFrame {
    NSUInteger randomLength = arc4random_uniform(8+1) + 1;
    NSString *vedio = @"0920-2000500";
    if (randomLength == 1) {
        vedio = @"0920-2000350";
    } else if (randomLength == 2) {
        vedio = @"0920-2000400";
    } else if (randomLength == 3) {
        vedio = @"0920-2000500";
    } else if (randomLength == 4) {
        vedio = @"0920-2000600";
    } else if (randomLength == 5) {
        vedio = @"0920-2000700";
    } else if (randomLength == 6) {
        vedio = @"0920-2000800";
    } else if (randomLength == 7) {
        vedio = @"0920-2000900";
    } else if (randomLength == 8) {
        vedio = @"0920-20001000";
    }
    NSURL *url = [[NSBundle mainBundle] URLForResource:vedio withExtension:@"mp4"];
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithAsset:asset];
    [self.pipController.playerLayer.player replaceCurrentItemWithPlayerItem:item];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    // 循环播放，只有视频在播放，才可以切后台自动进入画中画
    [self.pipController.playerLayer.player seekToTime:kCMTimeZero];
    [self.pipController.playerLayer.player play];
}

- (void)manalChangePicInPic {
    if (self.pipController.isPictureInPictureActive) {
        [self.pipController stopPictureInPicture];
    } else {
        [self.pipController startPictureInPicture];
    }
}
#pragma mark - 画中画代理
- (void)pictureInPictureControllerWillStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    
}

- (void)pictureInPictureControllerDidStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    
    if (!self.firstWindow) {
        self.firstWindow = [self filterTargetWindow];
        [self.suspectedWindows removeAllObjects];
    }
    if (self.firstWindow) {
        [self.firstWindow addSubview:self.picInPicView];
        [self.picInPicView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.firstWindow);
        }];
    }
}

- (void)pictureInPictureControllerWillStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    NSLog(@"即将停止画中画功能");
    
}

- (void)pictureInPictureControllerDidStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    NSLog(@"已经停止画中画功能");
    
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController failedToStartPictureInPictureWithError:(NSError *)error {
    NSLog(@"开启画中画功能失败，原因是%@",error);
}

#pragma mark - lazyload
- (PicInPicScreenView *)screenView {
    if (_screenView == nil) {
        _screenView = [[PicInPicScreenView alloc] init];
    }
    return _screenView;
}

- (PicInPicScreenView *)picInPicView {
    if (_picInPicView == nil) {
        _picInPicView = [[PicInPicScreenView alloc] init];
    }
    return _picInPicView;
}

- (NSMutableArray *)suspectedWindows {
    if (_suspectedWindows == nil) {
        _suspectedWindows = [NSMutableArray new];
    }
    return _suspectedWindows;
}
@end
