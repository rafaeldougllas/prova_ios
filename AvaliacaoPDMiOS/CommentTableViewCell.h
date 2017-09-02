//
//  CommentTableViewCell.h
//  AvaliacaoPDMiOS
//
//  Created by Treinamento on 02/09/17.
//  Copyright © 2017 Ibratec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *image_user;

@property (strong, nonatomic) IBOutlet UILabel *comment_label;

@property (strong, nonatomic) IBOutlet UILabel *user_label;

@property (strong, nonatomic) IBOutlet UILabel *date_label;

@end
