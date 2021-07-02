//
//  User.m
//  twitter
//
//  Created by Elisa Jacobo Arill on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profilePicture = dictionary[@"profile_image_url_https"];
        self.backdropPicture = dictionary[@"profile_banner_url"];
        self.profileDescription = dictionary[@"description"];
        self.followersCount = dictionary[@"followers_count"];
        self.followingCount = dictionary[@"friends_count"];
    }
    return self;
}

@end
