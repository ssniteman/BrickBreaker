//
//  BABHeaderView.h
//  Bricks and Balls
//
//  Created by Shane Sniteman on 8/7/14.
//  Copyright (c) 2014 Shane Sniteman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BABHeaderView : UIView

// because it's a property, lives and score have setter methods

@property (nonatomic) int lives;
@property (nonatomic) int score;

@end
