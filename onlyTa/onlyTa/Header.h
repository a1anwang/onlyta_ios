//
//  Header.h
//  OnlyTa
//
//  Created by smartwallit on 2018/3/27.
//  Copyright © 2018年 a1anwang. All rights reserved.
//

#ifndef Header_h
#define Header_h
 

#endif /* Header_h */


#define KUserDefaults_uid                   @"uid"
#define KUserDefaults_rongyun_token         @"rongyun_token"
#define KUserDefaults_headImageURL          @"headImageURL"
#define KUserDefaults_gender                @"gender"
#define KUserDefaults_nickname              @"nickname"
#define KUserDefaults_phoneNum              @"phoneNum"
#define KUserDefaults_target_uid            @"target_uid"
#define KUserDefaults_target_nickname       @"target_nickname"

#define KUserDefaults_LastLocationRequestTime       @"LastLocationRequestTime"

#define Test_Server   NO
#define Test_ServerURL @"http://testserver.teabuddy.cn/appadmin/server2.php"

#define  URL_Default_boy  @"http://www.a1anwang.com/apps/onlyta/icon_default_boy.png"
#define  URL_Default_girl  @"http://www.a1anwang.com/apps/onlyta/icon_default_girl.png"


#define API_Common_Success 0  //api接口返回的正确 code
#define API_Common_Key_ErrorCore @"err" ////api接口返回的  code的键值
#define API_Common_Key_Msg @"msg" ////api接口返回的  msg的键值
#define API_Common_Key_Data @"data" ////api接口返回的数据 的键值


#define  Location_Request_OverTime 10*1000 //位置请求超时时间
#define  Location_Request_Interval 60//60秒  位置请求间隔 每60s只允许请求一次

#define AmapLocationKey @"d6670189d3aaa0d1c057b8068a652dc7"
#define AmapWebAPI_key @"01858d5753db1e00ecd0067a7e1db4d7"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define isChinese  [[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] containsString:@"zh"]
#define NOTI_CENTER [NSNotificationCenter defaultCenter]
#define USER_DEFAULTS  [NSUserDefaults standardUserDefaults]

#define Main_blue UIColorFromRGB(0x2ea2f5)
#define Main_light_blue UIColorFromRGB(0xe4f5e9)

#define getString(a) NSLocalizedString(a, nil)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]
