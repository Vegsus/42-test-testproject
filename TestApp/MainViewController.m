//
//  MainViewController.m
//  TestApp
//
//  Created by Eugene Vegner on 05.04.13.
//  Copyright (c) 2013 Eugeny Vegner. All rights reserved.
//
#define kTagBioView 10

#import "MainViewController.h"
#import "DateConverter.h"
#import "UserItem.h"
#import "Const.h"
#import <QuartzCore/QuartzCore.h>

typedef enum {
    SectionOne = 0,
    SectionTwo = 1,
    SectionThree = 2
} SectionIndex;

typedef enum {
    SelectedRowName = 0,
    SelectedRowSurname = 1,
    SelectedRowBirthDate = 2,
    SelectedRowAddress = 3,
    SelectedRowZip = 4,
    SelectedRowEmail = 5,
    SelectedRowBio = 6
} SelectedRow;


@interface MainViewController ()
@property (nonatomic, retain) UserItem *user;
@property (nonatomic, assign) SelectedRow selectedRow;


@end

@implementation MainViewController
@synthesize user = _user;
@synthesize selectedRow = _selectedRow;

- (void)dealloc {
    [mTableView release];
    [mBioTextView release];
    [mHeaderView release];
    [mPhotoView release];
    [mPhoto release];
    [lbName release];
    [lbSurname release];
    self.user = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Main", @"");
        UIBarButtonItem *backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
        self.navigationItem.backBarButtonItem = backBarButtonItem;
        [self loadData];
    }
    return self;
}

- (void)loadData {
    self.user = [[DBEngine sharedInstance] getUser];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mPhotoView.layer.cornerRadius = kBorderRadius;
    mPhotoView.layer.borderWidth = 1.0;
    mPhotoView.layer.borderColor = [kCellBorderColor CGColor];
    mPhotoView.layer.masksToBounds = YES;

}

- (void)photoTaped {
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:@"Select Photo"
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:@"Clear photo"
                                                     otherButtonTitles:@"Take Photo", @"Choose Existing Photo", nil] autorelease];
    [actionSheet showInView:self.tabBarController.view];
}

#pragma mark - EditPhoto

- (void)clearPhoto {
    mPhoto.image = nil;
}

- (void)takePhoto {
	UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
	imagePicker.delegate = self;
	imagePicker.allowsEditing = YES;
	imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
	[self presentViewController:imagePicker animated:YES completion:^{}];
}

- (void)choosePhoto {
	UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
	imagePicker.delegate = self;
	imagePicker.allowsEditing = YES;
	imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentViewController:imagePicker animated:YES completion:^{}];
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: [self clearPhoto]; break;
        case 1: [self takePhoto]; break;
        case 2: [self choosePhoto]; break;
    }
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SectionOne:
            return 3;
            break;
        case SectionTwo:
            return 3;
            break;
        case SectionThree:
            return 1;
            break;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == SectionOne) ? mHeaderView.frame.size.height : 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section == SectionThree)?10.0:5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == SectionThree) {
        CGRect frameBio = mBioTextView.frame;
        frameBio.size.height = mBioTextView.contentSize.height+20;
        return (frameBio.size.height <= 44.0)?44.0:frameBio.size.height;
    }
    return 44.0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != SectionOne) return nil;
    mPhoto.image = self.user.avatar;
    lbName.text = self.user.name;
    lbSurname.text = self.user.surname;
    return mHeaderView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == SectionThree){
        static NSString *textViewCellIdentifier = @"textViewCellIdentifier";
        UITextView *textView = nil;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textViewCellIdentifier];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textViewCellIdentifier] autorelease];
            [cell addSubview:mBioTextView];
            [mBioTextView setFrame:CGRectMake(10, 10, cell.bounds.size.width-20, cell.bounds.size.height-20)];
            mBioTextView.tag = kTagBioView;
        }
        textView = ((UITextView *)[cell viewWithTag:kTagBioView]);
        textView.text = self.user.bio;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;

    } else {
        static NSString *cellIdentifier = @"cellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        switch (indexPath.section) {
            case SectionOne:
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                switch (indexPath.row) {
                    case 0: //Name cell
                        cell.textLabel.text = NSLocalizedString(@"Name", nil);
                        cell.detailTextLabel.text = self.user.name;
                        break;
                        
                    case 1: //Surname cell
                        cell.textLabel.text = NSLocalizedString(@"Surname", nil);
                        cell.detailTextLabel.text = self.user.surname;
                        break;
                        
                    case 2: //BirthDate cell
                        cell.textLabel.text = NSLocalizedString(@"Birth Date", nil);
                        cell.detailTextLabel.text = [DateConverter convertDateToString:self.user.birthDate withFormat:@"MMM, dd yyyy"];
                        break;
                }
                break;
                
            case SectionTwo:
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                switch (indexPath.row) {
                    case 0: //Address cell
                        cell.textLabel.text = NSLocalizedString(@"Address", nil);
                        cell.detailTextLabel.text = self.user.address;
                        break;
                        
                    case 1: //Zip cell
                        cell.textLabel.text = NSLocalizedString(@"ZIP", nil);
                        cell.detailTextLabel.text = self.user.zip;
                        break;
                        
                    case 2: //Email cell
                        cell.textLabel.text = NSLocalizedString(@"Email", nil);
                        cell.detailTextLabel.text = self.user.email;
                        break;
                }
                break;
        }
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SectionOne:
            switch (indexPath.row) {
                case 0: self.selectedRow = SelectedRowName; break;
                case 1: self.selectedRow = SelectedRowSurname; break;
                case 2: self.selectedRow = SelectedRowBirthDate;break;
            }
            break;
            
        case SectionTwo:
            switch (indexPath.row) {
                case 0: self.selectedRow = SelectedRowAddress; break;
                case 1: self.selectedRow = SelectedRowZip; break;
                case 2: self.selectedRow = SelectedRowEmail; break;
            }
            break;
            
        case SectionThree:
            switch (indexPath.row) {
                case 0: self.selectedRow = SelectedRowBio; break;
            }
            break;
    }
}

#pragma mark - TextEditorDelegate  

- (void)textEditorWithText:(NSString *)text {
    switch (self.selectedRow) {
        case SelectedRowName: self.user.name = text; break;
        case SelectedRowSurname: self.user.surname = text; break;
        case SelectedRowBirthDate: /*DateEditor*/ break;
        case SelectedRowAddress: self.user.address = text; break;
        case SelectedRowZip: self.user.zip = text; break;
        case SelectedRowEmail: self.user.email = text; break;
        case SelectedRowBio: self.user.bio = text; break;
    }
    [mTableView reloadData];
}


#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.user.avatar = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(self.user.avatar, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    UIAlertView *alert;
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                           message:NSLocalizedString(@"Unable to save image to Photo Album.", nil)
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
	else
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil)
                                           message:NSLocalizedString(@"Image saved to Photo Album.", nil)
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
