//
//  TALocationResponeMessage.m
//  OnlyTa
//
//  Created by smartwallit on 2018/4/16.
//  Copyright © 2018年 a1anwang. All rights reserved.
//

#import "TALocationResponeMessage.h"

@implementation TALocationResponeMessage


-(NSData *)encode{
    NSDictionary *dic=@{@"content":_content};
    NSData *data= [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    return data;
}
-(void)decodeWithData:(NSData *)data{
    NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    _content=[dictionary objectForKey:@"content"];
    
}
+(NSString *)getObjectName{
    return @"app:respond_target_location";
}


+(RCMessagePersistent)persistentFlag{
    return MessagePersistent_ISCOUNTED;
}

-(NSString *)conversationDigest{
    
    return self.content;
}

@end
