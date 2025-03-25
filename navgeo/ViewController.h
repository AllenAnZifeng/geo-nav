//
//  ViewController.h
//  navgeo
//
//  Created by Zifeng(Allen) An on 3/24/25.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property(nonatomic, strong) UITextField *sourceField;
@property(nonatomic, strong) UITextField *destinationField;
@property(nonatomic, strong) UITextField *waypointsField;
@property(nonatomic, strong) UISegmentedControl *parameterTypeControl;
@property(nonatomic, strong) UIView *directionsView;
@property(nonatomic, strong) UIView *placeView;
@property (nonatomic, strong) NSMutableArray<UITextField *> *waypointTextFields;
@property (nonatomic, strong) UIButton *addWaypointButton;
@property (nonatomic, strong) UIStackView *stackWaypointView;
@end

