//
//  MyHttpUtil.m
//  Teabuddy_Alan
//
//  Created by smartwallit on 2018/3/27.
//  Copyright © 2018年 teabuddy. All rights reserved.
//

#import "MyHttpUtil.h"
#import <AFNetworking.h>
NSString *serverURL=@"http://www.a1anwang.com/apps/onlyta/API/";//服务器接口地址
@implementation MyHttpUtil{
    
}
+ (AFHTTPSessionManager *)sharedManager
{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [AFHTTPSessionManager manager];
        manager.operationQueue.maxConcurrentOperationCount = 5;
        manager.requestSerializer.timeoutInterval=30.f;
        manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",@"audio/mpeg",nil];
       //
        [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
     
        
    });
    return manager;
}


+(void)getServerURL:(void (^)(NSDictionary *, NSError *))completeBlock{
    /*
    NSString *urlString=  [NSString stringWithFormat:@"%@%@%@%@?type=getswitchurl",HTTP,APPTEABUDDY_FORMAL,APPADMIN,SERVER];
    
    NSLog(@"Firing synchronous url connection...");
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatchQueue, ^{
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        if ([data length] > 0 && error == nil) {
            NSLog(@"%lu bytes of data was returned.",(unsigned long)[data length]);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"收到json:%@",dic);
            NSLog(@"获取 服务器地址 连接成功:%@",dic);
            
            if ([dic[@"rcode"] intValue] == 1)
            {
                //请求成功,进行解析
                NSString *url=dic[@"url"];
                if([url hasSuffix:@"/"]){
                    
                }else{
                    url=[NSString stringWithFormat:@"%@/",url];
                }
                serverURL = [NSString stringWithFormat:@"%@%@%@%@",HTTP,url,APPADMIN,SERVER ];
               
                if(Test_Server){
                    serverURL= Test_ServerURL;
                }
                NSLog(@" serverURL:%@",serverURL);
                completeBlock(dic,nil);
            }else
            {
                NSLog(@"请求失败原因：%@",dic[@"rmsg"]);
            }
            
        }else if ([data length] == 0 && error == nil){
            NSLog(@"No data was returned.");
        }else if (error != nil){
            NSLog(@"Error happened = %@",error);
        }
    });*/
}

+(void)registerByPhoneNum:(NSString *)phoneNum withPWD:(NSString *)pwd withNickname:(NSString *)nickname widthGender:(NSInteger)gender withCheckCode:(NSString*)checkcode withHeadimageKey:(NSString *)headimageKey callBack:(void (^)(NSDictionary *, NSError *))completeBlock{
    NSDictionary *dic;
    if(headimageKey==nil){
        dic=@{@"pwd":pwd,@"phoneNum":phoneNum,@"nickname":nickname,@"authcode":checkcode,@"gender":[NSNumber numberWithInteger:gender]};
    }else{
        dic=@{@"pwd":pwd,@"phoneNum":phoneNum,@"nickname":nickname,@"authcode":checkcode,@"gender":[NSNumber numberWithInteger:gender],@"headimageKey":headimageKey};
    }
 
    [self doPostRequest:[NSString stringWithFormat:@"%@register.php",serverURL] parameter:dic callBack:completeBlock];
}

+(void)loginByPhoneNum:(NSString *)phoneNum withPWD:(NSString *)pwd callBack:(void (^)(NSDictionary *, NSError *))completeBlock{
    NSDictionary *dic=@{@"pwd":pwd,@"phoneNum":phoneNum,@"accountType":@"Phone"};
    [self doPostRequest:[NSString stringWithFormat:@"%@login.php",serverURL] parameter:dic callBack:completeBlock];
}

+(void)checkTargetOnlineState:(NSInteger)checkType targetId:(NSString *)targetId callBack:(void (^)(NSDictionary *, NSError *))completeBlock{
    NSDictionary *dic=@{@"checkType":[NSNumber numberWithInteger:checkType],@"uid":[NSNumber numberWithInteger:[USER_DEFAULTS integerForKey:KUserDefaults_uid]],@"target_uid":targetId};
    [self doPostRequest:[NSString stringWithFormat:@"%@checkTargetOnlineState.php",serverURL] parameter:dic callBack:completeBlock];
}

+(void)getUploadTokenByPhoneNum:(NSString *)phoneNum  callBack:(void (^)(NSDictionary *, NSError *))completeBlock{
    NSDictionary *dic=@{@"phoneNum":phoneNum};
    [self doPostRequest:[NSString stringWithFormat:@"%@getQiniuUploadToken.php",serverURL] parameter:dic callBack:completeBlock];
}
+(void)resetPWDWithPhoneNum:(NSString *)phoneNum withPWD:(NSString *)pwd withCheckCode:(NSString*)checkcode callBack:(void (^)(NSDictionary *, NSError *))completeBlock{
    NSDictionary *dic=@{@"phoneNum":phoneNum,@"pwd":pwd,@"authcode":checkcode};
    [self doPostRequest:[NSString stringWithFormat:@"%@changepwd.php",serverURL] parameter:dic callBack:completeBlock];
}
+(void)getRegisterCheckCode:(NSString *)phoneNum callBack:(void (^)(NSDictionary *, NSError *))completeBlock{
    NSDictionary *dic=@{@"type":[NSNumber numberWithInteger:1],@"targetPhoneNum":phoneNum};
    [self doPostRequest:[NSString stringWithFormat:@"%@getauthcode.php",serverURL] parameter:dic callBack:completeBlock];
}
+(void)getResetPWDCheckCode:(NSString *)phoneNum callBack:(void (^)(NSDictionary *, NSError *))completeBlock{
    NSDictionary *dic=@{@"type":[NSNumber numberWithInteger:2],@"targetPhoneNum":phoneNum};
    [self doPostRequest:[NSString stringWithFormat:@"%@getauthcode.php",serverURL] parameter:dic callBack:completeBlock];
}

+(void)getUserinfoWithUid:(NSInteger )uid callBack:(void (^)(NSDictionary *, NSError *))completeBlock{
    NSDictionary *dic=@{@"uid":[NSNumber numberWithInteger:uid]};
    [self doPostRequest:[NSString stringWithFormat:@"%@getUserInfo.php",serverURL] parameter:dic callBack:completeBlock];
}

+(void)setTargetPhoneNum:(NSString *)phoneNum selfUid:(NSInteger)uid callBack:(void (^)(NSDictionary *, NSError *))completeBlock{
    NSDictionary *dic=@{@"uid":[NSNumber numberWithInteger:uid],@"targetPhoneNum":phoneNum};
    
    [self doPostRequest:[NSString stringWithFormat:@"%@setTarget.php",serverURL] parameter:dic callBack:completeBlock];
}


+(void)downloadFile:(NSString *)filrurl CompleteBlock:(void (^)(NSData *, NSError *))completeBlock{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager GET:filrurl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        
        if(responseObject!=nil){
            
            completeBlock(responseObject,nil);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        NSLog(@"error-->%@",error);
        completeBlock(nil,error);
    }];
}
 
+(void)doGetRequest:(NSString*)url parameter:(NSDictionary*)dic callBack:(void (^)(NSDictionary *, NSError *))completeBlock
{
 
    //AFN管理者调用get请求方法
    [[MyHttpUtil sharedManager] GET:url parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
   
        if(responseObject!=nil&&[responseObject isKindOfClass:[NSDictionary class]]){
            
            if([responseObject objectForKey:API_Common_Key_ErrorCore]!=nil){
                NSInteger rcode=[[responseObject objectForKey:API_Common_Key_ErrorCore] integerValue];
                if(rcode==API_Common_Success){
                    completeBlock(responseObject,nil);
                }else{// 出错的话 ,直接提示用户
                    
                    completeBlock(responseObject,nil);
                
                    NSString *rmsg;
                    
                    rmsg=[responseObject objectForKey:API_Common_Key_Msg];
                    
                    [ToastUtils showToastDialog:rmsg];
                    
                }
            }else{
                [ToastUtils showToastDialog:getString(@"访问失败")];
                completeBlock(nil,nil);
            }
        }
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        NSLog(@"error-->%@",error);
        [ToastUtils showToastDialog:getString(@"访问失败")];
        completeBlock(nil,error);
    }];
}
+(void)doPostRequest:(NSString*)url parameter:(NSDictionary*)dic callBack:(void (^)(NSDictionary *, NSError *))completeBlock
{
 
    //AFN管理者调用get请求方法
    [[MyHttpUtil sharedManager] POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        if(responseObject!=nil&&[responseObject isKindOfClass:[NSDictionary class]]){
            
            if([responseObject objectForKey:API_Common_Key_ErrorCore]!=nil){
                NSInteger rcode=[[responseObject objectForKey:API_Common_Key_ErrorCore] integerValue];
                if(rcode==API_Common_Success){
                    completeBlock(responseObject,nil);
                }else{// 出错的话 ,直接提示用户
                    
                    completeBlock(nil,nil);
                    NSString *rmsg;
                    
                    rmsg=[responseObject objectForKey:API_Common_Key_Msg];
                   
                    [ToastUtils showToastDialog:rmsg];
                    
                }
            }else{
                [ToastUtils showToastDialog:getString(@"访问失败")];
                completeBlock(nil,nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        [ToastUtils showToastDialog:getString(@"访问失败")];
        NSLog(@"error-->%@",error);
        completeBlock(nil,error);
    }];
}
@end
