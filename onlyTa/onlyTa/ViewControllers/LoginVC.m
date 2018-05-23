//
//  LoginVC.m
//  OnlyTa
//
//  Created by smartwallit on 2018/3/27.
//  Copyright © 2018年 a1anwang. All rights reserved.
//

#import "LoginVC.h"
#import "CoreTFManagerVC.h"
#import "NSString+Password.h"
#import "RegisterVC.h"
#import "ForgetPwdVC.h"
#import "ChartVC.h"
@interface LoginVC (){
    UITextField *edit_phone;
    UITextField *edit_pwd;
    UserAccount *userAccount;
    
}

@end

@implementation LoginVC
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        TFModel *tfm1=[TFModel modelWithTextFiled:edit_phone inputView:nil insetBottom:5];
        tfm1.inputMode=InputType_Phone;//
        
        TFModel *tfm2=[TFModel modelWithTextFiled:edit_pwd inputView:nil insetBottom:5];
        tfm2.inputMode=InputType_PWD;//
        
        
        return @[tfm1,tfm2];
    }];
    
}
//卸载：请在viewDidDisappear中完成
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [CoreTFManagerVC uninstallManagerForVC:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.needHideNaviBar=YES;
    [self setUpViews];
    
}
-(void)setUpViews{
    UIButton *btn_login=[UIButton  new];
    [self.view addSubview:btn_login];
    btn_login.sd_layout.widthRatioToView(self.view, 0.85).heightIs(35).centerYEqualToView(self.view).centerXEqualToView(self.view);
    [btn_login setTitle:getString(@"登录") forState:UIControlStateNormal];
    btn_login.titleLabel.font=[UIFont systemFontOfSize:16];
    [btn_login addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    btn_login.sd_cornerRadius=[NSNumber numberWithFloat:4];
    btn_login.layer.borderColor=Main_blue.CGColor;
    btn_login.layer.borderWidth=1;
    [btn_login setTitleColor:Main_blue forState:UIControlStateNormal];
    
    UIView *pwdView=[UIView new];
    [self.view addSubview:pwdView]; pwdView.sd_layout.leftEqualToView(btn_login).rightEqualToView(btn_login).heightIs(35).bottomSpaceToView(btn_login, 15);
    
    UIView *phoneView=[UIView new];
     [self.view addSubview:phoneView];
phoneView.sd_layout.leftEqualToView(btn_login).rightEqualToView(btn_login).heightIs(35).bottomSpaceToView(pwdView, 15);
    
    UIImageView *imageview_phone=[UIImageView new];
    imageview_phone.image=[UIImage imageNamed:@"icon_phone"];
    [phoneView addSubview:imageview_phone];
    imageview_phone.contentMode=UIViewContentModeScaleAspectFit;
    imageview_phone.sd_layout.leftEqualToView(phoneView).heightRatioToView(phoneView, 0.8).widthEqualToHeight().centerYEqualToView(phoneView);
    edit_phone=[UITextField new];
    [phoneView addSubview:edit_phone];
    edit_phone.sd_layout.leftSpaceToView(imageview_phone, 5).heightRatioToView(phoneView, 1).rightEqualToView(phoneView).centerYEqualToView(phoneView);
    edit_phone.placeholder=getString(@"请输入11位手机号码");
    edit_phone.userInteractionEnabled=YES;
    edit_phone.keyboardType = UIKeyboardTypeNumberPad;
    [edit_phone setAutocorrectionType:UITextAutocorrectionTypeNo];//取消键盘联想功能,以免系统输入法上面的一栏联想点击之后会输入到textfield里面,虽然设置里代理,但是这联想内容不走代理!!!
    
    UIImageView *imageview_pwd=[UIImageView new];
    imageview_pwd.image=[UIImage imageNamed:@"icon_pwd"];
    [pwdView addSubview:imageview_pwd];
    imageview_pwd.contentMode=UIViewContentModeScaleAspectFit;
    imageview_pwd.sd_layout.leftEqualToView(pwdView).heightRatioToView(pwdView, 0.8).widthEqualToHeight().centerYEqualToView(pwdView);
    edit_pwd=[UITextField new];
    [pwdView addSubview:edit_pwd];
    edit_pwd.sd_layout.leftSpaceToView(imageview_pwd, 5).heightRatioToView(pwdView, 1).rightEqualToView(pwdView).centerYEqualToView(pwdView);
    edit_pwd.placeholder=getString(@"请输入密码");
    edit_pwd.userInteractionEnabled=YES;
    edit_pwd.keyboardType = UIKeyboardTypeASCIICapable;
    [edit_pwd setAutocorrectionType:UITextAutocorrectionTypeNo];//取消键盘联想功能,以免系统输入法上面的一栏联想点击之后会输入到textfield里面,虽然设置里代理,但是这联想内容不走代理!!!
    
    UIButton *btn_register=[UIButton new];
    [self.view addSubview:btn_register];
    btn_register.sd_layout.leftEqualToView(btn_login).topSpaceToView(btn_login, 5).heightIs(35).widthIs(100);
    [btn_register setTitle:getString(@"立即注册") forState:UIControlStateNormal];
    [btn_register setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    btn_register.backgroundColor=[UIColor clearColor];
    [btn_register addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    btn_register.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    btn_register.titleLabel.font=[UIFont systemFontOfSize:16];
    
    UIButton *btn_forgetpwd=[UIButton new];
    [self.view addSubview:btn_forgetpwd];
    btn_forgetpwd.sd_layout.rightEqualToView(btn_login).topSpaceToView(btn_login, 5).heightIs(35).widthIs(100);
    [btn_forgetpwd setTitle:getString(@"忘记密码?") forState:UIControlStateNormal];
    [btn_forgetpwd setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    btn_forgetpwd.backgroundColor=[UIColor clearColor];
    [btn_forgetpwd addTarget:self action:@selector(forgetPwdAction) forControlEvents:UIControlEventTouchUpInside];
    btn_forgetpwd.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    btn_forgetpwd.titleLabel.font=[UIFont systemFontOfSize:16];
    
    
}

-(void)registerAction{
    RegisterVC *vc=[[RegisterVC alloc]init];
    [self push:vc needHideBottomBar:NO animated:YES];
}
-(void)forgetPwdAction{
    ForgetPwdVC *vc=[[ForgetPwdVC alloc]init];
    [self push:vc needHideBottomBar:NO animated:YES];
}

-(void)loginAction{
    NSString* phoneNumber =  edit_phone.text;
    
    if (phoneNumber.length != 11) {
        [self showToastDialog:getString(@"请输入符合标准的手机号")];
        
        return;
    }
    
    NSString* pwd =  edit_pwd.text;
    
    if (![MyUtils isValidString:pwd]) {
        [self showToastDialog:getString(@"请输入密码")];
        return;
    }
    
    
    [self showProgress:getString(@"登录中")];
    [MyHttpUtil loginByPhoneNum:phoneNumber withPWD:[pwd MD5] callBack:^(NSDictionary *dic, NSError *error) {
        [self stopProgress];
        if(!dic){
            return ;
        }
        NSDictionary *userInfoDic=[dic objectForKey:API_Common_Key_Data];
        userAccount=[UserAccount new];
        userAccount.uid=[[userInfoDic objectForKey:@"uid"] integerValue];
        userAccount.nickname=[userInfoDic objectForKey:@"nickname"];
        userAccount.phoneNum=[userInfoDic objectForKey:@"phoneNum"];
        userAccount.QQ_id=[userInfoDic objectForKey:@"QQ_id"];
        userAccount.WeiBo_id=[userInfoDic objectForKey:@"WeiBo_id"];
        userAccount.gender=[[userInfoDic objectForKey:@"gender"] integerValue];
        userAccount.accountType=[userInfoDic objectForKey:@"accountType"];
        userAccount.headImageURL=[userInfoDic objectForKey:@"headImageURL"];
        userAccount.registerTime=[[userInfoDic objectForKey:@"registerTime"] integerValue];
        userAccount.target_uid=[[userInfoDic objectForKey:@"target_uid"] integerValue];
        NSString *target_nickname=[userInfoDic objectForKey:@"target_nickname"];
        if(target_nickname!=nil&&[target_nickname isKindOfClass:[NSString class]]){
            userAccount.target_nickname=target_nickname;
        }else{
            userAccount.target_nickname=@"";
        }
 
        userAccount.rongyun_token=[userInfoDic objectForKey:@"rongyun_token"];
        
        [self connectIM:userAccount.rongyun_token];
    }];
}
-(void)connectIM:(NSString*)token{
    [self showProgress:getString(@"加载中")];
    [[RongyunEvent getInstance] connectIM:token success:^(NSString *userId) {
        [self stopProgress];
        self.appDelegate.userAccount=userAccount;
        [USER_DEFAULTS setInteger:userAccount.uid forKey:KUserDefaults_uid];
        [USER_DEFAULTS setInteger:userAccount.target_uid forKey:KUserDefaults_target_uid];
        [USER_DEFAULTS setObject:userAccount.nickname forKey:KUserDefaults_nickname];
        [USER_DEFAULTS setObject:userAccount.phoneNum forKey:KUserDefaults_phoneNum];
        [USER_DEFAULTS setObject:userAccount.headImageURL forKey:KUserDefaults_headImageURL];
        [USER_DEFAULTS setInteger:userAccount.gender forKey:KUserDefaults_gender];
        [USER_DEFAULTS setObject:userAccount.rongyun_token forKey:KUserDefaults_rongyun_token];
        [USER_DEFAULTS setObject:userAccount.target_nickname forKey:KUserDefaults_target_nickname];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *mTargetId=[NSString stringWithFormat:@"%ld",userAccount.target_uid];
            
            ChartVC *chat=[[ChartVC alloc] initWithConversationType:ConversationType_PRIVATE targetId:mTargetId];
            chat.title=userAccount.target_nickname;
            [self push:chat needHideBottomBar:YES animated:YES];
          
        });
       
    } error:^(RCConnectErrorCode status) {
        [self stopProgress];
         [self showProgress:getString(@"登录失败,请重试")];
    } tokenIncorrect:^{
        [self stopProgress];
           [self showProgress:getString(@"登录失败,请重试")];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
