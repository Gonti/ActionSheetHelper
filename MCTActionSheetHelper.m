#import "MCTActionSheetHelper.h"

@interface MCTActionSheetHelper () <UIActionSheetDelegate>

@property (weak) UIViewController *controller;
@property NSMutableDictionary *titlesAndActions;
@property NSMutableArray *sortedActions;

@end

@implementation MCTActionSheetHelper

- (id)initWithViewController:(UIViewController *)controller {
    return [self initWithViewController:controller Array:[[NSArray alloc] init] Dictionary:[[NSDictionary alloc] init]];
}


- (id)initWithViewController:(UIViewController *)controller Array:(NSArray *)sortedTitles Dictionary:(NSDictionary *)blocksAndTitiles {
    self = [super init];
    if (self) {
        self.controller = controller;
        self.titlesAndActions = [blocksAndTitiles mutableCopy];
        self.sortedActions = [sortedTitles mutableCopy];
    }
    return self;
}

- (void)presentActionSheet {
    if ([UIAlertController class]) {
        UIAlertController* alertController = [[UIAlertController alloc] init];
        for (NSString *title in self.sortedActions) {
            [alertController addAction:[UIAlertAction actionWithTitle:title
                                                                style:UIAlertActionStyleDefault
                                                              handler:self.titlesAndActions[title]]];
        }
        [self.controller presentViewController:alertController animated:YES completion:nil];
    }
    else {
        [self presentChoosePictureActionSheet];
    }
}

- (void)presentChoosePictureActionSheet {
    UIActionSheet *selectPictureSource = [[UIActionSheet alloc] init];
    selectPictureSource.delegate = self;
    for (NSString *title in self.sortedActions) {
        [selectPictureSource addButtonWithTitle:title];
    }
    [selectPictureSource showInView:self.controller.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *key = self.sortedActions[buttonIndex];
    void (^action)(UIAlertAction * action) = self.titlesAndActions[key];
    action(nil);
}

- (void)addTitle:(NSString *)title WithAction:(void (^)(UIAlertAction *))blockAction {
    [self.titlesAndActions setObject:blockAction forKey:title];
    [self.sortedActions addObject:title];
}

- (void)clearActionSheet {
    [self.titlesAndActions removeAllObjects];
    [self.sortedActions removeAllObjects];
}

@end
