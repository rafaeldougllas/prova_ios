//
//  CommentsViewController.m
//  AvaliacaoPDMiOS
//
//  Created by Treinamento on 02/09/17.
//  Copyright © 2017 Ibratec. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentTableViewCell.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import <SVProgressHUD.h>
#import "DetailViewController.h"


@interface CommentsViewController ()

@end

@implementation CommentsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    // Do any additional setup after loading the view.
    
    //Inicializa os parametros
    self.comments = [NSMutableArray arrayWithArray: @[]];
    self.page = 1;
    
    // Isso aqui diz pra o iOS não criar espaços em cima das scrollviews, por causa do navigation bar
    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    //Caso entre no detail e tem um filtro antes para não recarregar
    if(!_isFiltered){
        [self refreshData];
    }
    
}


- (IBAction)refresh:(id)sender {
    [self refreshData];
}


- (void)refreshData {
    self.page = 1;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [SVProgressHUD show];
    [manager GET:@"https://teste-aula-ios.herokuapp.com/comments.json"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [SVProgressHUD dismiss];
             self.comments = [NSMutableArray arrayWithArray:responseObject];
             [self.tableView reloadData];
         }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [SVProgressHUD dismiss];
             NSLog(@"Error: %@", error);
         }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *comment = self.comments[indexPath.row];
    cell.user_label.text = comment[@"user"];
    cell.comment_label.text = comment[@"content"];
    cell.date_label.text = [comment[@"created_at"] substringToIndex:10];
    [cell.image_user setImageWithURL:[NSURL URLWithString:comment[@"image"]]
                 placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
    
    
    if (indexPath.row == [self.comments count] - 1) {
        // Última célula, tenta carregar mais
        [self loadNextPage];
    }
    
    return cell;
    
}

- (void) loadNextPage {
    if (self.page == -1)
        return;
    self.page += 1;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    [manager GET:@"https://teste-aula-ios.herokuapp.com/comments.json"
      parameters:@{@"page":@(self.page)}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if ([responseObject count] == 0) {
                 // This will stop pagination from happening
                 self.page = -1;
             } else {
                 [self.comments addObjectsFromArray:responseObject];
                 [self.tableView reloadData];
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
    
    self.tempArray = self.comments;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Update data source array here, something like [array removeObjectAtIndex:indexPath.row];
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSDictionary *comment;
        if(self.tempArray.count){
            comment = self.tempArray[indexPath.row];

        }else{
            comment = self.comments[indexPath.row];

        }
        
        
        
        //Create a alert to show failed message
        UIAlertController *confirmDelete = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Ocorreu um erro ao tentar deletar o comentário!" preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction* okBtn = [UIAlertAction
                                actionWithTitle:@"Deseja Remover?"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action){
                                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                                    manager.requestSerializer = [AFJSONRequestSerializer serializer];
                                    
                                    [SVProgressHUD show];
                                    
                                    NSString *urlDeleteComment = [NSString stringWithFormat:@"https://teste-aula-ios.herokuapp.com/comments/%@.json", comment[@"id"]];
                                    
                                    
                                    [manager DELETE:urlDeleteComment parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                        
                                        [SVProgressHUD dismiss];
                                        [self refreshData];
                                        
                                    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                                        //Create a alert to show failed message
                                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Ocorreu um erro ao tentar deletar o comentário!" preferredStyle: UIAlertControllerStyleAlert];
                                        
                                        UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"Ok"  style:UIAlertActionStyleDefault
                                                                                         handler:nil];
                                        
                                        [alertController addAction:okButton];
                                        
                                        [self presentViewController:alertController animated:YES completion:nil];
                                        
                                        [SVProgressHUD dismiss];
                                        
                                    }];
                                    
                                }];
        
                                UIAlertAction* cancelBtn = [UIAlertAction actionWithTitle:@"Cancelar"  style:UIAlertActionStyleDefault
                                                          handler:nil];
        
                                [confirmDelete addAction:okBtn];
                                [confirmDelete addAction:cancelBtn];
        
                                [self presentViewController:confirmDelete animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    NSDictionary *comment = self.comments[indexPath.row];
    
    detailViewController.comment = comment;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}


- (IBAction)logout:(id)sender {
    UINavigationController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if(searchText.length == 0)
    {
        
        self.comments  = self.tempArray;
        self.isFiltered = NO;
    }
    else
    {
        self.isFiltered = YES;
        NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"user contains[c] %@",searchText];
        self.comments  =[NSMutableArray arrayWithArray:[self.tempArray filteredArrayUsingPredicate:predicate]];
        
    }
    
    [self.tableView reloadData];
    [searchBar becomeFirstResponder];
}





@end
