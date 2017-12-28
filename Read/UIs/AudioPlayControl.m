//
//  AudioPlayControl.m
//  Answer
//
//  Created by wuyj on 15/12/17.
//  Copyright © 2015年 wuyj. All rights reserved.
//

#import "AudioPlayControl.h"

@interface AudioPlayControl ()
@property (nonatomic, strong) UIImageView   *playView;
@property (nonatomic, strong) UIImageView   *bgView;
@end

@implementation AudioPlayControl

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 21 * 20
        self.bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"voice_bg"];
        UIImage *imageRes = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10) resizingMode:UIImageResizingModeStretch];
        [_bgView setImage:imageRes];
        [self addSubview:_bgView];
        
        // 15*15
        self.playView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_playView setImage:[UIImage imageNamed:@"chatto_voice_playing_f3"]];
        
        NSArray *animationImages = [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"chatto_voice_playing_f1"],
                                    [UIImage imageNamed:@"chatto_voice_playing_f2"],
                                    [UIImage imageNamed:@"chatto_voice_playing_f3"],nil];
        [_playView setAnimationImages:animationImages];
        _playView.animationDuration = 20/30.0;
        [self addSubview:_playView];
    }
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [_bgView setFrame:self.bounds];
    [_playView setFrame:CGRectMake(6, (self.frame.size.height - 15)/2.0, 15, 15)];
}

- (void)startPlayAnimation {
    [_playView startAnimating];
}


- (void)stopPlayAnimation {
    [_playView stopAnimating];
}

// =====================================================================
#pragma mark Touch Tracking
// ======================================================================

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    [self setBackgroundColor:[UIColor whiteColor]];
    return YES;
}



- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    [self setBackgroundColor:[UIColor whiteColor]];
    return YES;
}


- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
    [self setBackgroundColor:[UIColor whiteColor]];
}

// 交互统计
- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    [super sendAction:action to:target forEvent:event];
}


@end
