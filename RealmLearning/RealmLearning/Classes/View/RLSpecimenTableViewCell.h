//
//  RLSpecimenTableViewCell.h
//  RealmLearning
//
//  Created by PeterWang on 1/7/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLSpecimenTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end
