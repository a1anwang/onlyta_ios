//
//  RongyunEvent.h
//  OnlyTa
//
//  Created by smartwallit on 2018/4/13.
//  Copyright © 2018年 a1anwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TALocationRequestMessage.h"
#import "TALocationResponeMessage.h"
#define RongYunAppKey @"8luwapkv8rcgl"


typedef void (^block_connectIM)(NSString* userId); // 回调bolck,
typedef void (^block_receivedMsg)(RCMessage* message); // 回调bolck,
typedef void (^block_sendMsg)(BOOL success); // 回调bolck,


@interface RongyunEvent : NSObject<RCIMReceiveMessageDelegate>
+(instancetype)getInstance;

-(void)initIM;
/**
 设置消息接收监听
 */
-(void)setReceivedMessageBlock:(block_receivedMsg)mbloc;
-(void)setCurrentUserInfoUid:(NSString*) uid nickaName:(NSString*) nickname headURL:(NSString*) headImageURL;

-(void)sendLocationResponseMessageTo:(NSString*)targetId responeType:(NSString*)type block:(block_sendMsg)mblock;

-(void)sendLocationRequestMessageTo:(NSString*)targetId block:(block_sendMsg)mblock;
-(void)sendLocationMessageTo:(NSString*)targetId location:(CLLocationCoordinate2D)location address:(NSString*)address thumbImage:(UIImage*)image block:(block_sendMsg)mblock;
/**
 * 融云连接服务器 connectIM 成功之后做的事情
 */
-(void)afterConnected;
/**
    连接IM服务器
 */
-(void)connectIM:(NSString*)token
         success:(void (^)(NSString *userId))successBlock
           error:(void (^)(RCConnectErrorCode status))errorBlock
  tokenIncorrect:(void (^)(void))tokenIncorrectBlock;











@end
