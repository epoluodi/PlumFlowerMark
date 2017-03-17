//
//  TextViewController.h
//  PlumFlowerMark
//
//  Created by Stereo on 2017/3/14.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextViewInputDelegate

-(void)FinishInput:(NSString*)txt;

@end

@interface TextViewController : UIViewController


@property (weak, nonatomic) IBOutlet UINavigationItem *navtitle;
@property (weak, nonatomic) IBOutlet UITextView *txtmemo;
@property (weak,nonatomic) NSObject<TextViewInputDelegate> *delegate;
@end
