//
//  ECarPlayViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/2/18.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarPlayViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ECarPlayViewController () <AVPlayerViewControllerDelegate>

@property (nonatomic, strong) AVPlayerViewController * playerController;
@property (nonatomic, strong) AVPlayer               * player;
@property (nonatomic, strong) AVAudioSession         * session;
@property (nonatomic, strong) NSString               * urlString;

@end

@implementation ECarPlayViewController

- (instancetype)initWithURLString:(NSString *)url
{
    self = [super init];
    if (self) {
        self.urlString = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createPlayerView];
}

- (void)createPlayerView
{
    self.session = [AVAudioSession sharedInstance];
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:self.urlString]];
    self.playerController = [[AVPlayerViewController alloc] init];
    self.playerController.player = self.player;
    self.playerController.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playerController.delegate = self;
    self.playerController.allowsPictureInPicturePlayback = YES;    // 是否允许双层播放
    self.playerController.showsPlaybackControls = YES;
    self.playerController.view.translatesAutoresizingMaskIntoConstraints = YES;
    self.playerController.view.frame = self.view.bounds;
    [self.view addSubview:self.playerController.view];
    [self addChildViewController:self.playerController];
    [self.playerController willMoveToParentViewController:self];
    [self.parentViewController didMoveToParentViewController:self];
    [self.playerController.player play];
}

#pragma mark - AVPlayerViewControllerDelegate
- (BOOL)playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart:(AVPlayerViewController *)playerViewController {
    return true;
}

@end
