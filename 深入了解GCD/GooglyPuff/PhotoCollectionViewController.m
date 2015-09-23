//
//  PhotoCollectionViewController.m
//  GCDTutorial
//
//  Created by A Magical Unicorn on A Sunday Night.
//  Copyright (c) 2014 Derek Selander. All rights reserved.
//

@import AssetsLibrary;
#import "PhotoCollectionViewController.h"
#import "PhotoDetailViewController.h"
#import "ELCImagePickerController.h"

static const NSInteger kCellImageViewTag = 3;
static const CGFloat kBackgroundImageOpacity = 0.1f;

@interface PhotoCollectionViewController () <ELCImagePickerControllerDelegate,
UINavigationControllerDelegate,
UICollectionViewDataSource,
UIActionSheetDelegate>

@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) UIPopoverController *popController;
@end

@implementation PhotoCollectionViewController

//*****************************************************************************/
#pragma mark - LifeCycle
//*****************************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.library = [[ALAssetsLibrary alloc] init];
    
    // Background image setup
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    backgroundImageView.alpha = kBackgroundImageOpacity;
    backgroundImageView.contentMode = UIViewContentModeCenter;
    [self.collectionView setBackgroundView:backgroundImageView];
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentChangedNotification:)
                                                 name:kPhotoManagerContentUpdateNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentChangedNotification:) name:kPhotoManagerAddedContentNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showOrHideNavPrompt];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//*****************************************************************************/
#pragma mark - UICollectionViewDataSource Methods
//*****************************************************************************/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = [[[PhotoManager sharedManager] photos] count];
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"photoCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:kCellImageViewTag];
    NSArray *photoAssets = [[PhotoManager sharedManager] photos];
    Photo *photo = photoAssets[indexPath.row];
    
    switch (photo.status) {
        case PhotoStatusGoodToGo:
            imageView.image = [photo thumbnail];
            break;
        case PhotoStatusDownloading:
            imageView.image = [UIImage imageNamed:@"photoDownloading"];
            break;
        case PhotoStatusFailed:
            imageView.image = [UIImage imageNamed:@"photoDownloadError"];
        default:
            break;
    }
    return cell;
}

//*****************************************************************************/
#pragma mark - UICollectionViewDelegate
//*****************************************************************************/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *photos = [[PhotoManager sharedManager] photos];
    Photo *photo = photos[indexPath.row];
    
    switch (photo.status) {
        case PhotoStatusGoodToGo: {
            UIImage *image = [photo image];
            PhotoDetailViewController *photoDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoDetailViewController"];
            [photoDetailViewController setupWithImage:image];
            [self.navigationController pushViewController:photoDetailViewController animated:YES];
            break;
        }
        case PhotoStatusDownloading: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Downloading"
                                                            message:@"The image is currently downloading"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            break;
        }
        case PhotoStatusFailed: //Fall through to default
        default: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Failed"
                                                            message:@"The image failed to be created"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

//*****************************************************************************/
#pragma mark - elcImagePickerControllerDelegate
//*****************************************************************************/

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    for (NSDictionary *dictionary in info) {
        [self.library assetForURL:dictionary[UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
            Photo *photo = [[Photo alloc] initWithAsset:asset];
            [[PhotoManager sharedManager] addPhoto:photo];
        } failureBlock:^(NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permission Denied"
                                                            message:@"To access your photos, please change the permissions in Settings"
                                                           delegate:nil
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
    
    if (isIpad()) {
        [self.popController dismissPopoverAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    if (isIpad()) {
        [self.popController dismissPopoverAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//*****************************************************************************/
#pragma mark - IBAction Methods
//*****************************************************************************/

/// The upper right UIBarButtonItem method
- (IBAction)addPhotoAssets:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Get Photos From:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library", @"Le Internet", nil];
    [actionSheet showInView:self.view];
}

//*****************************************************************************/
#pragma mark - UIActionSheetDelegate
//*****************************************************************************/

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    static const NSInteger kButtonIndexPhotoLibrary = 0;
    static const NSInteger kButtonIndexInternet = 1;
    if (buttonIndex == kButtonIndexPhotoLibrary) {
        ELCImagePickerController *imagePickerController = [[ELCImagePickerController alloc] init];
        [imagePickerController setImagePickerDelegate:self];
        
        if (isIpad()) {
            if (![self.popController isPopoverVisible]) {
                self.popController = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
                
                [self.popController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
        } else {
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    } else if (buttonIndex == kButtonIndexInternet) {
        [self downloadImageAssets];
    }
}

//*****************************************************************************/
#pragma mark - Private Methods
//*****************************************************************************/

- (void)contentChangedNotification:(NSNotification *)notification
{
    [self.collectionView reloadData];
    [self showOrHideNavPrompt];
}
/**
 *
 自定义串行队列：在一个自定义串行队列上使用 dispatch_after 要小心。你最好坚持使用主队列。
 主队列（串行）：是使用 dispatch_after 的好选择；Xcode 提供了一个不错的自动完成模版。
 并发队列：在并发队列上使用 dispatch_after 也要小心；你会这样做就比较罕见。还是在主队列做这些操作吧。

 */
- (void)showOrHideNavPrompt
{
    NSUInteger count = [[PhotoManager sharedManager] photos].count;
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)); // 1
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){ // 2
        if (!count) {
            [self.navigationItem setPrompt:@"Add photos with faces to Googlyify them!"];
        } else {
            [self.navigationItem setPrompt:nil];
        }
    });
}

- (void)downloadImageAssets
{
    [[PhotoManager sharedManager] downloadPhotosWithCompletionBlock:^(NSError *error) {
        
        // This completion block currently executes at the wrong time
        NSString *message = error ? [error localizedDescription] : @"The images have finished downloading";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Download Complete"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

@end
