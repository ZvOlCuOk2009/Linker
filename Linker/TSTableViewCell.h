//
//  TSTableViewCell.h
//  Linker
//
//  Created by Mac on 17.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarUser;
@property (weak, nonatomic) IBOutlet UIView *blueRectangle;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end
