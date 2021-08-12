//
//  ViewController.m
//  Created by Chris Mash on 26/06/2021.
//

#import "ViewController.h"
#import "iOSExample_ObjC-Swift.h"
@import AlertPresenter;

@interface ViewController () < PopoverDelegate >

@property (nonatomic) AlertPresenter* alertPresenter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.alertPresenter = [[AlertPresenter alloc] initWithWindowLevel: UIWindowLevelAlert];
    
    // Create a label with the title of the view controller
    UILabel* label = [UILabel new];
    label.text = [NSString stringWithFormat: @"iOS %@, ObjC UIKit (with SceneDelegate)",
                  UIDevice.currentDevice.systemVersion];
    label.textAlignment = NSTextAlignmentCenter;
    
    // Create buttons to show different types of alerts
    NSMutableArray<UIButton*>* buttons = [NSMutableArray array];
    for (NSNumber* type in [AlertFactory allAlertTypes]) {
        UIButton* button = [UIButton buttonWithType: UIButtonTypeSystem];
        [button addTarget: self
                   action: @selector(showAlertControllersPressed:)
         forControlEvents: UIControlEventTouchUpInside];
        button.tag = [type intValue];
        [button setTitle: [AlertFactory buttonTitleForType: (AlertType)[type intValue]]
                forState: UIControlStateNormal];
        [buttons addObject: button];
    }
    
    // Add them all to a stack view
    NSArray<UIView*>* stackViewSubviews = [@[label] arrayByAddingObjectsFromArray: buttons];
    UIStackView* stackView = [[UIStackView alloc] initWithArrangedSubviews: stackViewSubviews];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 10;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview: stackView];
    [[stackView.centerXAnchor constraintEqualToAnchor: self.view.centerXAnchor] setActive: YES];
    [[stackView.centerYAnchor constraintEqualToAnchor: self.view.centerYAnchor] setActive: YES];
}

- (void)showAlertControllersPressed:(UIButton*)button {
    // The button's tag is an AlertType
    AlertType type = (AlertType)button.tag;
    
    UIViewController* alert1 = [AlertFactory alertForType: type index: 1];
    UIViewController* alert2 = [AlertFactory alertForType: type index: 2];
    
    PopoverPresentation*(^presentation)(UIViewController*) = nil;
    switch (type) {
        case AlertTypeActionSheetPositioned:
        case AlertTypeCustomPositioned: {
            __weak __typeof__(self) weakSelf = self;
            presentation = ^PopoverPresentation*(UIViewController* alert) {
                CGRect rect = [button.superview convertRect: button.frame toView: self.view];
                return [[PopoverPresentation alloc] initWithSourceRect: rect
                                                              delegate: weakSelf];
            };
            alert1.modalPresentationStyle = UIModalPresentationPopover;
            alert2.modalPresentationStyle = UIModalPresentationPopover;
            break;
        }
        default: {
            break;
        }
    }
    
    [self enqueueAlert: alert1 popoverPresentation: presentation];
    [self enqueueAlert: alert2 popoverPresentation: presentation];
}

- (void)enqueueAlert:(UIViewController*)alert
 popoverPresentation:(PopoverPresentation*(^__nullable)(UIViewController*))popoverPresentation {
    // If you're supporting xOS 12 still, you'll need something like this.
    // xOS 13 requires the windowScene, xOS 12 does not (as Scene was introduced in xOS 13).
    if (@available(iOS 13.0, tvOS 13.0, *)) {
        [self.alertPresenter enqueueAlert: alert
                              windowScene: self.view.window.windowScene
                      popoverPresentation: popoverPresentation];
    } else {
        // xOS 12
        [self.alertPresenter enqueueAlert: alert
                      popoverPresentation: popoverPresentation];
    }
}

// MARK: PopoverDelegate methods
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    // Allows custom view controller alert to be presented as a popover on iPhone
    return UIModalPresentationNone;
}

@end
