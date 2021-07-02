//
//  ProfileViewController.m
//  twitter
//
//  Created by Elisa Jacobo Arill on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "TweetCell.h"
#import "APIManager.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSMutableArray *arrayOfTweets;

@property (weak, nonatomic) IBOutlet UIImageView *profileBackdropImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchUser];
    
}

- (void) fetchUser {
    [[APIManager shared] getUserProvileWithCompletion:^(User *user, NSError *error) {
        if (user) {
            self.user = user;
            [self fetchUserTimeline];
            [self setUpHeader];
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        
    }];
}

- (void) setUpHeader {
    self.profileNameLabel.text = self.user.name;
    self.profileScreenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    self.profileDescriptionLabel.text = self.user.profileDescription;
    
    UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    UIFont *lightFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    
    NSMutableAttributedString *followersCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", self.user.followersCount]];
    [followersCount addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(0,followersCount.length)];
    
    NSMutableAttributedString *followersText = [[NSMutableAttributedString alloc] initWithString:@" Followers"];
    [followersText addAttribute:NSFontAttributeName value:lightFont range:NSMakeRange(0,followersText.length)];
    
    [followersCount appendAttributedString:followersText];
    self.followersLabel.attributedText = followersCount;
    
    NSMutableAttributedString *followingCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", self.user.followingCount]];
    [followingCount addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(0,followingCount.length)];
    
    NSMutableAttributedString *followingText = [[NSMutableAttributedString alloc] initWithString:@" Following"];
    [followingText addAttribute:NSFontAttributeName value:lightFont range:NSMakeRange(0,followingText.length)];
    
    [followingCount appendAttributedString:followingText];
    self.followingLabel.attributedText = followingCount;

    
    
    self.profileImageView.layer.masksToBounds = false;
    self.profileImageView.layer.cornerRadius = 33;
    self.profileImageView.clipsToBounds = true;
    
    self.profileImageView.image = [UIImage imageWithData:[self changeStringUrl:self.user.profilePicture]];
    
    self.profileBackdropImage.image = [UIImage imageWithData:[self changeStringUrl:self.user.backdropPicture]];
    
    
}

- (NSData *) changeStringUrl: (NSString *)URLString {
    NSString *URLStringCopy = [NSString stringWithFormat:@"%@", URLString];
    URLStringCopy = [URLStringCopy stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *url = [NSURL URLWithString:URLStringCopy];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    return urlData;
}

- (void) fetchUserTimeline {
    [[APIManager shared] getUserTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"Got user TimeLine");
            self.arrayOfTweets = [NSMutableArray arrayWithArray:tweets];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error");
            
        }
    } withScreenName:self.user.screenName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet = self.arrayOfTweets[indexPath.row];
    
    return cell;

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
