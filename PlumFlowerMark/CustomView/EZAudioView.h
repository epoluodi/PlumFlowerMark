//
//  EZAudioView.h
//  PlumFlowerMark
//
//  Created by 杨晓光 on 2017/3/11.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EZAudioiOS/EZAudio.h>

@interface EZAudioView : UIView<EZAudioPlayerDelegate>
{
    EZAudioPlot *audioplot;
    EZAudioFile *audiofile;
    EZAudioPlayer *_player;
    UIButton *btnPlayAndPause,*btnstop,*btndelete;

}
-(instancetype)initAudioView:(CGRect)Frame;
-(void)updateRecordInfo:(NSString *)uuid;

-(void)viewResume;
-(void)viewPause;
-(void)playStop;
@end
