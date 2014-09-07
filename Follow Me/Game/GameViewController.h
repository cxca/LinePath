//
//  GameViewController.h
//  Line Path
//
//  Created by Xavy on 8/19/14.
//  Copyright (c) 2014 Carlos Chaparro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GamePath.h"
#import "PictureCountdownTimer.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
@import GameKit;

@interface GameViewController : UIViewController <UIActionSheetDelegate, UIPopoverControllerDelegate, GKGameCenterControllerDelegate, AVAudioPlayerDelegate>

// A flag indicating whether the Game Center features can be used after a user has been authenticated.
@property (nonatomic) BOOL gameCenterEnabled;

// This property stores the default leaderboard's identifier.
@property (nonatomic, strong) NSString *leaderboardIdentifier;

// The player's score. Its type is int64_t so as to match the expected type by the respective method of GameKit.
@property (nonatomic) int64_t score;

@property (strong, nonatomic) UIButton *okButton;
@property (strong, nonatomic) UIButton *againButton;
@property (nonatomic) BOOL userLives;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) UIPopoverController *controllerPopover;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *gameScoreLabel;
@property (weak, nonatomic) IBOutlet UIView *blockView;

@end
