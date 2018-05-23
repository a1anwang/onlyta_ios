//
//  RongyunEvent.m
//  OnlyTa
//
//  Created by smartwallit on 2018/4/13.
//  Copyright © 2018年 a1anwang. All rights reserved.
//

#import "RongyunEvent.h"

@implementation RongyunEvent{
    block_receivedMsg mblock_receivedMsg;
}
-(void)initIM{
    [[RCIM sharedRCIM] initWithAppKey:RongYunAppKey];
    [self afterInit];
}

-(void)setReceivedMessageBlock:(block_receivedMsg)mbloc{
    mblock_receivedMsg=mbloc;
    [RCIM sharedRCIM].receiveMessageDelegate=self;
    
}

-(void)setCurrentUserInfoUid:(NSString *)uid nickaName:(NSString *)nickname headURL:(NSString *)headImageURL{
    RCUserInfo *userInfo=[[RCUserInfo alloc]initWithUserId:uid  name:nickname portrait:headImageURL];
    
    [[RCIM sharedRCIM] setCurrentUserInfo:userInfo];
    [RCIM sharedRCIM].enableMessageAttachUserInfo=YES;
}
-(void)sendLocationResponseMessageTo:(NSString *)targetId responeType:(NSString*)type block:(block_sendMsg)mblock{
 
    TALocationResponeMessage *messageContent=[[TALocationResponeMessage alloc]init];
    if([type isEqualToString:@"0"]){
        messageContent.content=@"[朕已阅,但朕比较忙,懒得告诉你位置]";
    }else if([type isEqualToString:@"1"]){
        messageContent.content=@"[朕已阅,正在定位中,定位好立马发给你]";
    }else if([type isEqualToString:@"3"]){
        messageContent.content=@"[我暂时不在线,可能原因:app未加入白名单被清理(此条消息为系统自动发送)]";
    }
    
    [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:targetId content:messageContent pushContent:@"" pushData:@"" success:^(long messageId) {
        mblock(YES);
    } error:^(RCErrorCode nErrorCode, long messageId) {
         mblock(NO);
    }];
}
-(void)sendLocationRequestMessageTo:(NSString *)targetId block:(block_sendMsg)mblock{
    TALocationRequestMessage *messageContent=[[TALocationRequestMessage alloc]init];
    
    messageContent.content=@"[立马告诉老子你在哪里]";
    
    
    [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:targetId content:messageContent pushContent:@"" pushData:@"" success:^(long messageId) {
        mblock(YES);
    } error:^(RCErrorCode nErrorCode, long messageId) {
        mblock(NO);
    }];
}
-(void)sendLocationMessageTo:(NSString *)targetId location:(CLLocationCoordinate2D)location address:(NSString *)address thumbImage:(UIImage *)image block:(block_sendMsg)mblock{
     RCLocationMessage *locationMessage = [RCLocationMessage messageWithLocationImage:image location:location locationName:address];
    
    [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:targetId content:locationMessage pushContent:@"" pushData:@"" success:^(long messageId) {
        mblock(YES);
    } error:^(RCErrorCode nErrorCode, long messageId) {
        mblock(NO);
    }];
}
/**
 * RongIM.init 融云初始化后做的事情
 */
-(void) afterInit{
    //注册自定义消息
    [[RCIM sharedRCIM] registerMessageType:[TALocationRequestMessage class]];
    [[RCIM sharedRCIM] registerMessageType:[TALocationResponeMessage class]];
}
/**
 * 融云连接服务器 connectIM 成功之后做的事情
 */
-(void)afterConnected{
    
}


-(void)connectIM:(NSString *)token success:(void (^)(NSString *))successBlock error:(void (^)(RCConnectErrorCode))errorBlock tokenIncorrect:(void (^)(void))tokenIncorrectBlock{
    NSLog(@" connectIM  token:%@",token);
    [[RCIM sharedRCIM] connectWithToken:token   success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        [self afterConnected];
        successBlock(userId);
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%lx", status);
        errorBlock(status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
        tokenIncorrectBlock();
        
    }];
}


-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
 
    if(mblock_receivedMsg!=nil){
        mblock_receivedMsg(message);
    }
}







// 创建静态对象 防止外部访问
static RongyunEvent *_instance;
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    //    @synchronized (self) {
    //        // 为了防止多线程同时访问对象，造成多次分配内存空间，所以要加上线程锁
    //        if (_instance == nil) {
    //            _instance = [super allocWithZone:zone];
    //        }
    //        return _instance;
    //    }
    // 也可以使用一次性代码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}
// 为了使实例易于外界访问 我们一般提供一个类方法
// 类方法命名规范 share类名|default类名|类名
+(instancetype)getInstance
{
    //return _instance;
    // 最好用self 用Tools他的子类调用时会出现错误
    return [[self alloc]init];
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}
@end
