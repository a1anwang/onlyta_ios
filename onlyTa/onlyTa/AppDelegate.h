//
//  AppDelegate.h
//  OnlyTa
//
//  Created by smartwallit on 2018/2/3.
//  Copyright © 2018年 a1anwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>
#import "UserAccount.h"
#import "Header.h"
#import "BaseTabBarController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UserAccount *userAccount;
@property (strong, nonatomic) BaseTabBarController *baseTabBar;

@end

