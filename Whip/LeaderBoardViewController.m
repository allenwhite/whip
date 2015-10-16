//
//  LeaderBoardViewController.m
//  Whip
//
//  Created by Allen White on 10/16/15.
//  Copyright © 2015 Worldwide International. All rights reserved.
//

#import "LeaderBoardViewController.h"
#import "HighScoreTableViewCell.h"
#import "ScoreViewController.h"

@interface LeaderBoardViewController ()
@property (strong, nonatomic) IBOutlet UITableView *highScoresTableView;
@end

@implementation LeaderBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.highScoresTableView.delegate = self;
	self.highScoresTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	ScoreViewController *svc = segue.destinationViewController;
	svc.score = self.score;
	svc.firstTime = NO;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.topScores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	HighScoreTableViewCell *cell = (HighScoreTableViewCell *)[self.highScoresTableView dequeueReusableCellWithIdentifier:@"HighScoreTableViewCell"];
	if (!cell) {
		NSLog(@"cell: %@", cell);		
	}

	cell.backgroundColor = [UIColor clearColor];
	cell.backgroundView = [UIView new];
	cell.selectedBackgroundView = [UIView new];
	
	// Configure the cell for this indexPath
	cell.nameLabel.text = [[self.topScores objectAtIndex:indexPath.row] objectForKey:@"playerName"];
	cell.scoreLabel.text = [NSString stringWithFormat:@"%@", [[self.topScores objectAtIndex:indexPath.row] objectForKey:@"score"] ];
	// Make sure the constraints have been added to this cell, since it may have just been created from scratch
//	[cell setNeedsUpdateConstraints];
//	[cell updateConstraintsIfNeeded];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70;
}


@end
