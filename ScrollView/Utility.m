//
//  Utility.m
//  AnyVideo
//
//  Created by Apple on 06/04/14.
//  Copyright (c) 2014 Abhay. All rights reserved.
//

#import "Utility.h"

#define IOS_NEWER_OR_EQUAL_TO_7 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 7.0 )
@implementation Utility
{

}
static Utility *shared;
//static sqlite3 *database = nil;


- (id)init {
	if (shared) {
        
        return shared;
    }
	
	if (![super init]) return nil;
    
	shared = self;
	return self;
}

+ (id)shared {
    if (!shared) {
        shared = [[Utility alloc] init];
    }
    return shared;
}
-(UIImageView*)GetImageView:(NSString*)strUrl
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"No Image.jpg"]];
    NSURL *Url = [NSURL URLWithString:
                  [[strUrl stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if(Url)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage *avatarImage = nil;
            __block NSData *responseData = [NSData dataWithContentsOfURL:Url];
            avatarImage = [UIImage imageWithData:responseData];
            
            
            if (avatarImage) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = avatarImage;
                });
                
            }
            else {
            }
        });
    }
//    imageView.layer.masksToBounds = NO;
//    imageView.clipsToBounds = YES;
//    [imageView.layer setCornerRadius:10];
  
//     imageView.layer.cornerRadius =  imageView.frame.size.height /2;
//     imageView.layer.masksToBounds = YES;
//     imageView.layer.borderWidth = 0;
    
    return imageView;
}


@end
