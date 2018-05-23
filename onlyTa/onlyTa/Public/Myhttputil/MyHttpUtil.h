//
//  MyHttpUtil.h
//  Teabuddy_Alan
//
//  Created by smartwallit on 2018/3/27.
//  Copyright © 2018年 teabuddy. All rights reserved.
//

#import <Foundation/Foundation.h>
 

@interface MyHttpUtil : NSObject


/**
  获取服务器地址
 */
+ (void)getServerURL:(void (^)(NSDictionary *resp, NSError *error))completeBlock;



+(void)getRegisterCheckCode:(NSString*)phoneNum callBack:(void (^)(NSDictionary *, NSError *))completeBlock;
+(void)getResetPWDCheckCode:(NSString*)phoneNum callBack:(void (^)(NSDictionary *, NSError *))completeBlock;

/**
 使用手机号码注册账号
 */
+(void)registerByPhoneNum:(NSString*)phoneNum withPWD:(NSString*)pwd withNickname:(NSString*)nickname widthGender:(NSInteger)gender withCheckCode:(NSString*)checkcode withHeadimageKey:(NSString*)headimageKey callBack:(void (^)(NSDictionary *dic, NSError *error))completeBlock;

+(void)setTargetPhoneNum:(NSString *)phoneNum selfUid:(NSInteger)uid callBack:(void (^)(NSDictionary *, NSError *))completeBlock;


/**
 使用手机号码登录,返回绑定设备信息
 */
+(void)loginByPhoneNum:(NSString*)phoneNum withPWD:(NSString*)pwd callBack:(void (^)(NSDictionary *dic, NSError *error))completeBlock;

/**
 获取头像上传token
 */
+(void)getUploadTokenByPhoneNum:(NSString*)phoneNum  callBack:(void (^)(NSDictionary *dic, NSError *error))completeBlock;
+(void)getUserinfoWithUid:(NSInteger )uid callBack:(void (^)(NSDictionary *dic, NSError *error))completeBlock;

+(void)checkTargetOnlineState:(NSInteger)checkType targetId:(NSString*)targetId callBack:(void (^)(NSDictionary *dic, NSError *error))completeBlock;

/**
 修改密码
 */
+(void)resetPWDWithPhoneNum:(NSString*)phoneNum withPWD:(NSString*)pwd withCheckCode:(NSString*)checkcode callBack:(void (^)(NSDictionary *dic, NSError *error))completeBlock;

+ (void)downloadFile:(NSString*)filrurl CompleteBlock:(void (^)(NSData *data, NSError *error))completeBlock;



+(void)doGetRequest:(NSString*)url parameter:(NSDictionary*)dic callBack:(void (^)(NSDictionary *dic, NSError *error))completeBlock;
+(void)doPostRequest:(NSString*)url parameter:(NSDictionary*)dic callBack:(void (^)(NSDictionary *dic, NSError *error))completeBlock;

@end
