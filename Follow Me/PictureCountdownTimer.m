//
//  PictureCountdownTimer.m
//  xavyx
//
//  Created by Xavy on 3/12/14.
//  Copyright (c) 2014 Carlos Chaparro. All rights reserved.
//

#import "PictureCountdownTimer.h"

@implementation PictureCountdownTimer
long hours, minutes, seconds, days;
long secondsLeft;

//- (void)updateCounter:(NSTimer *)theTimer {
//    NSString *result;
//    
//    if(secondsLeft > 0 ){
//        
//        if(secondsLeft> 86400)
//        {
//            secondsLeft -- ;
//            days = secondsLeft /86400;
//            hours = secondsLeft / 3600;
//            minutes = (secondsLeft % 3600) / 60;
//            seconds = (secondsLeft %3600) % 60;
//            result = [NSString stringWithFormat:@"%02d:%02d:%02d",days, hours, minutes];
//        }
//        else if(secondsLeft >3600)
//        {
//            secondsLeft -- ;
//            hours = secondsLeft / 3600;
//            minutes = (secondsLeft % 3600) / 60;
//            seconds = (secondsLeft %3600) % 60;
//            result = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
//        }
//        else if(secondsLeft > 60)
//        {
//            secondsLeft -- ;
//            hours = secondsLeft / 3600;
//            minutes = (secondsLeft % 3600) / 60;
//            seconds = (secondsLeft %3600) % 60;
//            result = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
//        }
//        else
//        {
//            secondsLeft -- ;
//            hours = secondsLeft / 3600;
//            minutes = (secondsLeft % 3600) / 60;
//            seconds = (secondsLeft %3600) % 60;
//            result = [NSString stringWithFormat:@"%02d", seconds];
//        }
//        
//        
//
////        myCounterLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
//    }
//    else{
//        result = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
//        secondsLeft = 0;
//    }
//}
//
//-(void)countdownTimer{
//    
//    secondsLeft = hours = minutes = seconds = 0;
//    if([timer isValid])
//    {
//        //        [timer release];
//    }
//    //    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
////    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
//    //    [pool release];
//}

- (NSString *)timeRString:(long)secondsLeft {
    NSString *result;
    
//    NSDate *now = [NSDate date];
//    NSTimeInterval timaInterval = secondsLeft;
//    NSDate *dueDate = [NSDate dateWithTimeIntervalSinceNow:timaInterval];
//    NSTimeInterval secondsLeft2 = [dueDate timeIntervalSinceDate:now];
    // divide by 60, 3600, etc to make a pretty string with colons
    // just to get things going, for now, do something simple
    if(secondsLeft > 0 ){
        
        if(secondsLeft> 86400)
        {
            secondsLeft -- ;
            days = secondsLeft /86400;
            hours = secondsLeft / 3600 % 24;
            minutes = (secondsLeft % 3600) / 60;
            seconds = (secondsLeft %3600) % 60;
            if(days > 99)
                result = [NSString stringWithFormat:@"%03ldd %02ld:%02ld:%02ld",days, hours, minutes, seconds];
            else if (days >9)
                result = [NSString stringWithFormat:@"%02ldd %02ld:%02ld:%02ld",days, hours, minutes, seconds];
            else
                result = [NSString stringWithFormat:@"%01ldd %02ld:%02ld:%02ld",days, hours, minutes, seconds];


        }
        else if(secondsLeft >3600)
        {
            secondsLeft -- ;
            hours = secondsLeft / 3600;
            minutes = (secondsLeft % 3600) / 60;
            seconds = (secondsLeft %3600) % 60;
            result = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
        }
        else if(secondsLeft > 60)
        {
            secondsLeft-- ;
            hours = secondsLeft / 3600;
            minutes = (secondsLeft % 3600) / 60;
            seconds = (secondsLeft %3600) % 60;
            result = [NSString stringWithFormat:@"00:%02ld:%02ld", minutes, seconds];
        }
        else
        {
            secondsLeft -- ;
            hours = secondsLeft / 3600;
            minutes = (secondsLeft % 3600) / 60;
            seconds = (secondsLeft %3600) % 60;
            result = [NSString stringWithFormat:@"00:00:%02ld", seconds];
        }
        
        
        
        //        myCounterLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    }
    else{
        result = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
        secondsLeft = 0;
    }
    
//    NSString *answer = [NSString stringWithFormat:@"%f", secondsLeft2];
    return result;
}

- (NSString *)timeCounterString:(long)secondsIncrease
{
    NSString *result;
    
    //    NSDate *now = [NSDate date];
    //    NSTimeInterval timaInterval = secondsLeft;
    //    NSDate *dueDate = [NSDate dateWithTimeIntervalSinceNow:timaInterval];
    //    NSTimeInterval secondsLeft2 = [dueDate timeIntervalSinceDate:now];
    // divide by 60, 3600, etc to make a pretty string with colons
    // just to get things going, for now, do something simple
    if(secondsIncrease > 0 ){
        
        if(secondsIncrease> 86400)
        {
            secondsIncrease ++ ;
            days = secondsIncrease /86400;
            if(days > 99)
                result = [NSString stringWithFormat:@"%03ldd",days];
            else if (days >9)
                result = [NSString stringWithFormat:@"%02ldd",days];
            else
                result = [NSString stringWithFormat:@"%01ldd",days ];
            
            
        }
        else if(secondsIncrease >3600)
        {
            secondsIncrease ++ ;
            hours = secondsIncrease / 3600;
            if(hours >9)
                result = [NSString stringWithFormat:@"%02ldh", hours];
            else
                result = [NSString stringWithFormat:@"%01ldh", hours];

        }
        else if(secondsIncrease > 60)
        {
            secondsIncrease++;
            minutes = (secondsIncrease % 3600) / 60;
            if(minutes >9)
                result = [NSString stringWithFormat:@"%02ldm", minutes];
            else
                result = [NSString stringWithFormat:@"%01ldm", minutes];

        }
        else
        {
            secondsIncrease ++ ;
            seconds = (secondsIncrease %3600) % 60;
            result = NSLocalizedString(@"Just now", nil);
            /*
            if(seconds >9)
                result = [NSString stringWithFormat:@"%02lds", seconds];
            else
                result = [NSString stringWithFormat:@"%01lds", seconds];
             */

        }
        
        
        
    }
    else{
//        result = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
//        secondsLeft = 0;
    }
    
    return result;
}

- (NSString *)gameTimeCounterString:(long)secondsIncrease
{
    NSString *result;
    if(secondsIncrease >= 3600)
    {
        hours = secondsIncrease / 3600;
        minutes = (secondsIncrease % 3600) / 60;
        seconds = (secondsIncrease %3600) % 60;
        result = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
    }
    else
    {
        minutes = (secondsIncrease % 3600) / 60;
        seconds = (secondsIncrease %3600) % 60;
        result = [NSString stringWithFormat:@"%02ld:%02ld", minutes, seconds];
    }
    
    return result;
}

@end
