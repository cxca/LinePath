//
//  GameViewController.m
//  Line Path
//
//  Created by Xavy on 8/19/14.
//  Copyright (c) 2014 Carlos Chaparro. All rights reserved.
//

#import "GameViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GameViewController ()
{
    NSTimer * timer;
    NSInteger theTime;
    
    AppDelegate *appDelegate;
    NSInteger completedCount;
    AVAudioPlayer* backgroundAudio;
    PictureCountdownTimer *myAction;
    SystemSoundID pointsSound, manyPointsSound, bell3Sound,bell2Sound,bell1Sound,missedSound;
    
    GamePath *gamePath;
    NSInteger oldScore;
    NSInteger timePlayed;
    
    UIView *bgnView;
    BOOL startCounting;
    CAShapeLayer *bezier;
    
    NSInteger gamePoints;
    
    NSString *scoreStr;
    BOOL launch;
}
@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    _leaderboardIdentifier = appDelegate.leaderboardIdentifier;
    appDelegate.isPlaying = YES;
    appDelegate.score = 0;
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    
    self.view.backgroundColor = [UIColor whiteColor];
    
    myAction = [[PictureCountdownTimer alloc]init];

    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
    _scoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Score: %lld", nil),_score];

    _gameScoreLabel.alpha = 0.0;
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background" ofType:@"m4a"];
    backgroundAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    backgroundAudio.delegate = self;
    backgroundAudio.volume = 0.3;
    backgroundAudio.numberOfLoops = INFINITY;
    
    
    //sound
    NSURL *soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bell1" ofType:@"m4a"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(soundURL), &bell1Sound);
    
    NSURL *soundURL2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bell2" ofType:@"m4a"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(soundURL2), &bell2Sound);
    
    NSURL *soundURL3 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bell3" ofType:@"m4a"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(soundURL3), &bell3Sound);

    
    NSURL *soundURL4 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"points" ofType:@"m4a"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(soundURL4), &pointsSound);
    
    NSURL *soundURL5 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"manyPoints" ofType:@"m4a"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(soundURL5), &manyPointsSound);
    
    NSURL *soundURL6 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"missed" ofType:@"m4a"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(soundURL6), &missedSound);
    

    [backgroundAudio play];


}

-(void)viewDidDisappear:(BOOL)animated
{
    [backgroundAudio stop];
    backgroundAudio = nil;
    [timer invalidate];
    timer = nil;
    [bgnView removeFromSuperview];
    
    if(_score > 0)
    {
        [self saveScore];
        [self reportScore];
    }
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)viewDidAppear:(BOOL)animated
{
    if(!launch)
    {
        launch = YES;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{

                startCounting = NO;
                [self drawBezierAnimate:YES];
                
            });
        });
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawBezierAnimate:(BOOL)animate
{
    _timeLabel.hidden = YES;
    UIBezierPath *bezierPath = [self bezierPath];

    gamePath = [[GamePath alloc]init];

     bezier = [[CAShapeLayer alloc] init];
    
    

    CGPathRef myPath = bezierPath.CGPath;
    NSMutableArray *bezierPoints = [NSMutableArray array];
    CGPathApply(myPath, (__bridge void *)(bezierPoints), MyCGPathApplierFunc);
    NSLog(@"Path %@",bezierPath);
    theTime = bezierPoints.count/2;
    _timeLabel.text = [NSString stringWithFormat:@"%ld",(long)theTime];

    
    bezier.path          = bezierPath.CGPath;
    bezier.strokeColor   = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
    bezier.fillColor     = [UIColor clearColor].CGColor;
    bezier.lineWidth     = 15.0;
    bezier.strokeStart   = 0.0;
    bezier.strokeEnd     = 1.0;

    [self.view.layer addSublayer:bezier];
    [self.view addSubview:gamePath];
    [self.view bringSubviewToFront:_blockView];
  
    if (animate)
    {
        [CATransaction begin]; {
            [CATransaction setCompletionBlock:^{
                
                _blockView.hidden = YES;
                gamePath.mainView = self.view;
                startCounting = YES;
                _timeLabel.hidden = NO;
                AudioServicesPlaySystemSound(bell1Sound);
    
        }];
        CABasicAnimation *animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animateStrokeEnd.duration  = 1.0;
        animateStrokeEnd.fromValue = [NSNumber numberWithFloat:0.0f];
        animateStrokeEnd.toValue   = [NSNumber numberWithFloat:1.0f];
        [bezier addAnimation:animateStrokeEnd forKey:@"strokeEndAnimation"];
        } [CATransaction commit];
    }
    
    

}
void MyCGPathApplierFunc (void *info, const CGPathElement *element) {
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    
    CGPoint *points = element->points;
    CGPathElementType type = element->type;
    
    switch(type) {
        case kCGPathElementMoveToPoint: // contains 1 point
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            break;
            
        case kCGPathElementAddLineToPoint: // contains 1 point
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            break;
            
        case kCGPathElementAddQuadCurveToPoint: // contains 2 points
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
            break;
            
        case kCGPathElementAddCurveToPoint: // contains 3 points
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[2]]];
            break;
            
        case kCGPathElementCloseSubpath: // contains no point
            break;
    }
}
- (UIBezierPath *)bezierPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point;
    
    CGFloat x,y;
    
    x = arc4random() % (int)(self.view.frame.size.width - 20);
    
    y = arc4random() % (int)(self.view.frame.size.height-130);
    
    point = CGPointMake(x+10, y+84);
    
    [path moveToPoint:point];

    int numberOfPoints = arc4random() %3;
    numberOfPoints+=2;
    
    for(int i = 0; i<numberOfPoints;i++)
    {
        x = arc4random() % (int)(self.view.frame.size.width - 20);
        
        y = arc4random() % (int)(self.view.frame.size.height-130);
        
        point = CGPointMake(x+10, y+84);
        [path addLineToPoint:point];

    }
    
    return path;
}

#pragma mark Game Center
-(void)authenticateLocalPlayer{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                appDelegate._gameCenterEnabled = YES;
                
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            
            else{
                appDelegate._gameCenterEnabled = NO;
            }
        }
    };
}

-(void)reportScore{
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderboardIdentifier];
    score.value = _score;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    [self presentViewController:gcViewController animated:YES completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)achievements
{
    NSString *achievementIdentifier;
    float progressPercentage = 0.0;
    BOOL progressInLevelAchievement = NO;
    
    GKAchievement *levelAchievement = nil;
    
    if(appDelegate._gameCenterEnabled)
    {

        if(_score >=1000)
        {
            if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults]
                                        objectForKey:@"1000Points"]])
            {
                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"1000Points"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //Popover
                [self achievementPopover:@"1000 Points"];
                progressPercentage = _score/1000*100;
                //update achievement
                achievementIdentifier = @"ACHIEVEMENT_ID";
                progressInLevelAchievement = YES;
            }
        }

        if(_score >= 3000)
        {
            if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults]
                                        objectForKey:@"3000Points"]])
            {
                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"3000Points"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //Popover
                [self achievementPopover:@"3000 Points"];
                progressPercentage = _score/3000*100;
                //update achievement
                achievementIdentifier = @"ACHIEVEMENT_ID";
                progressInLevelAchievement = YES;
            }
        }
        
        
        if (progressInLevelAchievement) {
            levelAchievement = [[GKAchievement alloc] initWithIdentifier:achievementIdentifier];
            levelAchievement.percentComplete = progressPercentage;
            
            [GKAchievement reportAchievements:@[levelAchievement] withCompletionHandler:^(NSError *error) {
                if (error != nil) {
                    NSLog(@"%@", [error localizedDescription]);
                }
            }];
        }
        
    
    
    }
}

-(void)achievementPopover:(NSString*)str
{
    if(appDelegate._gameCenterEnabled)
    {
        AudioServicesPlaySystemSound(manyPointsSound);
        
        CGRect viewFrame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-125, -55, 250, 55);
        
        //Popover view
        UIView *overlayPopover = [[UIView alloc]initWithFrame:viewFrame];//CGRectMake([[UIScreen mainScreen] bounds].size.width/2-100, -200, 200, 100)];
        overlayPopover.backgroundColor = [UIColor whiteColor];
        [overlayPopover.layer setMasksToBounds:YES];
        [overlayPopover.layer setCornerRadius:0];
        // You can even add a border
        [overlayPopover.layer setBorderWidth:1.0f];
        overlayPopover.layer.borderColor = [[UIColor greenColor]CGColor];
        
        //Title label
        UILabel *viewLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 40)];
        viewLabel.text = NSLocalizedString(@"Achievement Earned", nil);
        
        viewLabel.textAlignment = NSTextAlignmentCenter;
        viewLabel.numberOfLines = 0;
        [viewLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
        
        UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, 240, 30)];
        
        //Message Label
        messageLabel.text = str;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        [messageLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        
        //Image left
        UIImageView *imageViewPopoverLeft = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
        imageViewPopoverLeft.image = [UIImage imageNamed:@"GameCenterButton"];
        
        [overlayPopover addSubview:imageViewPopoverLeft];
        [overlayPopover addSubview:messageLabel];
        [overlayPopover addSubview:viewLabel];
        [self.navigationController.view.window addSubview:overlayPopover];
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             CGRect viewFrame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-125, 0, 250, 55);
                             overlayPopover.frame = viewFrame;
                             
                         }
                         completion:^(BOOL finished){
                             
                             [UIView animateWithDuration:0.25
                                                   delay:4.0 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  overlayPopover.alpha = 1.0;
                                                  CGRect viewFrame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-125, -55, 250, 55);
                                                  overlayPopover.frame = viewFrame;
                                                  
                                              }
                                              completion:^(BOOL finished){
                                                  [overlayPopover removeFromSuperview];
                                              }];
                             
                         }];
    }
}

#pragma mark Save
-(void)saveScore
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]init];//appDelegate.managedObjectContext;
    
    //    [context setPersistentStoreCoordinator:appDelegate.persistentStoreCoordinator];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:context];
    
    
    //Add to DB
    NSManagedObject *newScore = [[NSManagedObject alloc]initWithEntity:entityDesc insertIntoManagedObjectContext:context];
    //Score
    NSArray *strArray =  [_scoreLabel.text componentsSeparatedByString:@" "];
    scoreStr = strArray[1];
    
//    NSString *scoreToSave = [self encrypt:scoreStr];

    
    //Timer
//    NSString *timeToSave = [self encrypt:[NSString stringWithFormat:@"%li",(long)timePlayed ]];
    
//    [newScore setValue:scoreToSave forKey:@"score"];
//    [newScore setValue:timeToSave forKey:@"time"];
 
    NSError *error;
    [context save:&error];
}


#pragma mark Timer
- (void)onTimer {
//    NSLog(@"Timer");
    
    if(theTime>0 && startCounting)
    {
        theTime--;
        
        _timeLabel.text = [NSString stringWithFormat:@"%ld",(long)theTime];
        
        // Create the keyframe animation object
        CAKeyframeAnimation *scaleAnimation =
        [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        
        // Set the animation's delegate to self so that we can add callbacks if we want
        scaleAnimation.delegate = self;
        
        // Create the transform; we'll scale x and y by 1.5, leaving z alone
        // since this is a 2D animation.
        CATransform3D transform = CATransform3DMakeScale(1.5, 1.5, 1); // Scale in x and y
        
        // Add the keyframes.  Note we have to start and end with CATransformIdentity,
        // so that the label starts from and returns to its non-transformed state.
        [scaleAnimation setValues:[NSArray arrayWithObjects:
                                   [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                   [NSValue valueWithCATransform3D:transform],
                                   [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                   nil]];
        
        // set the duration of the animation
        [scaleAnimation setDuration: .5];
        
        // animate your label layer = rock and roll!
        [[self.timeLabel layer] addAnimation:scaleAnimation forKey:@"scaleText"];
        
    //    [[self.scoreLabel layer] addAnimation:scaleAnimation forKey:@"scaleText"];
    }
    else if(theTime<=0 && startCounting)
    {
        _blockView.hidden = NO;
//        [gamePath removeFromSuperview];
//        [bezier removeFromSuperlayer];
        startCounting = NO;
        _timeLabel.hidden = YES;
        
        if(appDelegate.gamePoints>0)
        {
            [gamePath pathColorYellow];
            // Create the keyframe animation object
            CAKeyframeAnimation *scaleAnimation =
            [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            
            // Set the animation's delegate to self so that we can add callbacks if we want
            scaleAnimation.delegate = self;
            
            // Create the transform; we'll scale x and y by 1.5, leaving z alone
            // since this is a 2D animation.
            CATransform3D transform = CATransform3DMakeScale(1.0, 1.5, 1); // Scale in x and y
            
            // Add the keyframes.  Note we have to start and end with CATransformIdentity,
            // so that the label starts from and returns to its non-transformed state.
            [scaleAnimation setValues:[NSArray arrayWithObjects:
                                       [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                       [NSValue valueWithCATransform3D:transform],
                                       [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                       nil]];
            
            // set the duration of the animation
            [scaleAnimation setDuration: 1.0];
            
            // animate your label layer = rock and roll!
            _score = appDelegate.score;
            
            _scoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Score: %lld", nil),_score];
            
            _gameScoreLabel.text = [NSString stringWithFormat:@"%ld",(long)appDelegate.gamePoints];
            [self.view bringSubviewToFront:_gameScoreLabel];
            _gameScoreLabel.textColor = [UIColor greenColor];

            if(appDelegate.gamePoints>50)
            {
                AudioServicesPlaySystemSound(manyPointsSound);
            }
            else if(appDelegate.gamePoints>0)
            {
                AudioServicesPlaySystemSound(pointsSound);
            }
            
            
            [UIView animateWithDuration:0.5
                             animations:^{
                                 
                                 [[self.scoreLabel layer] addAnimation:scaleAnimation forKey:@"scaleText"];
                                 [[self.gameScoreLabel layer] addAnimation:scaleAnimation forKey:@"scaleText"];

                                 _gameScoreLabel.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 
                                 [UIView animateWithDuration:0.5
                                                       delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                                                  animations:^{
                                                     
                                                      _gameScoreLabel.alpha = 0.0;
     
                                                  }
                                                  completion:^(BOOL finished){

                                                      [self achievements];
                                                      [bezier removeFromSuperlayer];
                                                      bezier = nil;
                                                      
                                                      [gamePath removeFromSuperview];
                                                      gamePath = nil;
                                                      
                                                      [self drawBezierAnimate:YES];

                                                  }];
                                 
                             }];

            
        }
        else
        {
            [gamePath pathColorMissed];//If no points earned

                AudioServicesPlaySystemSound(missedSound);
            
            // Create the keyframe animation object
            CAKeyframeAnimation *scaleAnimation =
            [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            
            // Set the animation's delegate to self so that we can add callbacks if we want
            scaleAnimation.delegate = self;
            
            // Create the transform; we'll scale x and y
            CATransform3D transform = CATransform3DMakeScale(1.0, 1.5, 1); // Scale in x and y
            
            // Add the keyframes.  Note we have to start and end with CATransformIdentity,
            // so that the label starts from and returns to its non-transformed state.
            [scaleAnimation setValues:[NSArray arrayWithObjects:
                                       [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                       [NSValue valueWithCATransform3D:transform],
                                       [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                       nil]];
            
            // set the duration of the animation
            [scaleAnimation setDuration: 1.0];
            
            // animate your label layer = rock and roll!
            _score = appDelegate.score;
            
            _scoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Score: %lld", nil),_score];
            
            _gameScoreLabel.text = [NSString stringWithFormat:@"%ld",(long)appDelegate.gamePoints];
            [self.view bringSubviewToFront:_gameScoreLabel];
            _gameScoreLabel.textColor = [UIColor redColor];

            [UIView animateWithDuration:0.5
                             animations:^{
                                 
                                 [[self.scoreLabel layer] addAnimation:scaleAnimation forKey:@"scaleText"];
                                 [[self.gameScoreLabel layer] addAnimation:scaleAnimation forKey:@"scaleText"];
                                 
                                 _gameScoreLabel.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 
                                 [UIView animateWithDuration:0.5
                                                       delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                                                  animations:^{
                                                      
                                                      _gameScoreLabel.alpha = 0.0;
                                                      
                                                  }
                                                  completion:^(BOOL finished){
                                                      
                                                      [self achievements];
                                                      [bezier removeFromSuperlayer];
                                                      bezier = nil;
                                                      
                                                      [gamePath removeFromSuperview];
                                                      gamePath = nil;
                                                      
                                                      [self drawBezierAnimate:YES];
                                                      
                                                  }];
                                 
                             }];

        }
    }

}

@end
