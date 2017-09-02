//
//  DetailViewController.m
//  AvaliacaoPDMiOS
//
//  Created by Treinamento on 02/09/17.
//  Copyright © 2017 Ibratec. All rights reserved.
//

#import "DetailViewController.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import <SVProgressHUD.h>


#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userLabel.text = self.comment[@"user"];
    self.dateLabel.text = self.comment[@"created_at"];
    self.commentLabel.text = self.comment[@"content"];
    
    //Instancia a url da imagem
    NSURL *imageUrl = [NSURL URLWithString: self.comment[@"image"]];
    
    [self.userImage setImageWithURL:imageUrl];
    
    //MAPs
    [self centerMap];
    
    if(![self.comment[@"lat"] isKindOfClass:[NSNull class]]){
        if(![self.comment[@"lng"] isKindOfClass:[NSNull class]]){
            [self setPinOnMapWithLat:self.comment[@"lat"] AndLong:self.comment[@"lng"]];
        }
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    UIImage *image = [UIImage imageNamed:@"comment_pin"];
    
    MKAnnotationView *pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"comment_pin"];
    
    
    if(pinView != nil){
        pinView.annotation = annotation;
    }else{
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"comment_pin"];
        pinView.image = image;
        pinView.centerOffset = CGPointMake(0, -pinView.image.size.height / 2);
    }
    return pinView;
}

- (IBAction)deleteComment:(id)sender {
    //Create a alert to show failed message
    UIAlertController *confirmDelete = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Ocorreu um erro ao tentar deletar o comentário!" preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction* okBtn = [UIAlertAction
                         actionWithTitle:@"Deseja Remover?"
        style:UIAlertActionStyleDefault
        handler:^(UIAlertAction *action){
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            [SVProgressHUD show];
            
            NSString *urlDeleteComment = [NSString stringWithFormat:@"https://teste-aula-ios.herokuapp.com/comments/%@.json", self.comment[@"id"]];
            
            
            [manager DELETE:urlDeleteComment parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                
                [SVProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
                
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



     -(void)setPinOnMapWithLat:(NSNumber *)latitude AndLong: (NSNumber *)longitude{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    MKCoordinateRegion region;
    region.center.latitude = [latitude floatValue];
    region.center.longitude = [longitude floatValue];
    annotation.coordinate = region.center;
    
    NSString *commentAuthor = [NSString stringWithFormat:@"%@ comentou:", self.comment[@"user"]];
    NSString *commentAdded = [NSString stringWithFormat:@"%@", self.comment[@"content"]];
    
    annotation.title = commentAuthor;
    annotation.subtitle = commentAdded;
    
    [self.mapview addAnnotation:annotation];
}

-(void)centerMap{
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = [self.comment[@"lat"] floatValue];
    newRegion.center.longitude = [self.comment[@"lng"] floatValue];
    newRegion.span.latitudeDelta = 0.0005;
    newRegion.span.longitudeDelta = 0.0005;
    
    [self.mapview setRegion:newRegion];
}


@end
