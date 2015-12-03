//
//  ViewController.m
//  StopwatchApp
//
//  Created by 酒井紀明 on 2015/12/02.
//  Copyright © 2015年 noriaki.sakai. All rights reserved.
//

#import "ViewController.h"

static NSString * const kStartButtonTitle = @"スタート";
static NSString * const kStopButtonTitle = @"ストップ";
@interface ViewController () {
    // タイマー時間を表示するためのラベルインスタンスを格納するための変数
    UILabel *_timeLabel;
    
    // タイマーインスタンスを格納するための変数
    NSTimer *_timer;
    
    UIButton *_startStopButton;
    
    UIButton *_resetButton;
    
    NSTimeInterval _startTime;
    
    double _elapsedTimeInSecond;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // ラベルとイメージビューを作成するメソッドを呼び出す
    [self setupParts];

    // 経過時間とその表示を初期化
    _elapsedTimeInSecond = 0.0;
    _timeLabel.text = [self getElapsedTimeString: _elapsedTimeInSecond ];
}

-(void)exchangeStartStop:(id)sender{
    
    NSString *title = _startStopButton.currentTitle;
    if ([title isEqualToString:kStartButtonTitle]) {
        // 表示をストップに変更.
        [_startStopButton setTitle:kStopButtonTitle forState:UIControlStateNormal];
        
        //リセットボタン表示を消す
        _resetButton.hidden = YES;
        _resetButton.enabled = NO; // 利用不可に設定
        
        // ストップウォッチ開始
        [self startTimer];
    } else {
        [_startStopButton setTitle:kStartButtonTitle forState:UIControlStateNormal];

        //リセットボタンを表示する
        _resetButton.hidden = NO;
        _resetButton.enabled = YES;

        // ストップウォッチ停止
        [self stopTimer];
    }
}

-(void) startTimer{
    if (_timer == nil || [_timer isValid]){
        // タイマーインスタンスを作成
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(tick:)
                                               userInfo:nil repeats:YES];
    }
    
    // リセットせずにスタートとストップを繰り返した時のために、
    // これまでの経過時間を予め引いておく
    _startTime = [NSDate timeIntervalSinceReferenceDate] - _elapsedTimeInSecond;

}

-(void) stopTimer{
    if (_timer != nil){
        [_timer invalidate];
        _timer = nil;
    }
    
    _elapsedTimeInSecond = [NSDate timeIntervalSinceReferenceDate] - _startTime;
    
}

-(void)resetTimer:(id)sender{
    if (_timer != nil){
        [_timer invalidate];
        _timer = nil;
    }
    _elapsedTimeInSecond = 0.0;
    _timeLabel.text = [self getElapsedTimeString: _elapsedTimeInSecond ];
    
}


-(void)tick:(NSTimer*)timer{
    _elapsedTimeInSecond = [NSDate timeIntervalSinceReferenceDate] - _startTime;
    _timeLabel.text = [self getElapsedTimeString: _elapsedTimeInSecond ];
}


-(NSString*)getElapsedTimeString:(double)elapsedTime{
    
    NSInteger minutes = fmod((elapsedTime / 60), 60);
    NSInteger seconds = fmod(elapsedTime, 60);;
    NSString *ret = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    
    return ret;
}

-(void)setupParts{
    
    
    // ラベルを作成
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    
    // ラベルの位置を中心で設定
    _timeLabel.center = CGPointMake(160, 284);
    
    // ラベルに表示するフォントと文字サイズの設定
    _timeLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:48];
    
    // ラベルの文字寄せを設定
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    
    // ラベルを画面に貼付ける
    [self.view addSubview:_timeLabel];
    
    
    // ボタンの作成
    _startStopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    // ボタンの位置を設定
    _startStopButton.frame = CGRectMake(0, 0, 100, 50);
    _startStopButton.center = CGPointMake(160, 400);
    
    // ボタンのタイトルを設定
    [_startStopButton setTitle:kStartButtonTitle forState:UIControlStateNormal];
    
    // ボタンを押したときに呼ばれるメソッドを設定
    [_startStopButton addTarget:self action:@selector(exchangeStartStop:)
     forControlEvents:UIControlEventTouchUpInside];
    
    // ボタンを画面に貼付ける
    [self.view addSubview:_startStopButton];

    // リセットボタンの作成
    _resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _resetButton.frame = CGRectMake(0, 0, 100, 50);
    _resetButton.center = CGPointMake(160, 450);
    [_resetButton setTitle:@"リセット" forState:UIControlStateNormal];
    [_resetButton addTarget:self action:@selector(resetTimer:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_resetButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
