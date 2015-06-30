#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MCTActionSheetHelper : NSObject

- (id)initWithViewController:(UIViewController *)controller cancelButtonTitle:(NSString *)cancel;
- (id)initWithViewController:(UIViewController *)controller array:(NSArray *)sortedTitles dictionary:(NSDictionary *)blocksAndTitiles cancelButtonTitle:(NSString *)cancel;
- (void)presentActionSheet;
- (void)addTitle:(NSString *)title WithAction:(void (^)(UIAlertAction *action))blockAction;

@end
