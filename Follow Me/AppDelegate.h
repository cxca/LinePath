//
//  AppDelegate.h
//  LinePath
//
//  Created by Xavy on 8/19/14.
//  Copyright (c) 2014 Carlos Chaparro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) BOOL isPause;
@property (nonatomic, assign) BOOL newRecordToFetch;

@property (nonatomic, assign) NSInteger scoreTotal;
@property (nonatomic, assign) NSInteger timeTotal;

@property (nonatomic, strong) NSString *leaderboardIdentifier;
@property (nonatomic, assign) BOOL  _gameCenterEnabled;



@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL shareOnFacebook;
@property (nonatomic, assign) NSInteger lives;

@property (nonatomic) int64_t score;
@property (nonatomic) NSInteger gamePoints;

@end
