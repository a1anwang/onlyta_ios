//
//  TALocationResponeMessageCell.m
//  OnlyTa
//
//  Created by smartwallit on 2018/4/16.
//  Copyright © 2018年 a1anwang. All rights reserved.
//

#import "TALocationResponeMessageCell.h"

@implementation TALocationResponeMessageCell

+(CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight{
    TALocationResponeMessage *message = (TALocationResponeMessage *)model.content;
    CGSize size=[[self class] getMessageContentSize:message];
    
    CGFloat __messagecontentview_height =size.height+extraHeight;
    
    
    return CGSizeMake(collectionViewWidth, __messagecontentview_height);
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)setDataModel:(RCMessageModel *)model{
    [super setDataModel:model];
    TALocationResponeMessage *message=(TALocationResponeMessage*)self.model.content;
    _textLabel.text= message.content;
    CGSize textLabelSize=[[self class] getTextLabelSize:_textLabel.text];
    _textLabel.frame=CGRectMake(10, 5, textLabelSize.width, textLabelSize.height);
    CGSize size=[[self class] getMessageContentSize:message];
    if(self.messageDirection ==MessageDirection_SEND){
        //消息方向,是自己发送的
        _textLabel.textColor=[UIColor whiteColor];
        self.messageContentView.backgroundColor=Main_blue;
        
        
        self.messageContentView.frame=CGRectMake( ScreenWidth-10- [RCIM sharedRCIM].globalMessagePortraitSize.width-6- size.width, self.messageContentView.frame.origin.y, size.width, size.height);
    }else{
        _textLabel.textColor=[UIColor darkTextColor];
        self.messageContentView.backgroundColor=UIColorFromHex(0xcccccc);
    self.messageContentView.frame=CGRectMake(self.messageContentView.frame.origin.x ,self.messageContentView.frame.origin.y, size.width, size.height);
    }

    
    
    self.messageContentView.layer.cornerRadius=10;
}
- (void)initialize {
    _textLabel=[UILabel new];
    _textLabel.numberOfLines=0;
    _textLabel.font=[UIFont systemFontOfSize:14];
    [self.messageContentView addSubview:_textLabel];
}



+(CGSize)getTextLabelSize:(NSString*)str{
    
    float maxWidth = [UIScreen mainScreen].bounds.size.width -
    (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 - 35;
    
    CGRect textRect = [str
                       boundingRectWithSize:CGSizeMake(maxWidth, 8000)
                       options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |
                                NSStringDrawingUsesFontLeading)
                       attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}
                       context:nil];
    
    return CGSizeMake(textRect.size.width + 5, textRect.size.height + 5);
}

+(CGSize)getMessageContentSize:(TALocationResponeMessage *)message {
    CGSize textsize=[[self class] getTextLabelSize:message.content];
    CGSize size=CGSizeMake( textsize.width+20, textsize.height+10);
    
    return size;
}

@end
