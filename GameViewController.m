//
//  GameViewController.m
//  Doodle Jump
//
//  Created by Hempleg on 27/06/15.
//  Copyright (c) 2015 Artyom Kukharev. All rights reserved.
//

#import "GameViewController.h"

#define BALL_INITIAL_UPSPEED -5
#define BALL_SPEED_INC 0.1
#define PLATFORM3_SIDE_SPEED 2
#define PLATFORM5_SIDE_SPEED -2.5

@interface GameViewController ()

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

@end

@implementation GameViewController

#pragma mark - Game Action Mathods

- (void) platformMoving {
    self.platform3.center = CGPointMake(self.platform3.center.x - self.platform3SideSpeed,
                                        self.platform3.center.y);
    self.platform5.center = CGPointMake(self.platform5.center.x - self.platform5SideSpeed,
                                        self.platform5.center.y);
    
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
    
}

- (void) bounce {
    self.ball.animationImages = @[[UIImage imageNamed:@"Ball2.png"],
                                  [UIImage imageNamed:@"Ball3.png"],
                                  [UIImage imageNamed:@"Ball2.png"],
                                  [UIImage imageNamed:@"Ball1.png"]];
    [self.ball setAnimationDuration:0.3];
    [self.ball setAnimationRepeatCount:1];
    [self.ball startAnimating];
    
    self.upSpeed = BALL_INITIAL_UPSPEED * (-1);
}

- (void) moving {
    [self platformMoving];
    self.ball.center = CGPointMake(self.ball.center.x, self.ball.center.y - self.upSpeed);
    if (CGRectIntersectsRect(self.ball.frame, self.platform1.frame) && self.upSpeed < -2) {
        [self bounce];
    }
    self.upSpeed -= BALL_SPEED_INC;
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
