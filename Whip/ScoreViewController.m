//
//  ScoreViewController.m
//  Whip
//
//  Created by Allen White on 10/8/15.
//  Copyright © 2015 Worldwide International. All rights reserved.
//

#import "ScoreViewController.h"
#import "GamePlayViewController.h"


@interface ScoreViewController ()

@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.score];
	[self populateHighScore];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)populateHighScore{
	if ([[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"]) {
		if ([[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"] < self.score) {
			//was a high score
			NSLog(@"1");
			[[NSUserDefaults standardUserDefaults] setInteger:self.score forKey:@"highScore"];
			self.bestScoreLabel.text = [NSString stringWithFormat:@"BEST: %ld", (long)self.score];
			self.wasHighScoreLabel.hidden = NO;
		}else{
			//not a high score
			NSLog(@"2");
			self.bestScoreLabel.text = [NSString stringWithFormat:@"BEST: %ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"]];
			self.wasHighScoreLabel.hidden = YES;
		}
	}else{
		//was a high score, and the first score to be recorded
		NSLog(@"3");
		[[NSUserDefaults standardUserDefaults] setInteger:self.score forKey:@"highScore"];
		self.bestScoreLabel.text = [NSString stringWithFormat:@"BEST: %ld", (long)self.score];
		self.wasHighScoreLabel.hidden = NO;
	}
}


- (IBAction)shareToFBTapped:(id)sender {
	UIActivityViewController *activityViewController =
					[[UIActivityViewController alloc] initWithActivityItems:
						@[
							[NSString stringWithFormat:@"I got a new high score of %d on Whip App! Come at me!",self.score],
							[NSURL URLWithString:@"http://www.cantstopthecrop.com"]
						]
					  applicationActivities:nil];
	
	activityViewController.excludedActivityTypes = @[
						      UIActivityTypeAirDrop,
						      UIActivityTypeAddToReadingList,
						      UIActivityTypeMail];
	
	[self presentViewController:activityViewController
					   animated:YES
					 completion:^{
						 //nuthin, really
					 }];
}


- (IBAction)replayButtonTapped:(id)sender {
	GamePlayViewController *gpvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GamePlayViewController"];
	[self presentViewController:gpvc animated:YES completion:^{nil;}];
}

@end
