//
//  GamePlayViewController.m
//  Whip
//
//  Created by Allen White on 10/8/15.
//  Copyright © 2015 Worldwide International. All rights reserved.
//

#import "GamePlayViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "ScoreViewController.h"
#import <AudioToolbox/AudioServices.h>

@interface GamePlayViewController ()<ADInterstitialAdDelegate>

@property CMMotionManager *motionManager;

@end

@implementation GamePlayViewController

double samplesPerSecond = 100.0;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	// Request to turn on accelerometer and begin receiving accelerometer events
	
	//wait 1 second, then do this...
	self.motionManager = [CMMotionManager new];
	[self.motionManager setAccelerometerUpdateInterval:(1.0/samplesPerSecond)];
	if (self.iad) {
		self.iad.delegate = self;
	}else{
		if (self.motionManager.deviceMotionAvailable) {
			[self startGame];
		}
	}
	
}


-(void)viewDidAppear:(BOOL)animated{
	if (!self.motionManager.deviceMotionAvailable) {
		ScoreViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreViewController"];
		svc.score = 0.0;
		svc.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
		svc.firstTime = YES;
		[self presentViewController:svc animated:NO completion:nil];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)startGame{
	__block int hundrethsOfASecond = 0;
	float gravityThreshold = -0.8;
	__block BOOL wasFaceUp = NO;
	__block int whipStartTime = 0;
	__block float maxAccelX = 0;
	float timeFrameToWhip = 200;
	[self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
		//if one sec has passed
		hundrethsOfASecond++;
		if (hundrethsOfASecond > samplesPerSecond) {
			
			//time's up!
			if (hundrethsOfASecond - whipStartTime > timeFrameToWhip && wasFaceUp) {
				[self.motionManager stopDeviceMotionUpdates];
				NSLog(@"New High: %f", maxAccelX);
				NSLog(@"New High: %f", maxAccelX *maxAccelX * 13.0);
				//9.255727
				dispatch_async(dispatch_get_main_queue(), ^{
//					AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
					AudioServicesPlayAlertSound(1352);

					ScoreViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreViewController"];
					svc.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
					svc.score = maxAccelX * maxAccelX * 13.0;
					svc.firstTime = YES;
					[self presentViewController:svc animated:NO completion:nil];
				});
			}
			
			
			//if is face up or was since one second
			if (wasFaceUp || motion.gravity.z < gravityThreshold) {
				if (!wasFaceUp) {
					dispatch_async(dispatch_get_main_queue(), ^{
						AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
						self.feedbackLabel.text = @"NOW WHIP!!!";
					});
					wasFaceUp = YES;
					whipStartTime = hundrethsOfASecond;
				}
				double currentAccel = motion.userAcceleration.x;
				if (fabs(currentAccel) > 2.0) {
					if (fabs(currentAccel) > maxAccelX) {
						maxAccelX = fabs(currentAccel);
						NSLog(@"acc x: %f", motion.userAcceleration.x);
					}
				}
			}
		}
	}];
	
	
	
	
//	NSLog(@"attitude: %@", motion.attitude);
	//				NSLog(@"rotationrate x: %f", motion.rotationRate.x);
	//				NSLog(@"rotationrate y: %f", motion.rotationRate.y);
	//				NSLog(@"rotationrate z: %f", motion.rotationRate.z);
	//				NSLog(@"gravity x: %f", motion.gravity.x);
	//				NSLog(@"gravity y: %f", motion.gravity.y);
	//				NSLog(@"gravity z: %f", motion.gravity.z);
	//				NSLog(@"acc x: %f", motion.userAcceleration.x);
	//				NSLog(@"acc y: %f", motion.userAcceleration.y);
	//				NSLog(@"acc z: %f", motion.userAcceleration.z);
	//
	//				NSLog(@"######################################################");
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
	[self startGame];
}




-(void) viewDidDisappear {
	// Request to stop receiving accelerometer events and turn off accelerometer
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}


@end
