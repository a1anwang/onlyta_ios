//
//  AppDelegate.m
//  OnlyTa
//
//  Created by smartwallit on 2018/2/3.
//  Copyright © 2018年 a1anwang. All rights reserved.
//

#import "AppDelegate.h"
#import "TalkListViewController.h"
#import "LoginVC.h"
#import "ChartVC.h"
@interface AppDelegate ()
{
     BOOL initComplete;//初始化完成之后才可以进入下个页面
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [AMapServices sharedServices].apiKey = AmapLocationKey;
    [[RongyunEvent getInstance] initIM];
    //统一导航条样式
    
    
    
    [self initUser];
 
 
    return YES;
}
-(void)initUser{
    NSInteger userId=[[NSUserDefaults standardUserDefaults] integerForKey:KUserDefaults_uid];
    NSLog(@" userid:%d",userId);
    if(userId>0){
        //登录过
        //开始连接IM
        self.userAccount=[UserAccount new];
        self.userAccount.uid=userId;
        self.userAccount.nickname=[[NSUserDefaults standardUserDefaults] stringForKey:KUserDefaults_nickname];
        self.userAccount.rongyun_token=[[NSUserDefaults standardUserDefaults] stringForKey:KUserDefaults_rongyun_token];
        self.userAccount.headImageURL=[[NSUserDefaults standardUserDefaults] stringForKey:KUserDefaults_headImageURL];
        self.userAccount.gender=[[NSUserDefaults standardUserDefaults] integerForKey:KUserDefaults_gender];
        self.userAccount.target_uid=[[NSUserDefaults standardUserDefaults] integerForKey:KUserDefaults_target_uid];
        self.userAccount.phoneNum=[[NSUserDefaults standardUserDefaults] stringForKey:KUserDefaults_phoneNum];
        self.userAccount.target_nickname=[[NSUserDefaults standardUserDefaults] stringForKey:KUserDefaults_target_nickname];
 
        [[RongyunEvent getInstance] connectIM:self.userAccount.rongyun_token success:^(NSString *userId) {
            //进入主页面
             initComplete=YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                self.window.backgroundColor = [UIColor whiteColor];
                NSString *mTargetId=[NSString stringWithFormat:@"%ld",self.userAccount.target_uid];
                ChartVC *chat=[[ChartVC alloc] initWithConversationType:ConversationType_PRIVATE targetId:mTargetId];
                chat.title=self.userAccount.target_nickname;
                UINavigationController*navi= [[UINavigationController alloc] initWithRootViewController:chat];
                
                self.window.rootViewController = navi;
                [self.window makeKeyAndVisible];
            });
           
           
        } error:^(RCConnectErrorCode status) {
            
        } tokenIncorrect:^{
             initComplete=YES;
            //token失败,进入登录页面
            dispatch_async(dispatch_get_main_queue(), ^{
                self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                self.window.backgroundColor = [UIColor whiteColor];
                LoginVC *vc = [[LoginVC alloc]init];
                UINavigationController *navi=[[UINavigationController alloc]initWithRootViewController:vc];
                self.window.rootViewController = navi;
                [self.window makeKeyAndVisible];
            });
           
          
        }];
    }else{
        //未登录过,进入登录页面
        initComplete=YES;
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.backgroundColor = [UIColor whiteColor];
        LoginVC *vc = [[LoginVC alloc]init];
        UINavigationController *navi=[[UINavigationController alloc]initWithRootViewController:vc];
        self.window.rootViewController = navi;
        [self.window makeKeyAndVisible];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
