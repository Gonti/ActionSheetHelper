#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MCTActionSheetHelper : NSObject

- (id)initWithViewController:(UIViewController *)controller;
- (id)initWithViewController:(UIViewController *)controller Array:(NSArray *)sortedTitles Dictionary:(NSDictionary *)blocksAndTitiles;
- (void)presentActionSheet;
- (void)addTitle:(NSString *)title WithAction:(void (^)(UIAlertAction *action))blockAction;
- (void)clearActionSheet;

@end
