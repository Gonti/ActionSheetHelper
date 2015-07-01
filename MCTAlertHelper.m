#import "MCTAlertHelper.h"

@interface MCTAlertHelper () <UIActionSheetDelegate, UIAlertViewDelegate>

@property (weak) UIViewController *controller;
@property NSMutableDictionary *titlesAndActions;
@property NSMutableArray *sortedActions;
@property NSString *cancel;
@property UIAlertControllerStyle style;
@property NSString *title;
@property NSString *message;
@property UIAlertView *alertView;
@property UIActionSheet *actionSheet;

@end

@implementation MCTAlertHelper

- (id)initWithViewController:(UIViewController *)controller cancelButtonTitle:(NSString *)cancel style:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message {
    return [self initWithViewController:controller array:[[NSArray alloc] init] dictionary:[[NSDictionary alloc] init] cancelButtonTitle:cancel style:style title:title message:message];
}

- (id)initWithViewController:(UIViewController *)controller array:(NSArray *)sortedTitles dictionary:(NSDictionary *)blocksAndTitiles cancelButtonTitle:(NSString *)cancel style:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message {
    self = [super init];
    if (self) {
        self.controller = controller;
        self.titlesAndActions = [blocksAndTitiles mutableCopy];
        self.sortedActions = [sortedTitles mutableCopy];
        self.cancel = cancel;
        self.style = style;
        self.title = title;
        self.message = message;
    }
    return self;
}

- (void)presentAlert {
    // iOS 8.x+
    if ([UIAlertController class]) {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:self.title message:self.message preferredStyle:self.style];
        for (NSString *title in self.sortedActions) {
            [alertController addAction:[UIAlertAction actionWithTitle:title
                                                                style:UIAlertActionStyleDefault
                                                              handler:self.titlesAndActions[title]]];
        }
        [alertController addAction:[UIAlertAction actionWithTitle:self.cancel style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self.controller presentViewController:alertController animated:YES completion:nil];
    }
    // iOS 7.x
    else {
        switch (self.style) {
            case UIAlertControllerStyleActionSheet:
                [self createAndDisplayActionSheet];
                break;
            case UIAlertControllerStyleAlert:
                [self createAndDisplayAlertView];
                break;
        }
        
    }
}

- (void)createAndDisplayActionSheet {
   self.actionSheet = [[UIActionSheet alloc] init];
    if (self.message) {
        NSMutableString *titleAndMessage = [self.title mutableCopy];
        [titleAndMessage appendFormat:@"\n\n"];
        [titleAndMessage appendFormat:@"%@",self.message];
    }
    else {
        self.actionSheet.title = self.title;
    }
    self.actionSheet.delegate = self;
    for (NSString *title in self.sortedActions) {
        [self.actionSheet addButtonWithTitle:title];
    }
    [self.actionSheet addButtonWithTitle:self.cancel];
    self.actionSheet.cancelButtonIndex = self.sortedActions.count;
    [self.actionSheet showInView:self.controller.view];
}

- (void)createAndDisplayAlertView {
    self.alertView = [[UIAlertView alloc] init];
    self.alertView.title = self.title;
    self.alertView.message = self.message;
    self.alertView.delegate = self;
    for (NSString *title in self.sortedActions) {
        [self.alertView addButtonWithTitle:title];
    }
    [self.alertView addButtonWithTitle:self.cancel];
    self.alertView.cancelButtonIndex = self.sortedActions.count;
    [self.alertView show];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == self.sortedActions.count) {
        [actionSheet resignFirstResponder];
        return;
    }
    NSString *key = self.sortedActions[buttonIndex];
    void (^action)(UIAlertAction * action) = self.titlesAndActions[key];
    action(nil);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == self.sortedActions.count) {
        [alertView resignFirstResponder];
        return;
    }
    NSString *key = self.sortedActions[buttonIndex];
    void (^action)(UIAlertAction * action) = self.titlesAndActions[key];
    action(nil);
}

- (void)addTitle:(NSString *)title WithAction:(void (^)(UIAlertAction *))blockAction {
    [self.titlesAndActions setObject:blockAction forKey:title];
    [self.sortedActions addObject:title];
}

- (void)dealloc {
    [self.alertView dismissWithClickedButtonIndex:self.alertView.cancelButtonIndex animated:NO];
    [self.actionSheet dismissWithClickedButtonIndex:self.alertView.cancelButtonIndex animated:NO];
}

@end
