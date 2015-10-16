//
//  LeaderBoardViewController.h
//  Whip
//
//  Created by Allen White on 10/16/15.
//  Copyright © 2015 Worldwide International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderBoardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *topScores;
@property int score;

@end
