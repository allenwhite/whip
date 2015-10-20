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
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface ScoreViewController (){
	ADInterstitialAd *interstitial;
}
@property UIImage *screenshot;
@property NSArray *top10Scores;

@end

@implementation ScoreViewController

bool hasSaved = NO;

NSString *shareUrl = @"http://www.cantstopthecrop.com";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.score];
	[self populateHighScore];
	interstitial = [[ADInterstitialAd alloc] init];
	self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
	[self takeScreenShot];
	[self getTopScores];
}


-(void)viewDidLayoutSubviews{
	FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
	photo.image = self.screenshot;
	photo.userGenerated = YES;
	photo.caption = [NSString stringWithFormat:@"I got a new high score of %d on Whip App! Come at me!",self.score];
	FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
	content.photos = @[photo];
	content.contentURL = [NSURL
			      URLWithString:shareUrl];
	FBSDKShareButton *shareButton = [[FBSDKShareButton alloc] initWithFrame:CGRectMake(
											   self.leaderboardButton.frame.origin.x,
											   self.leaderboardButton.frame.origin.y + 76,
											   self.leaderboardButton.frame.size.width,
											   self.leaderboardButton.frame.size.height)];
	shareButton.shareContent = content;
	shareButton.titleLabel.font = [UIFont fontWithName:@"Game over" size:100];
	[self.view addSubview:shareButton];
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
		UIAlertView *alertViewChangeName=[[UIAlertView alloc]initWithTitle:@"HIGH SCORE!" message:@"Add your name to post to the leaderboard!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
		alertViewChangeName.alertViewStyle=UIAlertViewStylePlainTextInput;
		[alertViewChangeName show];
	}
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
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



-(void)takeScreenShot{
	CGSize size =  [[UIScreen mainScreen] bounds].size;
 
	// Create the screenshot
	UIGraphicsBeginImageContext(size);
	// Put everything in the current view into the screenshot
	[[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
	// Save the current image context info into a UIImage
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
		[self requestInterstitialAdPresentation];
	}
}


@end
