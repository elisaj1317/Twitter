//
//  DetailsViewController.m
//  twitter
//
//  Created by Elisa Jacobo Arill on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "DateTools/DateTools.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up labels
    self.nameLabel.text = self.tweet.user.name;
    self.userLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.bodyLabel.text = self.tweet.text;
    
    // set up profile image
    NSString *URLString = self.tweet.user.profilePicture;
    URLString = [URLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    self.profileImage.layer.masksToBounds = false;
    self.profileImage.layer.cornerRadius = 28;
    self.profileImage.clipsToBounds = true;

    
    self.profileImage.image = [UIImage imageWithData:urlData];
    
    // set date
    self.dateLabel.text = [self.tweet.createdAtDate formattedDateWithFormat:@"h:mm a - M/dd/yy"];
    
    // refresh tweet and favorite data
    [self refreshData];
    
}

- (void)refreshData {
//    [self.likeButton setTitle:[NSString stringWithFormat:@"%d",self.tweet.favoriteCount] forState:UIControlStateNormal];
//
//    [self.retweetButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.retweetCount] forState:UIControlStateNormal];
    
    self.likeLabel.text = [NSString stringWithFormat:@"%d Likes", self.tweet.favoriteCount];
    self.retweetLabel.text = [NSString stringWithFormat:@"%d Retweets", self.tweet.retweetCount];
    
    if (self.tweet.favorited) {
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    }
    else {
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
    
    if (self.tweet.retweeted) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    }
    else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    }
    
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
