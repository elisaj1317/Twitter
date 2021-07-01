//
//  ComposeViewController.m
//  twitter
//
//  Created by Elisa Jacobo Arill on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textView.placeholder = @"What's happening?";
    self.textView.placeholderColor = [UIColor lightGrayColor];
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [UIColor colorWithRed:29.0/255.0 green:161.0/255.0 blue:242.0/255.0 alpha:1.0].CGColor;
    
    [self fetchUser];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.textView becomeFirstResponder];
}

- (void) fetchUser {
    [[APIManager shared] getUserProvileWithCompletion:^(User *user, NSError *error) {
        if (user) {
            NSString *URLString = user.profilePicture;
            URLString = [URLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
            NSURL *url = [NSURL URLWithString:URLString];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            
            self.profileImage.layer.masksToBounds = false;
            self.profileImage.layer.cornerRadius = 28;
            self.profileImage.clipsToBounds = true;

            
            self.profileImage.image = [UIImage imageWithData:urlData];
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        
    }];
}

- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (IBAction)didTapPost:(id)sender {
    [[APIManager shared]postStatusWithText:self.textView.text completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
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
