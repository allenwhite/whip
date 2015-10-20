//
//  GamePlayViewController.h
//  Whip
//
//  Created by Allen White on 10/8/15.
//  Copyright © 2015 Worldwide International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface GamePlayViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *feedbackLabel;
@property ADInterstitialAd *iad;
@end
