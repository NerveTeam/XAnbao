//
//  XABRecordCell.m
//  XAnBao
//
//  Created by Minlay on 17/3/27.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABRecordCell.h"
#import "UIButton+Extention.h"
#import "RecorderManager.h"
#import "PlayerManager.h"

@interface XABRecordCell ()<RecordingDelegate, PlayingDelegate>
@property(nonatomic,strong)UIButton *recordBtn;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, copy) NSString *recordFilename;
@property(nonatomic, strong)UIButton *deleteBtn;
@end
static int Record = 1; // 录音
static int Play = 2;   // 播放
static int playing = 0;
static int recording = 0;
@implementation XABRecordCell


- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)handelTapEvent {
    if (self.recordBtn.tag == Record) {
        [self record];
    }else if (self.recordBtn.tag == Play) {
        [self playRecord];
    }
}

- (void)record {
    if (playing) {
        return;
    }
    if (!recording) {
        recording = 1;
        self.isRecording = YES;
        [RecorderManager sharedManager].delegate = self;
        [[RecorderManager sharedManager] startRecording];
    }
    else {
        recording = 0;
        self.isRecording = NO;
        [[RecorderManager sharedManager] stopRecording];
    }
}

- (void)playRecord {
    if (recording) {
        return;
    }
    if (!playing) {
        [PlayerManager sharedManager].delegate = nil;
        playing = 1;
        self.isPlaying = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[PlayerManager sharedManager] playAudioWithFileName:self.recordFilename delegate:self];
        });
    }
    else if(self.isPlaying){
        playing = 0;
        self.isPlaying = NO;
        [[PlayerManager sharedManager] stopPlaying];
    }
}


- (void)recordingFinishedWithFileName:(NSString *)filePath time:(NSTimeInterval)interval {
    self.isRecording = NO;
    recording = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_delegate respondsToSelector:@selector(recordingDidFinish:)]) {
            [_delegate recordingDidFinish:filePath];
        }
    });
}

- (void)recordingTimeout {
    self.isRecording = NO;
    recording = 0;
}

- (void)recordingStopped {
    self.isRecording = NO;
    recording = 0;
}

- (void)recordingFailed:(NSString *)failureInfoString {
    self.isRecording = NO;
    recording = 0;
}

- (void)levelMeterChanged:(float)levelMeter {
    //    self.levelMeter.progress = levelMeter;
}

- (void)playingStoped {
    self.isPlaying = NO;
    playing = 0;
//    [[PlayerManager sharedManager] stopPlaying];
}

- (void)stopRecording {
    if (recording) {
        self.isRecording = NO;
        recording = 0;
        [[RecorderManager sharedManager] stopRecording];
    }
    //    self.progressView.progress = 0.00001f;
}
- (void)stopPlaying {
    if (playing) {
        playing = 0;
        self.isPlaying = NO;
        [[PlayerManager sharedManager] stopPlaying];
    }
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isRecording"]) {
        [self.recordBtn setTitle:(self.isRecording ? @"停止录音" : @"开始录音") forState:UIControlStateNormal];
    }
    else if ([keyPath isEqualToString:@"isPlaying"]) {
        [self.recordBtn setTitle:(self.isPlaying ? @"停止播放" : @"开始播放") forState:UIControlStateNormal];
    }
}

- (void)deleteRecord {
    if ([_delegate respondsToSelector:@selector(deleteRecord:)]) {
        [_delegate deleteRecord:self];
    }
}
#pragma mark - Recording & Playing Delegate



- (void)setModel:(id)model {
    if ([model isEqualToString:@"add"]) {
        self.recordBtn.tag = Record;
        self.deleteBtn.hidden = YES;
        [self.recordBtn setTitle:@"开始录音" forState:UIControlStateNormal];
    }else {
        self.recordBtn.tag = Play;
        self.deleteBtn.hidden = NO;
        self.recordFilename = model;
        [self.recordBtn setTitle:@"开始播放" forState:UIControlStateNormal];
    }
}

- (void)setup {
    playing = 0;
    recording = 0;
    [self.contentView addSubview:self.recordBtn];
    [self.contentView addSubview:self.deleteBtn];
    [self addObserver:self forKeyPath:@"isRecording" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"isPlaying" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)layoutSubviews {
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).offset(10);
    }];
    [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.recordBtn);
    }];
}

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithTitle:@"开始录音" fontSize:15 titleColor:ThemeColor];
        _recordBtn.layer.cornerRadius = 5;
        _recordBtn.clipsToBounds = YES;
        _recordBtn.layer.borderWidth = 0.5;
        _recordBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_recordBtn addTarget:self action:@selector(handelTapEvent) forControlEvents:UIControlEventTouchUpInside];
        [_recordBtn sizeToFit];
    }
    return _recordBtn;
}
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithImageNormal:@"content_btn_del" imageHighlighted:@"content_btn_del"];
        [_deleteBtn addTarget:self action:@selector(deleteRecord) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
- (void)dealloc {
    [self stopRecording];
    [self stopPlaying];
    [self removeObserver:self forKeyPath:@"isRecording"];
    [self removeObserver:self forKeyPath:@"isPlaying"];
    [RecorderManager sharedManager].delegate = nil;
    [PlayerManager sharedManager].delegate = nil;
}

@end
