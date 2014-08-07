//
//  BABHeaderView.m
//  Bricks and Balls
//
//  Created by Shane Sniteman on 8/7/14.
//  Copyright (c) 2014 Shane Sniteman. All rights reserved.
//

#import "BABHeaderView.h"

@implementation BABHeaderView
{
    UILabel * scoreLabel;
    UILabel * livesLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.lives = 3;
        self.score = 0;
        
        scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 200, 0, 190, 40)];
        
        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.textAlignment = NSTextAlignmentRight;
        scoreLabel.text = [NSString stringWithFormat:@"%d",self.score];
        
        [self addSubview:scoreLabel];
        
        
        livesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 30)];
        
        livesLabel.backgroundColor = [UIColor clearColor];
        livesLabel.layer.borderColor = [UIColor blackColor].CGColor;
        livesLabel.layer.borderWidth  = 2;
        
        
        livesLabel.text = [NSString stringWithFormat:@"%d",self.lives];
        
        [self addSubview:livesLabel];
        
        
        
    }
    return self;
}

- (void)setScore:(int)score
{
    _score = score;
    scoreLabel.text = [NSString stringWithFormat:@"Score: %d",score];
}

-(void)setLives:(int)lives
{
    _lives = lives;

    
    livesLabel.text = [NSString stringWithFormat:@"%d",lives];
}

@end
