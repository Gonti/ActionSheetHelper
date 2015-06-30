#import "MCTActionSheetHelper.h"

@interface MCTActionSheetHelper () <UIActionSheetDelegate>

@property (weak) UIViewController *controller;
@property NSMutableDictionary *titlesAndActions;
@property NSMutableArray *sortedActions;
@property NSString *cancel;

@end

@implementation MCTActionSheetHelper

- (id)initWithViewController:(UIViewController *)controller cancelButtonTitle:(NSString *)cancel {
    return [self initWithViewController:controller array:[[NSArray alloc] init] dictionary:[[NSDictionary alloc] init] cancelButtonTitle:cancel];
}

- (id)initWithViewController:(UIViewController *)controller array:(NSArray *)sortedTitles dictionary:(NSDictionary *)blocksAndTitiles cancelButtonTitle:(NSString *)cancel {
    self = [super init];
    if (self) {
        self.controller = controller;
        self.titlesAndActions = [blocksAndTitiles mutableCopy];
        self.sortedActions = [sortedTitles mutableCopy];
        self.cancel = cancel;
    }
    return self;
}

- (void)presentActionSheet {
    // iOS 8.x+
    if ([UIAlertController class]) {
        UIAlertController* alertController = [[UIAlertController alloc] init];
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
    //iOS 7.x
    else {
        UIActionSheet *selectPictureSource = [[UIActionSheet alloc] init];
        selectPictureSource.delegate = self;
        for (NSString *title in self.sortedActions) {
            [selectPictureSource addButtonWithTitle:title];
        }
        [selectPictureSource addButtonWithTitle:self.cancel];
        selectPictureSource.cancelButtonIndex = self.sortedActions.count;
        [selectPictureSource showInView:self.controller.view];
    }
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

- (void)addTitle:(NSString *)title WithAction:(void (^)(UIAlertAction *))blockAction {
    [self.titlesAndActions setObject:blockAction forKey:title];
    [self.sortedActions addObject:title];
}

@end
