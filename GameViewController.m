//
//  GameViewController.m
//  Doodle Jump
//
//  Created by Hempleg on 27/06/15.
//  Copyright (c) 2015 Artyom Kukharev. All rights reserved.
//

#import "GameViewController.h"

#define BALL_INITIAL_UPSPEED -5
#define BALL_SPEED_INC 0.05
#define PLATFORM3_SIDE_SPEED 2
#define PLATFORM5_SIDE_SPEED -2.5
#define BALL_SIDE_STEP 0.3
#define MAX_BALL_SIDE_SPEED 5
#define PLATFORM_FALL_SPEED_DEC 0.1

@interface GameViewController ()

@property (weak, nonatomic) IBOutlet UIButton *gameOverButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ball;
@property (weak, nonatomic) IBOutlet UIImageView *platform1;
@property (weak, nonatomic) IBOutlet UIImageView *platform2;
@property (weak, nonatomic) IBOutlet UIImageView *platform3;
@property (weak, nonatomic) IBOutlet UIImageView *platform4;
@property (weak, nonatomic) IBOutlet UIImageView *platform5;


@property (strong, nonatomic) NSTimer *movingTimer;
@property (strong, nonatomic) NSTimer *platform3Movement;
@property (strong, nonatomic) NSTimer *platform5Movement;
@property (nonatomic) float upSpeed;

@property (nonatomic) int platformRandomPosition;
@property (nonatomic) float platform3SideSpeed;
@property (nonatomic) float platform5SideSpeed;

@property (nonatomic) BOOL ballLeft;
@property (nonatomic) BOOL ballRight;
@property (nonatomic) float ballSideSpeed;
@property (nonatomic) BOOL stopBallSideMovement;

@property (nonatomic) float platformFallSpeed;


@end

@implementation GameViewController

#pragma mark - Game Action Mathods

- (void) gameOver {
    self.ball.hidden = YES;
    self.gameOverButton.hidden = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    if (touchPoint.x > self.ball.center.x) {
        self.ballRight = YES;
    }
    if (touchPoint.x < self.ball.center.x) {
        self.ballLeft = TRUE;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.stopBallSideMovement = YES;
    self.ballLeft = NO;
    self.ballRight = NO;
}

- (void) newPositionForPlatform: (UIImageView*) platform {
    if (platform.center.y - platform.bounds.size.height / 2 > self.view.bounds.size.height) {
        int randomXPosition = arc4random() % (int)(self.view.bounds.size.width - platform.bounds.size.width) + platform.bounds.size.width / 2;
        platform.center = CGPointMake(randomXPosition, -platform.bounds.size.height / 2);
    }
}

- (void) platformMoving {
    self.platform1.center = CGPointMake(self.platform1.center.x,
                                        self.platform1.center.y + self.platformFallSpeed);
    self.platform2.center = CGPointMake(self.platform2.center.x,
                                        self.platform2.center.y + self.platformFallSpeed);
    self.platform3.center = CGPointMake(self.platform3.center.x - self.platform3SideSpeed,
                                        self.platform3.center.y + self.platformFallSpeed);
    self.platform4.center = CGPointMake(self.platform4.center.x,
                                        self.platform4.center.y + self.platformFallSpeed);
    self.platform5.center = CGPointMake(self.platform5.center.x - self.platform5SideSpeed,
                                        self.platform5.center.y + self.platformFallSpeed);
    
    if (self.platform3.center.x < self.platform3.bounds.size.width / 2) {
        self.platform3SideSpeed *= -1;
    }
    if (self.platform5.center.x < self.platform5.bounds.size.width / 2) {
        self.platform5SideSpeed *= -1;
    }
    if (self.platform3.center.x + self.platform3.bounds.size.width / 2 > self.view.bounds.size.width) {
        self.platform3SideSpeed *= -1;
    }
    if (self.platform5.center.x + self.platform5.bounds.size.width / 2 > self.view.bounds.size.width) {
        self.platform5SideSpeed *= -1;
    }
    
    if (self.platformFallSpeed > 0) {
        self.platformFallSpeed -= PLATFORM_FALL_SPEED_DEC;
    }
    
    //Uncommet this for unflexible strike
    
    if (self.platformFallSpeed < 0) {
        self.platformFallSpeed = 0;
    }
    
    [self newPositionForPlatform:self.platform1];
    [self newPositionForPlatform:self.platform2];
    [self newPositionForPlatform:self.platform3];
    [self newPositionForPlatform:self.platform4];
    [self newPositionForPlatform:self.platform5];
    
}

- (void) bounce {
    self.ball.animationImages = @[[UIImage imageNamed:@"Ball2.png"],
                                  [UIImage imageNamed:@"Ball3.png"],
                                  [UIImage imageNamed:@"Ball2.png"],
                                  [UIImage imageNamed:@"Ball1.png"]];
    [self.ball setAnimationDuration:0.3];
    [self.ball setAnimationRepeatCount:1];
    [self.ball startAnimating];
    
    int partView = self.view.bounds.size.height / 5;
    if(self.ball.center.y < self.view.bounds.size.height - partView*4) {
        self.upSpeed = 0.1;
    }
    else if(self.ball.center.y < self.view.bounds.size.height - partView*3) {
        self.upSpeed = 1;
    }
    else if(self.ball.center.y < self.view.bounds.size.height - partView*2) {
        self.upSpeed = 3;
    }
    else if(self.ball.center.y < self.view.bounds.size.height - partView) {
        self.upSpeed = 5;
    }
    else if (self.ball.center.y < self.view.bounds.size.height) {
        self.upSpeed = 5;
    }


    

}

- (void) platformFalling {
    int part = self.view.bounds.size.height / 5;
    
    if (self.ball.center.y < self.view.bounds.size.height - part*4) {
        self.platformFallSpeed = 14;
    }
    else if (self.ball.center.y < self.view.bounds.size.height - part*3) {
        self.platformFallSpeed = 11;
    }
    else if (self.ball.center.y < self.view.bounds.size.height - part*2) {
        self.platformFallSpeed = 9;
    }
    else if (self.ball.center.y < self.view.bounds.size.height - part) {
        self.platformFallSpeed = 6;
    }
    else if (self.ball.center.y < self.view.bounds.size.height) {
        self.platformFallSpeed = 4;
    }
}

- (void) moving {
    [self platformMoving];
    self.ball.center = CGPointMake(self.ball.center.x + self.ballSideSpeed, self.ball.center.y - self.upSpeed);
    if (CGRectIntersectsRect(self.ball.frame, self.platform1.frame) && self.upSpeed < -2) {
        [self bounce];
        [self platformFalling];
    }
    if (CGRectIntersectsRect(self.ball.frame, self.platform2.frame) && self.upSpeed < -2) {
        [self bounce];
        [self platformFalling];
    }
    if (CGRectIntersectsRect(self.ball.frame, self.platform3.frame) && self.upSpeed < -2) {
        [self bounce];
        [self platformFalling];
    }
    if (CGRectIntersectsRect(self.ball.frame, self.platform4.frame) && self.upSpeed < -2) {
        [self bounce];
        [self platformFalling];
    }
    if (CGRectIntersectsRect(self.ball.frame, self.platform5.frame) && self.upSpeed < -2) {
        [self bounce];
        [self platformFalling];
    }
    self.upSpeed -= BALL_SPEED_INC;
    
    if (self.ballLeft) {
        self.ballSideSpeed -= BALL_SIDE_STEP;
    }
    if (self.ballRight) {
        self.ballSideSpeed += BALL_SIDE_STEP;
    }
    if (self.ballSideSpeed > MAX_BALL_SIDE_SPEED) {
        self.ballSideSpeed = MAX_BALL_SIDE_SPEED;
    }
    if (self.ballSideSpeed < (-1)*MAX_BALL_SIDE_SPEED) {
        self.ballSideSpeed = (-1)*MAX_BALL_SIDE_SPEED;
    }
    if (self.stopBallSideMovement) {
        if (self.ballSideSpeed > 0) {
            self.ballSideSpeed -= 0.1;
        }
        if (self.ballSideSpeed < 0) {
            self.ballSideSpeed += 0.1;
        }
    }
    if (self.ball.center.x + self.ball.bounds.size.width / 2  < 0) {
        self.ball.center = CGPointMake(self.view.bounds.size.width + self.ball.bounds.size.width / 2, self.ball.center.y);
        
    }
    if (self.ball.center.x - self.ball.bounds.size.width / 2 > self.view.bounds.size.width) {
        self.ball.center = CGPointMake(-self.ball.bounds.size.width / 2, self.ball.center.y);
    }
    
    if (self.ball.center.y + self.ball.bounds.size.height / 2 > self.view.bounds.size.height) {
        [self gameOver];
    }
}

- (IBAction)startButtonPressed:(id)sender {
    self.startButton.hidden = YES;
    self.ball.hidden = NO;
    self.platform2.hidden = NO;
    self.platform3.hidden = NO;
    self.platform4.hidden = NO;
    self.platform5.hidden = NO;
    
    self.upSpeed = BALL_INITIAL_UPSPEED;
    self.platform3SideSpeed = PLATFORM3_SIDE_SPEED;
    self.platform5SideSpeed = PLATFORM5_SIDE_SPEED;
    
    self.movingTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moving) userInfo:nil repeats:YES];
}

#pragma mark - Game Controller methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ball.hidden = YES;
    self.platform2.hidden = YES;
    self.platform3.hidden = YES;
    self.platform4.hidden = YES;
    self.platform5.hidden = YES;
    self.gameOverButton.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
