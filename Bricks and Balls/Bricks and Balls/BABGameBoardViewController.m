//
//  BABGameBoardViewController.m
//  Bricks and Balls
//
//  Created by Shane Sniteman on 8/6/14.
//  Copyright (c) 2014 Shane Sniteman. All rights reserved.
//

#import "BABGameBoardViewController.h"

@interface BABGameBoardViewController () <UICollisionBehaviorDelegate>

@end

@implementation BABGameBoardViewController
{
    UIDynamicAnimator * animator;
    UIDynamicItemBehavior * ballItemBehavior;
    UIDynamicItemBehavior * brickItemBehavior;
    UIGravityBehavior * gravityBehavior;
    UICollisionBehavior * collisionBehavior;
    
    UIView * ball;
    UIView * paddle;
    
    NSMutableArray * bricks;
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
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
        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        collisionBehavior.collisionDelegate = self;
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

    paddle = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2, SCREEN_HEIGHT - 8, 100, 4)];
    
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
            
            float x = 10 + (width + brickSpacing) * col;
            float y = 10 + (height + brickSpacing) * row;
            
        
            UIView * brick = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            
            brick.backgroundColor = [UIColor lightGrayColor];
            
            [self.view addSubview:brick];
            
            [bricks addObject:brick];
        }
    }

    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
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

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    for (UIView * brick in bricks)
    {
        if ([item1 isEqual:brick] || [item2 isEqual:brick])
        {
            [collisionBehavior removeItem:brick];
            [brick removeFromSuperview];
        }
    }
}

-(BOOL)prefersStatusBarHidden { return YES; }


@end
