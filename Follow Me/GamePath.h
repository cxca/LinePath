//
//  ViewController.h
//  LinePath
//
//  Created by Xavy on 8/19/14.
//  Copyright (c) 2014 Carlos Chaparro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GamePath : UIView
{
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    CGPoint currentPoint;
}
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIBezierPath *givenPath;
@property (nonatomic,strong) UIView *mainView;

-(void)pathColorYellow;

-(void)pathColorMissed;

@end
