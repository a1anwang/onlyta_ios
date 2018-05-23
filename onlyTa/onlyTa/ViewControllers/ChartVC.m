//
//  ChartVC.m
//  OnlyTa
//
//  Created by smartwallit on 2018/4/14.
//  Copyright © 2018年 a1anwang. All rights reserved.
//

#import "ChartVC.h"
#import "TALocationRequestMessageCell.h"
#import "TALocationResponeMessageCell.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <SDWebImageManager.h>
#define LocationRequestViewTAG 999
@interface ChartVC ()<RCIMUserInfoDataSource,RCPluginBoardViewDelegate,AMapLocationManagerDelegate>{
    
    AppDelegate *appdelegate;
    AMapLocationManager* locationManager;
    NSString *mTargetId;
}

@end

@implementation ChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    appdelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    mTargetId=[NSString stringWithFormat:@"%ld",appdelegate.userAccount.target_uid];
    
    locationManager = [[AMapLocationManager alloc] init];
    locationManager.delegate = self;
    self.navigationController.navigationBarHidden=NO;
    UINavigationBar *bar = self.navigationController.navigationBar;
    UIImage*    naviBarBgImage=[self createImageWithColor:Main_blue];
    [bar setBackgroundImage:naviBarBgImage forBarMetrics:UIBarMetricsDefault];
    UIImage*   shadowImage=[self createImageWithColor:[UIColor clearColor] widthHeight:0.5];
    [bar setShadowImage:shadowImage];
    self.navigationItem.hidesBackButton=YES;

    [[RongyunEvent getInstance] setCurrentUserInfoUid:[NSString stringWithFormat:@"%ld",appdelegate.userAccount.uid] nickaName:appdelegate.userAccount.nickname headURL:appdelegate.userAccount.headImageURL];
    
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    self.enableUnreadMessageIcon=YES;
    self.enableNewComingMessageIcon=YES;
    
    //修改加号扩展区域,增加 位置请求功能
    [self addLocationRequestView];
    //注册自定义消息cell
    [self registerClass:[TALocationRequestMessageCell class] forMessageClass:[TALocationRequestMessage class]];
    [self registerClass:[TALocationResponeMessageCell class] forMessageClass:[TALocationResponeMessage class]];
    
    
    //设置消息接收监听
    [self setListeners];
}

/**
 用户信息提供者
 */
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    if([userId isEqualToString:mTargetId]){
        [MyHttpUtil getUserinfoWithUid:appdelegate.userAccount.target_uid callBack:^(NSDictionary *dic, NSError *error) {
            if(dic){
                NSDictionary *data=[dic objectForKey:API_Common_Key_Data];
                NSString*nickname=[data objectForKey:@"nickname"];
                NSString*headImageURL=[data objectForKey:@"headImageURL"];
                RCUserInfo *userInfo=[[RCUserInfo alloc]initWithUserId:userId name:nickname portrait:headImageURL];
                completion(userInfo);
            }
        }];

        
    }
   
}



-(void)setTitle:(NSString *)title{
    UILabel *titleLabel         = [[UILabel alloc] initWithFrame:CGRectZero];
 
    titleLabel.textColor        = [UIColor whiteColor];
  
    titleLabel.font             = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.text             = title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}


-(void)addLocationRequestView{
    UIImage *image=[UIImage imageNamed:@"icon_location_ta"];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:image title:getString(@"Ta的位置") tag:999];
    self.chatSessionInputBarControl.pluginBoardView.pluginBoardDelegate=self;
}
-(void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    if(tag==LocationRequestViewTAG){
        NSLog(@"点击了位置请求");
        //发送位置请求命令
        
        double lastRequestTime=[USER_DEFAULTS doubleForKey:KUserDefaults_LastLocationRequestTime];
        double currentTime=[MyUtils currentTimeLong];
        if((currentTime-lastRequestTime)>Location_Request_Interval){
            //点击了 TA的位置,发送一条自定义消息:立马告诉老子你的位置
            NSString*targetId=[NSString stringWithFormat:@"%ld",appdelegate.userAccount.target_uid];
            
            [[RongyunEvent getInstance ] sendLocationRequestMessageTo:targetId block:^(BOOL success) {
                if(success){
                    [USER_DEFAULTS setDouble:[MyUtils currentTimeLong] forKey:KUserDefaults_LastLocationRequestTime];
                    //位置请求发送成功之后,进行一个延时5s判断,如果对方没有任何回应,说明对方app挂掉了,那么这个时候发送一个系统消息告知对方不在线
                   [self startDelayCheck] ;
                }
            }];
        }else{
            
            [ToastUtils showErrorDialog:@"1分钟内只可以请求一次"];
        }
    }
}

-(void)setListeners{
    [[RongyunEvent getInstance] setReceivedMessageBlock:^(RCMessage *message) {
        RCMessageContent *messageContent=message.content;
        NSString *className=NSStringFromClass([messageContent class]);
        NSLog(@" className:%@",className);
        if([className isEqualToString:NSStringFromClass([TALocationRequestMessage class])]){
            NSLog(@" 接收到 位置请求消息");
            long long receivedTime=message.receivedTime;
            long long sentTime=message.sentTime;
            //只有中间时间小于 超时时间才发送位置回复, 避免 退出APP后再次上线收到请求消息自动回复,因为没必要了
            if((receivedTime-sentTime)<Location_Request_OverTime){
                //已开启自动回应,先告知对方收到,同时开始进行定位    //"1"开启自动回应位置   "0"未开启自动回应位置,"3" 不在线
               // RongyunEvent.getInstance().sendLocationResponseMessage(mTargetId, "1", messageSendListener);
                NSString*targetId=[NSString stringWithFormat:@"%ld",appdelegate.userAccount.target_uid];
                dispatch_async(dispatch_get_global_queue(0, 0),^{
                    //进入另一个线程
                   sleep(0.5);
                    [[RongyunEvent getInstance] sendLocationResponseMessageTo:targetId responeType:@"1" block:^(BOOL success) {
                        NSLog(@" 发送 位置回复 :%d",success);
                    }];
                    [self startGetLocation];
                    
                });
            
             
            }
        
        }
    }];
}

-(void)startDelayCheck{
    [ChartVC cancelPreviousPerformRequestsWithTarget:self selector:@selector(doDelay) object:nil];
    [self performSelector:@selector(doDelay) withObject:nil afterDelay:Location_Request_OverTime];
}
-(void)doDelay{
    [self checkTargetOnlineState:0];
}


-(void)startGetLocation{
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //   定位超时时间，最低2s，此处设置为10s
    locationManager.locationTimeout =8;
    //   逆地理请求超时时间，最低2s，此处设置为10s
    locationManager.reGeocodeTimeout = 8;
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        NSLog(@"location:%@", location);
       
        //获取到位置信息,然后发送给对方
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
            NSString*targetId=[NSString stringWithFormat:@"%ld",appdelegate.userAccount.target_uid];
            //先下载缩略图
            SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
            NSURL *imageURL=[NSURL URLWithString:[self getLocationThumbImageURL:location.coordinate]];
            [downloader downloadImageWithURL:imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                NSLog(@"图片下载成功");
                [[RongyunEvent getInstance]  sendLocationMessageTo:targetId location:location.coordinate address:regeocode.formattedAddress thumbImage:image block:^(BOOL success) {
                    
                }];
            }];
           
     
        }
    }];
}

-(NSString*)getLocationThumbImageURL:(CLLocationCoordinate2D)location{
    NSString *str=[NSString stringWithFormat:@"http://restapi.amap.com/v3/staticmap?location=%f,%f&zoom=10&size=400*300&markers=mid,,:%f,%f&key=%@",location.longitude,location.latitude,location.longitude,location.latitude,AmapWebAPI_key];
 
    return str;

}
/*8
checkType 0代表 检测状态同时如果状态为不在线的话,由server 代表对方发送一个单聊消息过来,其他参数暂未定义
*/
-(void)checkTargetOnlineState:(NSInteger)checkType{
    NSString*targetId=[NSString stringWithFormat:@"%ld",appdelegate.userAccount.target_uid];
    
    [MyHttpUtil checkTargetOnlineState:checkType targetId:targetId callBack:^(NSDictionary *dic, NSError *error) {
        NSLog(@"dic:%@",dic);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage*) createImageWithColor: (UIColor*) color
{
    return [self createImageWithColor:color widthHeight:1];
}
- (UIImage*) createImageWithColor: (UIColor*) color widthHeight:(float)height
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
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
