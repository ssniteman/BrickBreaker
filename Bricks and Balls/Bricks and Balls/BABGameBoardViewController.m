//
//  BABGameBoardViewController.m
//  Bricks and Balls
//
//  Created by Shane Sniteman on 8/6/14.
//  Copyright (c) 2014 Shane Sniteman. All rights reserved.
//

#import "BABGameBoardViewController.h"

// 3 lives
// after you hit floor, start new ball and take away one life
// once all 3 lives lost, game over alert, with option to restart (should reset life count)
// score count, bricks broken add points to score count
// create temporty label for score count

@interface BABGameBoardViewController () <UICollisionBehaviorDelegate>

@end

@implementation BABGameBoardViewController
{
    UIDynamicAnimator * animator;
    UIDynamicItemBehavior * ballItemBehavior;
    UIDynamicItemBehavior * brickItemBehavior;
    UIGravityBehavior * gravityBehavior;
    UICollisionBehavior * collisionBehavior;
    UIAttachmentBehavior * attachmentBehavior;
    
    
    UILabel * scoreLabel;
    UILabel * livesLabel;
    UIView * ball;
    UIView * paddle;
    UIButton * newLifeButton;
    
    NSMutableArray * bricks;
    
    int score;
    int lives;
    
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        lives = 3;
        score = 0;
        
        bricks = [@[] mutableCopy];
        
        
        
        animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        
        ballItemBehavior = [[UIDynamicItemBehavior alloc] init];
        
        
        ballItemBehavior.friction = 0;
        ballItemBehavior.elasticity = 1;
        ballItemBehavior.resistance = 0;
        ballItemBehavior.allowsRotation = NO;
        [animator addBehavior:ballItemBehavior];
        
        gravityBehavior = [[UIGravityBehavior alloc] init];
        gravityBehavior.gravityDirection = CGVectorMake(0.0, 1.0);
        [animator addBehavior:gravityBehavior];
        
        collisionBehavior = [[UICollisionBehavior alloc] init];
//      collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        collisionBehavior.collisionDelegate = self;
        
        // need to create boundaries so when ball hits bottom, it goes away
        
        [collisionBehavior addBoundaryWithIdentifier:@"floor" fromPoint:CGPointMake(0, SCREEN_HEIGHT) toPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT + 20)];
        
        [collisionBehavior addBoundaryWithIdentifier:@"left wall" fromPoint:CGPointMake(0,0) toPoint:CGPointMake(0, SCREEN_HEIGHT)];
        
        [collisionBehavior addBoundaryWithIdentifier:@"right wall" fromPoint:CGPointMake(SCREEN_WIDTH,0) toPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        [collisionBehavior addBoundaryWithIdentifier:@"ceiling wall" fromPoint:CGPointMake(0,0) toPoint:CGPointMake(SCREEN_WIDTH,0)];
        
        
        [animator addBehavior:collisionBehavior];
        
        brickItemBehavior = [[UIDynamicItemBehavior alloc] init];
        brickItemBehavior.density = 1000000;
        [animator addBehavior:brickItemBehavior];
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    paddle = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2, SCREEN_HEIGHT - 10, 100, 4)];
    
    paddle.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:paddle];
    
    
    
    ball = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20) / 2, SCREEN_HEIGHT - 50, 20, 20)];
    ball.layer.cornerRadius = ball.frame.size.width / 2.0;
    ball.backgroundColor = [UIColor magentaColor];
    [self.view addSubview:ball];
    
    int colCount = 7;
    int rowCount = 4;
    int brickSpacing = 10;
    
    for (int col = 0; col < colCount; col++)
    {
        for (int row = 0; row < rowCount; row++)
        {
            
            float width = (SCREEN_WIDTH - (brickSpacing * (colCount + 1))) / colCount;
            float height = ((SCREEN_HEIGHT / 3) - (brickSpacing * rowCount)) / rowCount;
            
            float x = brickSpacing + (width + brickSpacing) * col;
            float y = 30 + (height + brickSpacing) * row;
            
        
            UIView * brick = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            
            brick.backgroundColor = [UIColor lightGrayColor];
            
            [self.view addSubview:brick];
            
            [bricks addObject:brick];
        }
    }
    
    
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 0, 70, 30)];
    
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.layer.borderColor = [UIColor blackColor].CGColor;
    scoreLabel.layer.borderWidth  = 2;
    
    
    scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    
    [self.view addSubview:scoreLabel];

    
    livesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 30)];
    
    livesLabel.backgroundColor = [UIColor clearColor];
    livesLabel.layer.borderColor = [UIColor blackColor].CGColor;
    livesLabel.layer.borderWidth  = 2;
    
    
    livesLabel.text = [NSString stringWithFormat:@"%d",lives];
    
    [self.view addSubview:livesLabel];
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:paddle attachedToAnchor:paddle.center];
    [animator addBehavior:attachmentBehavior];
    
    
    
    for (UIView * brick in bricks)
    {
        [collisionBehavior addItem:brick];
        [brickItemBehavior addItem:brick];
    }
    
    [collisionBehavior addItem:ball];
    [ballItemBehavior addItem:ball];
    
    [collisionBehavior addItem:paddle];
    [brickItemBehavior addItem:paddle];
    
    
    UIPushBehavior * pushBehavior = [[UIPushBehavior alloc] initWithItems:@[ball] mode:UIPushBehaviorModeInstantaneous];
    
    pushBehavior.pushDirection = CGVectorMake(0.1, -0.1);
    
    [animator addBehavior:pushBehavior];
    
    
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    if ([@"floor" isEqualToString:(NSString *)identifier])
    {
        UIView * ballItem = (UIView *)item;
        [collisionBehavior removeItem:ballItem];
        [ballItem removeFromSuperview];
        
        lives --;
        
        livesLabel.text = [NSString stringWithFormat:@"%d",lives];
    
        NSLog(@"lives are %d",lives);
        
        newLifeButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2, SCREEN_HEIGHT - 100, 100, 30)];
        
        newLifeButton.backgroundColor = [UIColor blackColor];
        [self.view addSubview:newLifeButton];
        [newLifeButton addTarget:self action:@selector(newLifeClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
}



- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    for (UIView * brick in [bricks copy])
    {
        if ([item1 isEqual:brick] || [item2 isEqual:brick])
        {
            [collisionBehavior removeItem:brick];
            [brick removeFromSuperview];
            
            [gravityBehavior addItem:brick];
            
            [bricks removeObjectIdenticalTo:brick];
            
            
            [UIView animateWithDuration:0.3 animations:^{
                brick.alpha = 0;
            } completion:^(BOOL finished) {
                
                [brick removeFromSuperview];
                
                
                // increasing score and then putting it in label
                
                score ++;
                
                scoreLabel.text = [NSString stringWithFormat:@"%d",score];
                
                NSLog(@"%d",score);
            }];
        }
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self movePaddleWithTouches:touches];
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self movePaddleWithTouches:touches];
}


- (void)movePaddleWithTouches:(NSSet *)touches
{
    UITouch * touch = [touches allObjects][0];
    CGPoint location = [touch locationInView:self.view];
    
    // fixes guard rail edge
    
    float guard = paddle.frame.size.width / 2.0 + 10;
    float dragX = location.x;
    
    if (dragX < guard) dragX = guard;
    if (dragX > SCREEN_WIDTH - guard) dragX = SCREEN_WIDTH - guard;
    
    

    attachmentBehavior.anchorPoint = CGPointMake(dragX, paddle.center.y);
    
    paddle.center = CGPointMake(location.x, paddle.center.y);

    // keeps the density to where you touch - doesn't bounce back to middle
    
    attachmentBehavior.anchorPoint = paddle.center;
    
    
}



- (void)newLifeClicked
{
        
}





-(BOOL)prefersStatusBarHidden { return YES; }


@end
