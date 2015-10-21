//
//  ScoreViewController.m
//  Whip
//
//  Created by Allen White on 10/8/15.
//  Copyright © 2015 Worldwide International. All rights reserved.
//

#import "ScoreViewController.h"
#import "GamePlayViewController.h"
#import <iAd/iAd.h>
#import <Parse/Parse.h>
#import "LeaderBoardViewController.h"

@interface ScoreViewController (){
	ADInterstitialAd *interstitial;
}
@property UIImage *screenshot;
@property NSArray *top10Scores;
@property NSString *alertViewCancelTitle;

@end

@implementation ScoreViewController

bool hasSaved = NO;


NSString *shareUrl = @"thewhipgame.com";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.score];
	[self populateHighScore];
	interstitial = [[ADInterstitialAd alloc] init];
	interstitial.delegate = self;
	hasSaved = NO;
	self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
	self.alertViewCancelTitle = @"Cancel";
	NSLog(@"getTopScoresCalled");
	[self getTopScores];
}


-(void)viewDidLayoutSubviews{
	NSLog(@"didlayout");
	UILabel *linklabel = [[UILabel alloc] initWithFrame:CGRectMake(
								       self.bestScoreLabel.frame.origin.x,
								       self.bestScoreLabel.frame.origin.y,
								       self.bestScoreLabel.frame.size.width,
								       self.bestScoreLabel.frame.size.height)];
	linklabel.text = shareUrl;
	linklabel.font = [UIFont fontWithName:self.bestScoreLabel.font.fontName size:self.bestScoreLabel.font.pointSize*0.6];
	linklabel.textColor = [UIColor whiteColor];
	linklabel.textAlignment = NSTextAlignmentRight;
	[self.view addSubview:linklabel];
	
	[self takeScreenShot];
	
	linklabel.hidden = YES;
}




// When this method is invoked, the application should remove the view from the screen and tear it down.
// The content will be unloaded shortly after this method is called and no new content will be loaded in that view.
// This may occur either when the user dismisses the interstitial view via the dismiss button or
// if the content in the view has expired.
- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd {
	NSLog(@"bout to unload on sum mo fukkas");
}

// This method will be invoked when an error has occurred attempting to get advertisement content.
// The ADError enum lists the possible error codes.
- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
	NSLog(@"XXXX%@", error.localizedDescription);
}


-(void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd {
	NSLog(@"interstitialAdDidFINISH");
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getTopScores{
	PFQuery *query = [PFQuery queryWithClassName:@"GameScore"];
	[query orderByDescending:@"score"];
	query.limit = 10;
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (!error) {
			self.top10Scores = objects;
			NSLog(hasSaved ? @"hasSaved" : @"aintSaved");
			if ([NSNumber numberWithInt:self.score] > [self.top10Scores.lastObject objectForKey:@"score"] && !hasSaved) {
				[self saveToLeaderBoard];
			}
		} else {
			// Log details of the failure
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
	}];
}


-(void)saveToLeaderBoard{
	if (self.firstTime) {
		UIAlertView *alertViewChangeName=[[UIAlertView alloc]initWithTitle:@"HIGH SCORE!" message:@"Add your name to post to the leaderboard!" delegate:self cancelButtonTitle:self.alertViewCancelTitle otherButtonTitles:@"OK", nil];
		alertViewChangeName.alertViewStyle=UIAlertViewStylePlainTextInput;
		[alertViewChangeName show];
	}
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSString *buttonTitle=[alertView buttonTitleAtIndex:buttonIndex];
	if([buttonTitle isEqualToString:self.alertViewCancelTitle]) {
		return;
	}else{
		NSString *username = [[alertView textFieldAtIndex:0] text];
		if (!username || username.length == 0) {
			return;
		}
		PFObject *gameScore = [PFObject objectWithClassName:@"GameScore"];
		gameScore[@"score"] = [NSNumber numberWithInt: self.score];
		gameScore[@"playerName"] = username;
		[gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			if (succeeded) {
				// The object has been saved.
				hasSaved = YES;
				NSLog(@"has saved");
				[self getTopScores];
			} else {
				// There was a problem, check error.description
				NSLog(@"%@", error.localizedDescription);
			}
		}];
	}
}



-(void)takeScreenShot{
	UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	[self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];

	CGRect rec = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	[self.view drawViewHierarchyInRect:rec afterScreenUpdates:YES];
	
	self.screenshot = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();

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
	// Define the dimensions of the screenshot you want to take (the entire screen in this case)
 
	
	UIActivityViewController *activityViewController =
					[[UIActivityViewController alloc] initWithActivityItems:
						@[
							[NSString stringWithFormat:@"I got a new high score of %d on Whip App! Come at me!",self.score],
							[NSURL URLWithString:shareUrl],
							self.screenshot
						]
					  applicationActivities:nil];
	
	activityViewController.excludedActivityTypes = @[
						      UIActivityTypeAirDrop,
						      UIActivityTypeAddToReadingList,
						      UIActivityTypeMail,
						      UIActivityTypePostToFacebook];
	
	[self presentViewController:activityViewController
					   animated:YES
					 completion:^{
						 //nuthin, really
					 }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	NSLog(@"pp4segway");
	if ([segue.identifier isEqualToString:@"leaderboardTapped"]) {
		LeaderBoardViewController *lbvc = segue.destinationViewController;
		lbvc.topScores = self.top10Scores;
		lbvc.score = self.score;
		
	}else if([segue.identifier isEqualToString:@"replayTapped"]){
		GamePlayViewController *gpvc = segue.destinationViewController;
		[self requestInterstitialAdPresentation];
	}
}


@end
