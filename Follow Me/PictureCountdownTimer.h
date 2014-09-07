//
//  PictureCountdownTimer.h
//  xavyx
//
//  Created by Xavy on 3/12/14.
//  Copyright (c) 2014 Carlos Chaparro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureCountdownTimer : NSObject
{
//     NSTimer *timer;
}

//-(void)updateCounter:(NSTimer *)theTimer;
//-(void)countdownTimer;
- (NSString *)timeRString:(long)secondsLeft;
- (NSString *)timeCounterString:(long)secondsIncrease;
- (NSString *)gameTimeCounterString:(long)secondsIncrease;

@end
