//
//  TSProfileView.h
//  Linker
//
//  Created by Mac on 15.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSProfileView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *professionLabel;
@property (weak, nonatomic) IBOutlet UILabel *coingToLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentArreaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *countMatchLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIView *likeView;

- (IBAction)mainButtonsAction:(UIButton *)sender;
+ (instancetype)profileView:(NSDictionary *)content;

@end


/*
comingFromLabel
 launguageLabel
 ageLabel
 miniNameLabel
*/
