//
//  HomeScreenViewController.m
//  Whip
//
//  Created by Allen White on 10/8/15.
//  Copyright © 2015 Worldwide International. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "InstructionsViewController.h"

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self populateHighScore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)populateHighScore{
	if ([[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"]) {
		self.scoreLabel.text = [NSString stringWithFormat:@"HIGH SCORE: %ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"]];
	}else{
		//was a high score, and the first score to be recorded
		NSLog(@"3");
		self.scoreLabel.text = @"";
	}
}


@end
