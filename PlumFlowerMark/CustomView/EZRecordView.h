//
//  EZRecordView.h
//  PlumFlowerMark
//
//  Created by Stereo on 2017/3/10.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EZAudioiOS/EZAudioPlotGL.h>
#import <EZAudioiOS/EZMicrophone.h>
#import <EZAudioiOS/EZRecorder.h>
#import <EZAudioiOS/EZAudioPlot.h>
#import <EZAudioiOS/EZAudioPlayer.h>

@interface EZRecordView : UIView<EZMicrophoneDelegate,EZRecorderDelegate,EZAudioPlayerDelegate>
{
    BOOL IsRecording;
    EZMicrophone *microphone;
    EZRecorder *_recorder;
    EZAudioPlotGL *audioplot;
    NSString *uuidfile,*filepath;//录音文件
    NSURL *fileurl;
    UILabel *labtime;
    EZAudioPlot *audioplayer;
    EZAudioPlayer *_player;
    BOOL isPlaying;
    
    UIButton *_btnplayerandpause,*_btnstop;
    

}

@property (weak, nonatomic) IBOutlet UIButton *btnrecord;

-(void)viewUnload;
@end
