//
//  UserAccount.h
//  OnlyTa
//
//  Created by smartwallit on 2018/3/27.
//  Copyright © 2018年 a1anwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAccount : NSObject
@property(strong,nonatomic) NSString *nickname;
@property(nonatomic) NSInteger  uid;
@property(strong,nonatomic) NSString *phoneNum;
@property(strong,nonatomic) NSString *accountType;

@property(strong,nonatomic) NSString *QQ_id;


@property(strong,nonatomic) NSString *WeiBo_id;


@property(strong,nonatomic) NSString *headImageURL;

@property(nonatomic) NSInteger gender;//1男  0女

@property(nonatomic) NSInteger registerTime;
@property(nonatomic) NSInteger target_uid;

@property(strong,nonatomic) NSString *target_nickname;

@property(strong,nonatomic) NSString *rongyun_token;

@end
