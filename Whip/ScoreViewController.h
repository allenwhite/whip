//
//  ScoreViewController.h
//  Whip
//
//  Created by Allen White on 10/8/15.
//  Copyright © 2015 Worldwide International. All rights reserved.
//

#import <UIKit/UIKit.h>
@import iAd;

@interface ScoreViewController : UIViewController<ADInterstitialAdDelegate>

@property (strong, nonatomic) IBOutlet UILabel *bestScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *wasHighScoreLabel;
- (IBAction)shareToFBTapped:(id)sender;
@property int score;
@property BOOL firstTime;
@property (strong, nonatomic) IBOutlet UIButton *leaderboardButton;

@end
