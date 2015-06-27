//
//  MenuViewController.m
//  Doodle Jump
//
//  Created by Hempleg on 27/06/15.
//  Copyright (c) 2015 Artyom Kukharev. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;
@end

@implementation MenuViewController

- (IBAction)resetScoreButton:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:0 forKey:@"HighScore"];
    [self updateLabel];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) updateLabel {
    int highScore = [[[NSUserDefaults standardUserDefaults] valueForKey:@"HighScore"] intValue];
    
    self.highScoreLabel.text = [NSString stringWithFormat:@"High score: %i", highScore];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateLabel];
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
