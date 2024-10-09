//
//  PicInPicScreenManager.h
//  TestDemo
//
//  Created by Esen on 2024/10/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface PicInPicScreenManager : NSObject


- (void)addScreenViewOnView:(UIView *)view;
- (void)picInPicAutoOpen:(BOOL)isOpen;
- (void)updateContent:(NSString *)content;
/// 手动直接唤起/关闭画中画
- (void)manalChangePicInPic;
- (void)changePicFrame;

@end

NS_ASSUME_NONNULL_END
