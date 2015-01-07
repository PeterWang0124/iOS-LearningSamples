//
//  RLAddNewEntryViewController.m
//  RealmLearning
//
//  Created by PeterWang on 1/5/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "RLAddNewEntryViewController.h"

//Model
#import "RLSpecimen.h"
#import "RLCategory.h"

//Controller
#import "RLCategoryViewController.h"

@interface RLAddNewEntryViewController () <UITextFieldDelegate, RLCategoryViewControllerDelegate>

@property (strong, nonatomic) RLSpecimen *specimen;
@property (strong, nonatomic) RLCategory *seletedCategory;

@property (strong, nonatomic) UIBarButtonItem *confirmButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation RLAddNewEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add New Entry.";
    
    //Init View
    self.confirmButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(clickConfirmButton)];
    
    self.nameTextField.text = self.specimen.name;
    self.categoryTextField.text = self.specimen.category.name;
    self.descriptionTextView.text = self.specimen.specimenDescription;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Set NavigationBar
    self.navigationItem.rightBarButtonItems = @[self.confirmButton];
}

#pragma mark - Setting

- (void)setSpecimen:(RLSpecimen *)specimen {
    _specimen = specimen;
}

#pragma mark - UIBarButtonItem action

- (void)clickConfirmButton {
    [[RLMRealm defaultRealm] beginWriteTransaction];
    self.specimen.name = self.nameTextField.text;
    self.specimen.category = self.seletedCategory;
    self.specimen.specimenDescription = self.descriptionTextView.text;
    [[RLMRealm defaultRealm] commitWriteTransaction];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.categoryTextField) {
        [textField resignFirstResponder];
        RLCategoryViewController *controller = [[RLCategoryViewController alloc] initWithNibName:NSStringFromClass([RLCategoryViewController class]) bundle:[NSBundle mainBundle]];
        controller.delegate = self;
        
        //Clear title.
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - RLCategoryViewControllerDelegate

- (void)RLCategoryViewController:(RLCategoryViewController *)controller didSelectedCategory:(RLCategory *)category {
    self.categoryTextField.text = category.name;
    self.seletedCategory = category;
}

@end
