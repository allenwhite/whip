//
//  ScoreViewController.h
//  Whip
//
//  Created by Allen White on 10/8/15.
//  Copyright © 2015 Worldwide International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *bestScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *wasHighScoreLabel;
- (IBAction)shareToFBTapped:(id)sender;
- (IBAction)shareToTwitterTapped:(id)sender;
- (IBAction)replayButtonTapped:(id)sender;
@property int score;

@end
