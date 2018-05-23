//
//  ForgetPwdVC.m
//  OnlyTa
//
//  Created by smartwallit on 2018/4/14.
//  Copyright © 2018年 a1anwang. All rights reserved.
//

#import "ForgetPwdVC.h"
#import "NSString+Password.h"
#import "CoreTFManagerVC.h"
@interface ForgetPwdVC (){
    UITextField *edit_phone;
    UITextField *edit_code;
    UITextField *edit_pwd;
    
    UIButton *btn_code;
    int countDownTime;
}

@end

@implementation ForgetPwdVC
-(void)dealloc{
    [self stopCountDown];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        TFModel *tfm1=[TFModel modelWithTextFiled:edit_phone inputView:nil insetBottom:5];
        tfm1.inputMode=InputType_Phone;//
        TFModel *tfm2=[TFModel modelWithTextFiled:edit_code inputView:nil insetBottom:5];
        TFModel *tfm3=[TFModel modelWithTextFiled:edit_pwd inputView:nil insetBottom:5];
        tfm3.inputMode=InputType_PWD;//
        
        
        return @[tfm1,tfm2,tfm3];
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
    self.needHideNaviBar=NO;
    self.naviBarBgColor=Main_blue;
    self.naviBarShadowColor=[UIColor clearColor];
    self.view.backgroundColor=UIColorFromRGB(0xededed);
    [self showBackWithTitle:nil];
    [self setNavigationTitle:getString(@"重置密码") withColor:[UIColor whiteColor]];
    
    
    
    [self setUpViews];
    
    
}

-(void)setUpViews{
    edit_phone=[UITextField new];
    [self.view addSubview:edit_phone];
    edit_phone.textColor=[UIColor darkGrayColor];
    edit_phone.sd_layout.topSpaceToView(self.topLayoutGuide, 30).heightIs(35).widthRatioToView(self.view, 0.85).centerXEqualToView(self.view);
    edit_phone.placeholder=getString(@"请输入手机号码");
    edit_phone.keyboardType = UIKeyboardTypeNumberPad;
    [edit_phone setAutocorrectionType:UITextAutocorrectionTypeNo];//取消键盘联想功能,以免系统输入法上面的一栏联想点击之后会输入到textfield里面,虽然设置里代理,但是这联想内容不走代理!!!
    
    UIView *line_1=[UIView new];
    line_1.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line_1];
    line_1.sd_layout.leftEqualToView(edit_phone).rightEqualToView(edit_phone).heightIs(0.5).topSpaceToView(edit_phone, 0);
    
 
    
    edit_code=[UITextField new];
    [self.view addSubview:edit_code];
    edit_code.textColor=[UIColor darkGrayColor];
    edit_code.sd_layout.topSpaceToView(line_1, 10).heightRatioToView(edit_phone, 1).widthRatioToView(edit_phone, 1).centerXEqualToView(self.view);
    edit_code.placeholder=getString(@"请输入手机验证码");
    
    UIView *line_2=[UIView new];
    line_2.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line_2];
    line_2.sd_layout.leftEqualToView(edit_code).rightEqualToView(edit_code).heightIs(0.5).topSpaceToView(edit_code, 0);
    
    btn_code = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_code addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_code];
    btn_code.sd_layout.widthIs(100).centerYEqualToView(edit_code).rightEqualToView(edit_code).heightRatioToView(edit_code, 1);
    [btn_code setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [btn_code setTitle:getString(@"获取验证码") forState:UIControlStateNormal];
    btn_code.titleLabel.font=[UIFont systemFontOfSize:14];
    
    edit_pwd=[UITextField new];
    [self.view addSubview:edit_pwd];
    edit_pwd.textColor=[UIColor darkGrayColor];
    edit_pwd.sd_layout.topSpaceToView(line_2, 10).heightRatioToView(edit_phone, 1).widthRatioToView(edit_phone, 1).centerXEqualToView(self.view);
    edit_pwd.placeholder=getString(@"请输入新密码");
    edit_pwd.keyboardType = UIKeyboardTypeASCIICapable;
    [edit_pwd setAutocorrectionType:UITextAutocorrectionTypeNo];//取消键盘联想功能,以免系统输入法上面的一栏联想点击之后会输入到textfield里面,虽然设置里代理,但是这联想内容不走代理!!!
    
    UIView *line_3=[UIView new];
    line_3.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line_3];
    line_3.sd_layout.leftEqualToView(edit_pwd).rightEqualToView(edit_pwd).heightIs(0.5).topSpaceToView(edit_pwd, 0);
    
    UIButton *btn_submit=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn_submit];
    btn_submit.sd_layout.leftEqualToView(line_3).rightEqualToView(line_3).heightIs(35).topSpaceToView(line_3, 30);
    btn_submit.backgroundColor=Main_blue;
    [btn_submit setTitle:getString(@"提交") forState:UIControlStateNormal];
    [btn_submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_submit addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)getCodeAction{
    NSString *phoneNum=edit_phone.text;
    if(![MyUtils isValidPhoneNum:phoneNum]){
        [self showToastDialog:getString(@"请输入正确的手机号码")];
        return;
    }
    [self showLodingProgress];
    
    [MyHttpUtil getResetPWDCheckCode:phoneNum callBack:^(NSDictionary *dic, NSError *error) {
        NSLog(@"获取到验证码:%@",dic);
        [self stopProgress];
        if(error){
            return ;
        }
        [self showToastDialog:getString(@"验证码已发送，请耐心等待")];
        [self countDown];//倒计时
    }];
}


-(void)countDown{
    btn_code.enabled=NO;
    countDownTime=60;
    [self performSelector:@selector(doCountDown) withObject:nil afterDelay:0];
}
-(void)doCountDown{
    if(countDownTime>0){
        [btn_code setTitle:[NSString stringWithFormat:@"%ds",countDownTime] forState:UIControlStateDisabled];
        [self performSelector:@selector(doCountDown) withObject:nil afterDelay:1];
        countDownTime--;
    }else{
        btn_code.enabled=YES;
        [btn_code setTitle:getString(@"获取验证码") forState:UIControlStateNormal];
    }
}
-(void)stopCountDown{
    [ForgetPwdVC cancelPreviousPerformRequestsWithTarget:self selector:@selector(doCountDown) object:nil];
}



-(void)submitAction{
    NSString *phoneNum=edit_phone.text;
    if(![MyUtils isValidPhoneNum:phoneNum]){
        [self showToastDialog:getString(@"请输入正确的手机号码")];
        return;
    }

    NSString *pwd=edit_pwd.text;
    if(![MyUtils isValidString:pwd]||pwd.length<6||pwd.length>16){
        [self showToastDialog:getString(@"请输入6-16位密码")];
        return;
    }
    
    NSString *code=edit_code.text;
    if(![MyUtils isValidString:code]){
        [self showToastDialog:getString(@"请输入验证码")];
        return;
    }
    [self showLodingProgress];
    [MyHttpUtil resetPWDWithPhoneNum:phoneNum withPWD:[pwd MD5] withCheckCode:code callBack:^(NSDictionary *dic, NSError *error) {
        [self stopProgress];
        if(!dic)
            return ;
        
        [ToastUtils showSuccessDialog:getString(@"重置成功,请重新登录")];
        [self.navigationController popViewControllerAnimated:YES];
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
