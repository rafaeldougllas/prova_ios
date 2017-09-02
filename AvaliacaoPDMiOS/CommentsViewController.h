//
//  CommentsViewController.h
//  AvaliacaoPDMiOS
//
//  Created by Treinamento on 02/09/17.
//  Copyright © 2017 Ibratec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (strong) NSMutableArray *comments;
@property (nonatomic) int page;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *tempArray;
@property (strong, nonatomic) IBOutlet UISearchBar *searchTextBar;
@property (nonatomic) BOOL isFiltered;

@end
