//
//  TextEditorViewController.m
//  TestApp
//
//  Created by Eugene Vegner on 05.04.13.
//  Copyright (c) 2013 Eugeny Vegner. All rights reserved.
//

#import "TextEditorViewController.h"

@interface TextEditorViewController ()
@property (nonatomic, retain) NSString *text;

@end

@implementation TextEditorViewController
@synthesize text = _text;

- (void)dealloc {
    self.text = nil;
    [super dealloc];
}

+ (TextEditorViewController *)textEditorWithText:(NSString *)text andTitle:(NSString *)title {
    TextEditorViewController *controller = [[[TextEditorViewController alloc] initWithNibName:@"TextEditorViewController" bundle:nil andTitle:title] autorelease];
    controller.text = text;
    return controller;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTitle:(NSString *)title {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [mTextView becomeFirstResponder];
    [mTextView setText:self.text];
}

#pragma mark - UITextView Delegate

- (BOOL)textView:(UITextView *)atextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        
        return NO;
    }
    return YES;
}

#pragma mark - Keyboard Delegate

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame = mTextView.frame;
    frame.size.height = self.view.bounds.size.height-keyboardFrame.size.height-49;
    [UIView animateWithDuration:0.25 animations:^{
        [mTextView setFrame:frame];
    }];
}

//- (void)keyboardWillHide:(NSNotification *)notification {
////
//}

- (void)viewDidAppear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
