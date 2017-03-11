//
//  EZAudioView.m
//  PlumFlowerMark
//
//  Created by 杨晓光 on 2017/3/11.
//  Copyright © 2017年 杨晓光. All rights reserved.
//

#import "EZAudioView.h"
#import <Common/FileCommon.h>

@implementation EZAudioView

-(instancetype)initAudioView:(CGRect)Frame
{
    self =[super init];
    self.frame = Frame;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
    }
    [session setActive:YES error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
    }
    
    
    audioplot = [[EZAudioPlot alloc] init];
    audioplot.backgroundColor = [UIColor clearColor];
    audioplot.color = [UIColor greenColor];
    //
    // Plot type
    //
    audioplot.plotType = EZPlotTypeBuffer;
    
    //
    // Fill
    //
    audioplot.shouldFill = YES;
    
    //
    // Mirror
    //
    audioplot.shouldMirror = YES;
    audioplot.gain=2;
    //
    // No need to optimze for realtime
    //
    audioplot.shouldOptimizeForRealtimePlot = NO;
    
    audioplot.frame = CGRectMake(35, 0, Frame.size.width-150, Frame.size.height);
    [self addSubview:audioplot];
    
    btnPlayAndPause = [[UIButton alloc] init];
    btnstop = [[UIButton alloc] init];
    btndelete = [[UIButton alloc] init];
    
    [btnPlayAndPause addTarget:self action:@selector(clickPlay) forControlEvents:UIControlEventTouchUpInside];
    [btnstop addTarget:self action:@selector(clickStop) forControlEvents:UIControlEventTouchUpInside];
    
    

    
    
    btnPlayAndPause.frame = CGRectMake(Frame.size.width-80, Frame.size.height /2 -10, 20, 20);
    [btnPlayAndPause setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    btnPlayAndPause.userInteractionEnabled=YES;
    [self addSubview:btnPlayAndPause];
    
    
    
    btnstop.frame = CGRectMake(Frame.size.width-45, Frame.size.height /2 -10, 20, 20);
    [btnstop setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    btnstop.userInteractionEnabled=YES;
    [self addSubview:btnstop];
    
    _player = [EZAudioPlayer audioPlayerWithDelegate:self];
    _player.shouldLoop = NO;
    return self;
}
-(void)updateRecordInfo:(NSString *)uuid
{
    
    NSString *filepath = [[FileCommon getCacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",uuid]];
    NSURL *fileurl = [NSURL URLWithString:filepath];
    audiofile = [EZAudioFile audioFileWithURL:fileurl];
    [_player setAudioFile:audiofile];
    _player.volume=0.9;
    [self setupNotifications];
  
    [audiofile getWaveformDataWithCompletionBlock:^(float **waveformData,
                                                         int length)
     {
         [audioplot updateBuffer:waveformData[0]
                           withBufferSize:length];
     }];
}

-(void)clickPlay
{
    if ([_player isPlaying])
    {
        [_player pause];
        NSLog(@"暂停");
        [btnPlayAndPause setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    else
    {
        [_player play];
        [btnPlayAndPause setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}

-(void)clickStop
{
    
    [_player pause];
    [btnPlayAndPause setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_player seekToFrame:0];
    [audioplot clear];
    [audiofile getWaveformDataWithCompletionBlock:^(float **waveformData,
                                                    int length)
     {
         [audioplot updateBuffer:waveformData[0]
                  withBufferSize:length];
     }];
}



- (void)setupNotifications
{

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioPlayerDidChangePlayState:)
                                                 name:EZAudioPlayerDidChangePlayStateNotification
                                               object:_player];
}

- (void)audioPlayerDidChangePlayState:(NSNotification *)notification
{
    EZAudioPlayer *player = [notification object];
    NSLog(@"Player change play state, isPlaying: %i", [player isPlaying]);
    if ([_player isPlaying])
    {
   
        NSLog(@"暂停");
        [btnPlayAndPause setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
    else
    {
       
        [btnPlayAndPause setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [audioplot clear];
        [audiofile getWaveformDataWithCompletionBlock:^(float **waveformData,
                                                        int length)
         {
             [audioplot updateBuffer:waveformData[0]
                      withBufferSize:length];
         }];
    }
}







- (void)  audioPlayer:(EZAudioPlayer *)audioPlayer
          playedAudio:(float **)buffer
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
          inAudioFile:(EZAudioFile *)audioFile
{
 
    dispatch_async(dispatch_get_main_queue(), ^{
        [audioplot updateBuffer:buffer[0]
                          withBufferSize:bufferSize];
    });
}

//------------------------------------------------------------------------------


-(void)playStop
{
    if (_player)
        [_player pause];
}


-(void)viewPause
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [_player pause];
    [session setActive:NO error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
    }
}

-(void)viewResume
{

    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
    }
    [session setActive:YES error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
