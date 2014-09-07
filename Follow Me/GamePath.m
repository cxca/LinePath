//
//  ViewController.m
//  LinePath
//
//  Created by Xavy on 8/19/14.
//  Copyright (c) 2014 Carlos Chaparro. All rights reserved.
//

#import "GamePath.h"
#import "AppDelegate.h"

@interface GamePath ()
{
    AppDelegate *appDelegate;
    UIBezierPath *bPath;
     UIImage *incrementalImage; // (1)
    CGPoint pts[4]; // to keep track of the four points of our Bezier segment
    uint ctr; // a counter variable to keep track of the point index

    UIColor *bColor;
}
@end

@implementation GamePath

- (id)init
{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
	self = [super initWithFrame:frame];
	if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        bPath=[[UIBezierPath alloc]init];
        
        bPath.lineWidth=10;
        
        bColor=[UIColor blueColor]; //Any color
        
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        appDelegate.gamePoints = 0;
        
	}
	return self;
}

-(void)drawRect:(CGRect)rect
{
    [[UIColor yellowColor] setStroke];
    
    [bPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    ctr = 0;
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [bPath moveToPoint:p];
    
    UIColor *color = [self colorOfPoint:p];
    
    if([color isEqual:[UIColor blackColor]])
        NSLog(@"Increase score if necessary");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    
    [bPath addLineToPoint:p];
    
    UIColor *color = [self colorOfPoint:p];
    NSLog(@"Color %@",color);
    NSLog(@"Black %@",[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]);
    
    if([color isEqual:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]])
    {
        NSLog(@"Increase score");
        //increase score
        
        appDelegate.score++;
        appDelegate.gamePoints++;
    }
    
    [self setNeedsDisplay];
    
}

- (BOOL)containsPoint:(CGPoint)point onPath:(UIBezierPath *)path inFillArea:(BOOL)inFill
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathRef cgPath = path.CGPath;
    BOOL    isHit = NO;
    
    // Determine the drawing mode to use. Default to
    // detecting hits on the stroked portion of the path.
    CGPathDrawingMode mode = kCGPathStroke;
    if (inFill)
    {
        // Look for hits in the fill area of the path instead.
        if (path.usesEvenOddFillRule)
            mode = kCGPathEOFill;
        else
            mode = kCGPathFill;
    }
    
    // Save the graphics state so that the path can be
    // removed later.
    CGContextSaveGState(context);
    CGContextAddPath(context, cgPath);
    
    // Do the hit detection.
    isHit = CGContextPathContainsPoint(context, point, mode);
    
    CGContextRestoreGState(context);
    
    return isHit;
}

- (UIImage *)imageForView:(UIView *)view {
    UIGraphicsBeginImageContext(view.frame.size);
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retval;
}
- (UIColor *) colorOfPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [_mainView.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

-(void)pathColorYellow
{
    
    CAShapeLayer *bezier = [[CAShapeLayer alloc] init];
    
    bezier.path          = bPath.CGPath;
    bezier.strokeColor   = [UIColor greenColor].CGColor;
    bezier.fillColor     = [UIColor clearColor].CGColor;
    bezier.lineWidth     = 11.0;
    bezier.strokeStart   = 0.0;
    bezier.strokeEnd     = 1.0;
    
    [self.layer addSublayer:bezier];
    

        [CATransaction begin]; {
            [CATransaction setCompletionBlock:^{
                
                
            }];
            CABasicAnimation *animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animateStrokeEnd.duration  = 0.0;
            animateStrokeEnd.fromValue = [NSNumber numberWithFloat:0.0f];
            animateStrokeEnd.toValue   = [NSNumber numberWithFloat:1.0f];
            [bezier addAnimation:animateStrokeEnd forKey:@"strokeEndAnimation"];
        } [CATransaction commit];
}

-(void)pathColorMissed;
{
    CAShapeLayer *bezier = [[CAShapeLayer alloc] init];
    
    bezier.path          = bPath.CGPath;
    bezier.strokeColor   = [UIColor redColor].CGColor;
    bezier.fillColor     = [UIColor clearColor].CGColor;
    bezier.lineWidth     = 11.0;
    bezier.strokeStart   = 0.0;
    bezier.strokeEnd     = 1.0;
    
    [self.layer addSublayer:bezier];
    
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:^{
            
            
        }];
        CABasicAnimation *animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animateStrokeEnd.duration  = 0.0;
        animateStrokeEnd.fromValue = [NSNumber numberWithFloat:0.0f];
        animateStrokeEnd.toValue   = [NSNumber numberWithFloat:1.0f];
        [bezier addAnimation:animateStrokeEnd forKey:@"strokeEndAnimation"];
    } [CATransaction commit];

}

@end
