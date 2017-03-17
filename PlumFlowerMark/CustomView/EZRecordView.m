//
//  EZRecordView.m
//  PlumFlowerMark
//
//  Created by Stereo on 2017/3/10.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import "EZRecordView.h"
#import <Common/FileCommon.h>

@implementation EZRecordView
@synthesize btnrecord;
@synthesize delegate;
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    uuidfile = [[NSUUID UUID] UUIDString];
    filepath = [[FileCommon getCacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",uuidfile]];
    fileurl = [NSURL URLWithString:filepath];
    audioplot = [[EZAudioPlotGL alloc] init];
    audioplot.frame = CGRectMake(8, 5, self.frame.size.width- 66 -26, self.frame.size.height-10);
    audioplot.backgroundColor = [UIColor colorWithRed:0.141 green:0.141 blue:0.141 alpha:0.15];
    audioplot.color           = [UIColor colorWithRed:0.323 green:0.694 blue:0.993 alpha:1.00];
    audioplot.plotType        = EZPlotTypeBuffer;
    audioplot.shouldFill      = YES;
    audioplot.shouldMirror    = YES;
    audioplot.gain=2;
    [self addSubview:audioplot];
    labtime = [[UILabel alloc] init];
    labtime.frame = CGRectMake(audioplot.frame.size.width-100, 5, 80, 40);
    [audioplot addSubview:labtime];
    labtime.textColor = [UIColor grayColor];
    labtime.textAlignment = NSTextAlignmentRight;

    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
    }
    [session setActive:YES error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
    }
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    if (error)
    {
        NSLog(@"Error overriding output to the speaker: %@", error.localizedDescription);
    }
    IsRecording = NO;
    microphone = [EZMicrophone microphoneWithDelegate:self];
    _player = [EZAudioPlayer audioPlayerWithDelegate:self];
    
    [btnrecord addTarget:self action:@selector(toggleRecording:) forControlEvents:UIControlEventTouchDown];
    [btnrecord addTarget:self action:@selector(toggleFinishRecord) forControlEvents:UIControlEventTouchUpInside];
    [btnrecord addTarget:self action:@selector(cancelRecord) forControlEvents:UIControlEventTouchUpOutside];
    
    isPlaying=NO;
    [self setupNotifications];
    
}

//释放
-(void)viewUnload
{
    [_player pause];
    [microphone stopFetchingAudio];
    [_recorder closeAudioFile];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
    }
   
}

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidChangePlayState:)
                                                 name:EZAudioPlayerDidChangePlayStateNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidReachEndOfFile:)
                                                 name:EZAudioPlayerDidReachEndOfFileNotification
                                               object:_player];
}


//------------------------------------------------------------------------------
#pragma mark - Notifications
//------------------------------------------------------------------------------

- (void)playerDidChangePlayState:(NSNotification *)notification
{

    dispatch_async(dispatch_get_main_queue(), ^{
        EZAudioPlayer *player = [notification object];
        isPlaying = [player isPlaying];
        if (isPlaying)
        {
            _recorder.delegate = nil;
        }
  
    });
}

//------------------------------------------------------------------------------

- (void)playerDidReachEndOfFile:(NSNotification *)notification
{

//    dispatch_async(dispatch_get_main_queue(), ^{
//       
//    });
}




//删除文件
-(void)cancelRecord
{
    [self toggleStopRecord];

    NSFileManager *filemanger = [NSFileManager defaultManager];
    [filemanger removeItemAtPath:filepath error:nil];
    [delegate RecordCancel];
  
}

-(void)toggleFinishRecord
{
        [self toggleStopRecord];
        [delegate RecordFinish:uuidfile filepath:filepath];
}
//停止录音
-(void)toggleStopRecord
{
    [microphone stopFetchingAudio];
    [_recorder closeAudioFile];
    IsRecording= NO;

}
- (void)toggleRecording:(id)sender
{
    //    [self.player pause];
    
    if (IsRecording)
        return;
    
    
    [audioplot clear];
    [microphone startFetchingAudio];
    _recorder = [EZRecorder recorderWithURL:fileurl
                              clientFormat:[microphone audioStreamBasicDescription]
                                  fileType:EZRecorderFileTypeM4A
                                  delegate:self];

    
    IsRecording = YES;

}



#warning Thread Safety
//
// Note that any callback that provides streamed audio data (like streaming
// microphone input) happens on a separate audio thread that should not be
// blocked. When we feed audio data into any of the UI components we need to
// explicity create a GCD block on the main thread to properly get the UI to
// work.
- (void)   microphone:(EZMicrophone *)microphone
     hasAudioReceived:(float **)buffer
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
{
    // Getting audio data as an array of float buffer arrays. What does that
    // mean? Because the audio is coming in as a stereo signal the data is split
    // into a left and right channel. So buffer[0] corresponds to the float* data
    // for the left channel while buffer[1] corresponds to the float* data for
    // the right channel.
    
    //
    // See the Thread Safety warning above, but in a nutshell these callbacks
    // happen on a separate audio thread. We wrap any UI updating in a GCD block
    // on the main thread to avoid blocking that audio flow.
    //
 
    dispatch_async(dispatch_get_main_queue(), ^{
        //
        // All the audio plot needs is the buffer data (float*) and the size.
        // Internally the audio plot will handle all the drawing related code,
        // history management, and freeing its own resources. Hence, one badass
        // line of code gets you a pretty plot :)
        //
        [audioplot updateBuffer:buffer[0]
                                   withBufferSize:bufferSize];
    });
}

//------------------------------------------------------------------------------

- (void)   microphone:(EZMicrophone *)microphone
        hasBufferList:(AudioBufferList *)bufferList
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
{
    //
    // Getting audio data as a buffer list that can be directly fed into the
    // EZRecorder. This is happening on the audio thread - any UI updating needs
    // a GCD main queue block. This will keep appending data to the tail of the
    // audio file.
    //
    if (IsRecording)
    {
        [_recorder appendDataFromBufferList:bufferList
                                 withBufferSize:bufferSize];
    }
}


//------------------------------------------------------------------------------
#pragma mark - EZRecorderDelegate
//------------------------------------------------------------------------------

- (void)recorderDidClose:(EZRecorder *)recorder
{
    recorder.delegate = nil;
}

//------------------------------------------------------------------------------

- (void)recorderUpdatedCurrentTime:(EZRecorder *)recorder
{
//    __weak typeof (self) weakSelf = self;
    NSString *formattedCurrentTime = [recorder formattedCurrentTime];
    dispatch_async(dispatch_get_main_queue(), ^{
        labtime.text = formattedCurrentTime;
    });
}



@end
