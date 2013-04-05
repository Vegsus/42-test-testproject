//
//  TextEditorViewController.h
//  TestApp
//
//  Created by Eugene Vegner on 05.04.13.
//  Copyright (c) 2013 Eugeny Vegner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextEditorViewControllerDelegate;

@interface TextEditorViewController : UIViewController <UITextViewDelegate> {
    IBOutlet UITextView *mTextView;
}
@property (nonatomic, assign) id<TextEditorViewControllerDelegate> delegate;
+ (TextEditorViewController *)textEditorWithText:(NSString *)text andTitle:(NSString *)title;
@end

@protocol TextEditorViewControllerDelegate <NSObject>
- (void)textEditorWithText:(NSString *)text;

@end
