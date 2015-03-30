//
//  MasterCell.h
//  GoogleNews
//
//  Created by Jocelyn on 2/22/15.
//  Copyright (c) 2015 Jocelyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterLabel.h"

@interface MasterCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;

@end
