//
//  TalkListViewController.m
//  OnlyTa
//
//  Created by smartwallit on 2018/2/3.
//  Copyright © 2018年 a1anwang. All rights reserved.
//

#import "TalkListViewController.h"

@interface TalkListViewController ()

@end

@implementation TalkListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@" viewDidLoad");
    self.view.backgroundColor=[UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
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
