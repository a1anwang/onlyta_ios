//
//  RegisterVC.m
//  OnlyTa
//
//  Created by smartwallit on 2018/4/13.
//  Copyright © 2018年 a1anwang. All rights reserved.
//

#import "RegisterVC.h"
#import "UIImageView+WebCache.h"
#import "NSString+Password.h"
#import "CoreTFManagerVC.h"
@interface RegisterVC ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UIImageView *imageViewHead;
    NSInteger gender;//1男 0女
    
    UITextField *edit_phone;
    UITextField *edit_nickname;
    UITextField *edit_code;
    UITextField *edit_pwd;
    
    UIButton * btn_code;
    BOOL selectHeadimage;//是否选择了图片或者拍照作为头像
}

@end

@implementation RegisterVC
-(void)dealloc{
    [self stopCountDown];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        TFModel *tfm1=[TFModel modelWithTextFiled:edit_phone inputView:nil insetBottom:5];
        tfm1.inputMode=InputType_Phone;//
        
        TFModel *tfm2=[TFModel modelWithTextFiled:edit_nickname inputView:nil insetBottom:5];
        TFModel *tfm3=[TFModel modelWithTextFiled:edit_code inputView:nil insetBottom:5];
        TFModel *tfm4=[TFModel modelWithTextFiled:edit_pwd inputView:nil insetBottom:5];
        tfm4.inputMode=InputType_PWD;//
 
        
        return @[tfm1,tfm2,tfm3,tfm4];
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
    [self setNavigationTitle:getString(@"注册") withColor:[UIColor whiteColor]];
    imageViewHead=[UIImageView new];
    [self.view addSubview:imageViewHead];
    imageViewHead.sd_layout.centerXEqualToView(self.view).widthRatioToView(self.view, 0.3).heightEqualToWidth().topSpaceToView(self.topLayoutGuide, 20);
    imageViewHead.sd_cornerRadiusFromWidthRatio=[NSNumber numberWithFloat:0.5];//把imageview设为圆形
    [imageViewHead sd_setImageWithURL:[NSURL URLWithString:URL_Default_girl] placeholderImage:nil];
    imageViewHead.userInteractionEnabled=YES;
    UITapGestureRecognizer*tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPicAction)];
    [imageViewHead addGestureRecognizer:tap];
    
    
    UIImageView *selectpicImageview=[UIImageView new];
    [self.view addSubview:selectpicImageview];
    selectpicImageview.sd_layout.heightIs(16).widthIs(16).rightEqualToView(imageViewHead).bottomEqualToView(imageViewHead);
    selectpicImageview.image=[UIImage imageNamed:@"icon_select_pic"];
    
    
    UISegmentedControl *segment=[[UISegmentedControl alloc]initWithItems:@[getString(@"女"),getString(@"男")]];
    [self.view addSubview:segment];
    segment.sd_layout.centerXEqualToView(self.view).topSpaceToView(imageViewHead, 20).heightIs(30).widthIs(100);
    gender=0;
    segment.selectedSegmentIndex=gender;
    [segment addTarget:self action:@selector(genderChanged:) forControlEvents:UIControlEventValueChanged];
    
    edit_phone=[UITextField new];
    [self.view addSubview:edit_phone];
    edit_phone.textColor=[UIColor darkGrayColor];
    edit_phone.sd_layout.topSpaceToView(segment, 30).heightIs(35).widthRatioToView(self.view, 0.85).centerXEqualToView(self.view);
    edit_phone.placeholder=getString(@"请输入手机号码");
    edit_phone.keyboardType = UIKeyboardTypeNumberPad;
    [edit_phone setAutocorrectionType:UITextAutocorrectionTypeNo];//取消键盘联想功能,以免系统输入法上面的一栏联想点击之后会输入到textfield里面,虽然设置里代理,但是这联想内容不走代理!!!
    
    UIView *line_1=[UIView new];
    line_1.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line_1];
    line_1.sd_layout.leftEqualToView(edit_phone).rightEqualToView(edit_phone).heightIs(0.5).topSpaceToView(edit_phone, 0);
    
    edit_nickname=[UITextField new];
    [self.view addSubview:edit_nickname];
    edit_nickname.textColor=[UIColor darkGrayColor];
    edit_nickname.sd_layout.topSpaceToView(line_1, 10).heightRatioToView(edit_phone, 1).widthRatioToView(edit_phone, 1).centerXEqualToView(self.view);
    edit_nickname.placeholder=getString(@"请输入昵称");
    
    UIView *line_2=[UIView new];
    line_2.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line_2];
    line_2.sd_layout.leftEqualToView(edit_nickname).rightEqualToView(edit_nickname).heightIs(0.5).topSpaceToView(edit_nickname, 0);
    
    edit_code=[UITextField new];
    [self.view addSubview:edit_code];
    edit_code.textColor=[UIColor darkGrayColor];
    edit_code.sd_layout.topSpaceToView(line_2, 10).heightRatioToView(edit_phone, 1).widthRatioToView(edit_phone, 1).centerXEqualToView(self.view);
    edit_code.placeholder=getString(@"请输入手机验证码");
    
    UIView *line_3=[UIView new];
    line_3.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line_3];
    line_3.sd_layout.leftEqualToView(edit_nickname).rightEqualToView(edit_code).heightIs(0.5).topSpaceToView(edit_code, 0);
    
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
    edit_pwd.sd_layout.topSpaceToView(line_3, 10).heightRatioToView(edit_phone, 1).widthRatioToView(edit_phone, 1).centerXEqualToView(self.view);
    edit_pwd.placeholder=getString(@"请输入密码");
    edit_pwd.keyboardType = UIKeyboardTypeASCIICapable;
    [edit_pwd setAutocorrectionType:UITextAutocorrectionTypeNo];//取消键盘联想功能,以免系统输入法上面的一栏联想点击之后会输入到textfield里面,虽然设置里代理,但是这联想内容不走代理!!!
    
    
    UIView *line_4=[UIView new];
    line_4.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line_4];
    line_4.sd_layout.leftEqualToView(edit_pwd).rightEqualToView(edit_pwd).heightIs(0.5).topSpaceToView(edit_pwd, 0);
    
    UIButton *btn_submit=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn_submit];
    btn_submit.sd_layout.leftEqualToView(line_4).rightEqualToView(line_4).heightIs(35).topSpaceToView(line_4, 30);
    btn_submit.backgroundColor=Main_blue;
    [btn_submit setTitle:getString(@"提交") forState:UIControlStateNormal];
    [btn_submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_submit addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)genderChanged:(UISegmentedControl*)control{
    gender=control.selectedSegmentIndex;
    if(!selectHeadimage){
        if(gender==0){
            //女
            [imageViewHead sd_setImageWithURL:[NSURL URLWithString:URL_Default_girl] placeholderImage:nil];
        }else{
            [imageViewHead sd_setImageWithURL:[NSURL URLWithString:URL_Default_boy] placeholderImage:nil];
        }
    }
}

-(void)registerAction{
    NSString *phoneNum=edit_phone.text;
    if(![MyUtils isValidPhoneNum:phoneNum]){
        [self showToastDialog:getString(@"请输入正确的手机号码")];
        return;
    }
    NSString *nickname=edit_nickname.text;
    if(![MyUtils isValidString:nickname]){
        [self showToastDialog:getString(@"请输入昵称")];
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
    if(selectHeadimage){
        //选择了头像图片,那么久先获取token,然后上传,上传图片成功之后再注册用户
        [self getUploadToken:phoneNum];
    }else{
        //使用了默认头像
        [self doRegisterWithHeadimageKey:nil];
    }
    
}

-(void)getUploadToken:(NSString*)phoneNum{
    //getQiniuUploadToken
    [MyHttpUtil getUploadTokenByPhoneNum:phoneNum callBack:^(NSDictionary *dic, NSError *error) {
        if(!dic)
            return ;
        
        NSDictionary*data=[dic objectForKey:API_Common_Key_Data];
        
        NSString*token=[data objectForKey:@"token"];
        NSString*fileKey=[data objectForKey:@"fileKey"];
        [self.uploadManager uploadData:UIImagePNGRepresentation(imageViewHead.image) fileKey:fileKey uploadToken:token progress:^(float percent) {
            
        } completion:^(NSError *error, NSString *link, NSData *data, NSInteger index) {
            
            if(error){
                [self showToastDialog:getString(@"注册失败,请重试")];
                return ;
            }
            [self doRegisterWithHeadimageKey:fileKey];
        }];
        
    }];
    
}
-(void)getCodeAction{
    NSString *phoneNum=edit_phone.text;
    if(![MyUtils isValidPhoneNum:phoneNum]){
          [self showToastDialog:getString(@"请输入正确的手机号码")];
        return;
    }
    [self showLodingProgress];
    
    [MyHttpUtil getRegisterCheckCode:phoneNum callBack:^(NSDictionary *dic, NSError *error) {
        NSLog(@"获取到验证码:%@",dic);
        [self stopProgress];
        if(error){
            return ;
        }
        [self showToastDialog:getString(@"验证码已发送，请耐心等待")];
        [self countDown];//倒计时
    }];
}

int countDownTime;
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
    [RegisterVC cancelPreviousPerformRequestsWithTarget:self selector:@selector(doCountDown) object:nil];
}



-(void)selectPicAction{
  UIActionSheet*actionsheet=  [[UIActionSheet alloc]initWithTitle:getString(@"选择图片") delegate:self cancelButtonTitle:getString(@"取消") destructiveButtonTitle:nil otherButtonTitles:getString(@"拍一张"),getString(@"从相册选取"), nil];
    [actionsheet showInView:self.view];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex:%d",buttonIndex);
    if(buttonIndex==0){
        //拍一张
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController*  picker1 = [[UIImagePickerController alloc] init];
            picker1.delegate = self;
            picker1.allowsEditing = YES;
            picker1.sourceType = UIImagePickerControllerSourceTypeCamera;
           
            [self presentViewController:picker1 animated:YES completion:^{}];
     
        }
        
    }else if(buttonIndex==1){
        //从相册选取
        UIImagePickerController *picker1=[UIImagePickerController new];
        
        picker1.view.backgroundColor=[UIColor whiteColor];
        picker1.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
        picker1.delegate=self;
        picker1.allowsEditing = YES;
        {
            [self presentViewController:picker1 animated:YES completion:^{
                picker1.view.backgroundColor=[UIColor whiteColor];
            }];
        }
        
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    imageViewHead.image=info[UIImagePickerControllerEditedImage];
    selectHeadimage=YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)doRegisterWithHeadimageKey:(NSString*) headimageKey{
    [MyHttpUtil registerByPhoneNum:edit_phone.text withPWD:[edit_pwd.text MD5] withNickname:edit_nickname.text widthGender:gender withCheckCode:edit_code.text withHeadimageKey:headimageKey callBack:^(NSDictionary *dic, NSError *error) {
        [self stopProgress];
        if(!dic){
            return;
        }
        [ToastUtils showSuccessDialog:getString(@"注册成功,请重新登录")];
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
