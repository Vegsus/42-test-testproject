//
//  MainViewController.h
//  TestApp
//
//  Created by Eugene Vegner on 05.04.13.
//  Copyright (c) 2013 Eugeny Vegner. All rights reserved.
//

#import "MainViewController.h"
#import "TextEditorViewController.h"
#import "DateEditorViewController.h"
#import "DBEngine.h"

@interface MainViewController : UIViewController <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, TextEditorViewControllerDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate> {
    IBOutlet UITableView *mTableView;
    IBOutlet UIView *mHeaderView;
    IBOutlet UIImageView *mPhoto;
    IBOutlet UIView *mPhotoView;
    IBOutlet UITextView *mBioTextView;
    IBOutlet UILabel *lbName;
    IBOutlet UILabel *lbSurname;
}

@end
