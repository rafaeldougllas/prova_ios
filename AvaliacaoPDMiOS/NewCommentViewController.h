//
//  NewCommentViewController.h
//  AvaliacaoPDMiOS
//
//  Created by Treinamento on 02/09/17.
//  Copyright © 2017 Ibratec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface NewCommentViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    CLLocationManagerDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) IBOutlet UITextField *userField;
@property (strong, nonatomic) IBOutlet UIImageView *imageAttached;
@property (strong, nonatomic) IBOutlet UITextView *commentField;
@property (strong, nonatomic) CLLocationManager *locationManager;



@end
