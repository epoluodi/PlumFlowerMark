//
//  EZRecordView.h
//  PlumFlowerMark
//
//  Created by Stereo on 2017/3/10.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EZAudioiOS/EZAudio.h>

@protocol RecordDelegate

-(void)RecordFinish:(NSString *)uuid filepath:(NSString *)filepath;
-(void)RecordCancel;


@end

@interface EZRecordView : UIView<EZMicrophoneDelegate,EZRecorderDelegate,EZAudioPlayerDelegate>
{
    BOOL IsRecording;
    EZMicrophone *microphone;
    EZRecorder *_recorder;
    EZAudioPlotGL *audioplot;
    NSString *uuidfile,*filepath;//录音文件
    NSURL *fileurl;
    UILabel *labtime;

    EZAudioPlayer *_player;
    BOOL isPlaying;
    
 
    

}

@property (weak,nonatomic)NSObject<RecordDelegate>* delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnrecord;

-(void)viewUnload;
@end
