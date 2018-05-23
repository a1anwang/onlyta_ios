//
//  ToastUtils.m
//  Teabuddy_Alan
//
//  Created by smartwallit on 2018/3/30.
//  Copyright © 2018年 teabuddy. All rights reserved.
//

#import "ToastUtils.h"

@implementation ToastUtils
+(void)showToastDialog:(NSString *)title{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];//显示时候 不可以点击后面的按钮了
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setMinimumDismissTimeInterval:2];//设置显示时间最小2S,
    [SVProgressHUD setBackgroundColor:UIColorFromRGBA(0x000000, 0.6)];//设置背景色
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];//设置字体颜色
    [SVProgressHUD showInfoWithStatus:title];
}
+(void)showSuccessDialog:(NSString *)title{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];//显示时候 不可以点击后面的按钮了
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setMinimumDismissTimeInterval:2];//设置显示时间最小2S,
    [SVProgressHUD setBackgroundColor:UIColorFromRGBA(0x000000, 0.6)];//设置背景色
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];//设置字体颜色
    [SVProgressHUD showSuccessWithStatus:title];
}
+(void)showErrorDialog:(NSString *)title{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];//显示时候 不可以点击后面的按钮了
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setMinimumDismissTimeInterval:2];//设置显示时间最小2S,
    [SVProgressHUD setBackgroundColor:UIColorFromRGBA(0x000000, 0.6)];//设置背景色
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];//设置字体颜色
    [SVProgressHUD showErrorWithStatus:title];
}

+(void)showProgress:(NSString *)title{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];//显示时候 不可以点击后面的按钮了
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:UIColorFromRGBA(0x000000, 0.6)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];//设置字体颜色
    [SVProgressHUD showWithStatus:title];
}
+(void)showLodingProgress{
    [self showProgress:getString(@"loading")];
}

+(void)stopProgress{
    [SVProgressHUD dismiss];
}
@end
