//
//  ToastUtils.h
//  Teabuddy_Alan
//
//  Created by smartwallit on 2018/3/30.
//  Copyright © 2018年 teabuddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"
@interface ToastUtils : NSObject

+(void)showProgress:(NSString *)title;
+(void)stopProgress;
+(void)showToastDialog:(NSString *)title;
+(void)showLodingProgress;

+(void)showSuccessDialog:(NSString *)title;
+(void)showErrorDialog:(NSString *)title;
@end
