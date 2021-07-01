//
//  DetailsViewController.m
//  twitter
//
//  Created by Elisa Jacobo Arill on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "DateTools.h"
#import "APIManager.h"

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
    self.dateLabel.text = [self.tweet.createdAtDate formattedDateWithFormat:@"h:mm a - M/d/yy"];
    
    // refresh tweet and favorite data
    [self refreshData];
    
}

- (IBAction)didTapFavorite:(id)sender {
    // Unfavoring tweets
    if (self.tweet.favorited) {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        [self refreshData];
        
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
             }
         }];
        
    }
    // Favoring tweets
    else {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        
        [self refreshData];
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
    }
}

- (IBAction)didTapRetweet:(id)sender {
    // Unretweeting tweets
    if (self.tweet.retweeted) {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        
        [self refreshData];
        
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unretweeting the following Tweet: %@", tweet.text);
             }
         }];
        
    }
    // Retweeting tweets
    else {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        
        [self refreshData];
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully retweeting the following Tweet: %@", tweet.text);
             }
         }];
    }
    
}

- (void)refreshData {
    // set like and retweet text with num bolded
    UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    UIFont *lightFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    NSMutableAttributedString *likeCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount]];
    [likeCount addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(0,likeCount.length)];
    
    NSMutableAttributedString *likeText = [[NSMutableAttributedString alloc] initWithString:@" Likes"];
    [likeText addAttribute:NSFontAttributeName value:lightFont range:NSMakeRange(0,likeText.length)];
    
    [likeCount appendAttributedString:likeText];
    self.likeLabel.attributedText = likeCount;
    
    
    
    NSMutableAttributedString *retweetCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", self.tweet.retweetCount]];
    [retweetCount addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(0,retweetCount.length)];
    
    NSMutableAttributedString *retweetText = [[NSMutableAttributedString alloc] initWithString:@" Retweets"];
    [retweetText addAttribute:NSFontAttributeName value:lightFont range:NSMakeRange(0,retweetText.length)];
    
    [retweetCount appendAttributedString:retweetText];
    self.retweetLabel.attributedText = retweetCount;
    
    
    // set button image
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
