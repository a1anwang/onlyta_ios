//
//  TalkVC.m
//  OnlyTa
//
//  Created by smartwallit on 2018/3/27.
//  Copyright © 2018年 a1anwang. All rights reserved.
//

#import "TalkVC.h"
#import "ChartVC.h"
@interface TalkVC (){
    BOOL hasTargetId;
    NSString *mTargetId; //目标 Id
    UITextField *edit_phone;
    
}

@end

@implementation TalkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.naviBarBgColor=Main_blue;
    self.naviBarShadowColor=[UIColor clearColor];
    
    if(self.appDelegate.userAccount.target_uid<=0){
        hasTargetId=NO;
    }else{
        hasTargetId=YES;
    }
    
    if(hasTargetId){
        mTargetId=[NSString stringWithFormat:@"%d",self.appDelegate.userAccount.target_uid];
        //新建一个聊天会话View Controller对象,建议这样初始化
       
    }else{
        UILabel *lable=[UILabel new];
        [self.view addSubview:lable];
        lable.text=getString(@"TA的手机:");
        lable.sd_layout.centerYEqualToView(self.view).offset(-100).heightIs(35).leftSpaceToView(self.view, 20);
        [lable setSingleLineAutoResizeWithMaxWidth:200];
        lable.textColor=[UIColor darkTextColor];
        
        edit_phone=[UITextField new];
        [self.view addSubview:edit_phone];
        edit_phone.sd_layout.leftSpaceToView(lable, 0).heightRatioToView(lable, 1).rightSpaceToView(self.view, 20).centerYEqualToView(lable);
        edit_phone.keyboardType = UIKeyboardTypeNumberPad;
        [edit_phone setAutocorrectionType:UITextAutocorrectionTypeNo];//取消键盘联想功能,以免系统输入法上面的一栏联想点击之后会输入到textfield里面,虽然设置里代理,但是这联想内容不走代理!!!
        
        UIButton *btn_submit=[UIButton new];
        [self.view addSubview:btn_submit];
        btn_submit.sd_layout.leftEqualToView(lable).rightEqualToView(edit_phone).topSpaceToView(edit_phone, 20).heightIs(35);
        btn_submit.backgroundColor=Main_blue;
        [btn_submit setTitle:getString(@"跟TA聊") forState:UIControlStateNormal];
        [btn_submit addTarget:self action:@selector(startTalk) forControlEvents:UIControlEventTouchUpInside];
        
    }
}
-(void)startTalk{
    NSString *phoneNum=edit_phone.text;
    if(![MyUtils isValidPhoneNum:phoneNum]){
        [self showToastDialog:getString(@"请输入正确的对方手机号码")];
        return;
    }
    [self showLodingProgress];
    [MyHttpUtil setTargetPhoneNum:phoneNum selfUid:self.appDelegate.userAccount.uid callBack:^(NSDictionary *dic, NSError *error) {
        [self stopProgress];
        if(!dic){
            return ;
        }
        //设置成功
        NSDictionary *data=[dic objectForKey:API_Common_Key_Data];
        NSInteger target_uid=[[data objectForKey:@"target_uid"] integerValue];
        NSString *target_nickname=[data objectForKey:@"target_nickname"];
        
        [USER_DEFAULTS setInteger:target_uid forKey:KUserDefaults_target_uid];
        [USER_DEFAULTS setObject:target_nickname forKey:KUserDefaults_target_nickname];
        
        mTargetId=[NSString stringWithFormat:@"%d",target_uid];
        self.appDelegate.userAccount.target_uid=target_uid;
        self.appDelegate.userAccount.target_nickname=target_nickname;
        hasTargetId=YES;
       //进入会话页面
        
        //新建一个聊天会话View Controller对象,建议这样初始化
        ChartVC *chat=[[ChartVC alloc] initWithConversationType:ConversationType_PRIVATE targetId:mTargetId];
        chat.title=target_nickname;
        [self push:chat needHideBottomBar:NO animated:NO];
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
