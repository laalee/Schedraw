# Schedraw 
Demonstrated personal schedule in Gantt way to track overlapping event clearly.

- Switch the view window in two way, gantt mode and calendar mode
- Create widget access to notify daily task quickly
- Customize color category setting at ease
- Add category and customize color

<a href="https://itunes.apple.com/app/schedraw/id1439182896?mt=8"><img src="https://i.imgur.com/Pc1KdHw.png" width="150"></a>

# Feature 
- Gantt mode and calendar mode
  -  Gantt mode: The consecutive days which related to the chosen events will be shown on this window, it is designed to tracking the progress to each event, and easily to realize the concurrent status to all the events within the same day or days.
  - Calendar mode: Click on each different month or date, the relevant event’s contents will be shown below.
  <img src="https://i.imgur.com/MmgUOiM.png" width="200"><img src="https://i.imgur.com/fmpicRJ.png" width="200">
  
- Customized color to set on each category
  - Through add a new item/category, and then click on the blank field, a new event will be added to the window
  <img src="https://i.imgur.com/zTafn0Z.png" width="200"><img src="https://i.imgur.com/s7fUjfK.png" width="200">

- Show daily task in Widget 
  <img src="https://i.imgur.com/VubsGZq.png" width="200">
  
# Key function

## Infinite scrolling UICollectionView
<a><img src="https://i.imgur.com/spYMK4C.gif" width="250"></a>

- 在 scrollViewDidScroll() 監測使用者滾動的行為
- 用 contentOffset 檢查是否已經滾到邊界，是的話就增加 collectionView item.

```
func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.contentOffset.x < 100 {

            // add left items

        } else if scrollView.contentOffset.x > (scrollView.contentSize.width - UIScreen.main.bounds.size.width - 100) {

            // add right items
        }
    }
```

## Transition Animations
<a><img src="https://i.imgur.com/DGM3FQr.gif" width="250"></a>

- 自訂一個 UIViewControllerAnimatedTransitioning
```
class FadePushAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {

        return 0.2
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toViewController = transitionContext.viewController(forKey: .to) else {
                return
        }

        transitionContext.containerView.addSubview(toViewController.view)

        toViewController.view.alpha = 0

        let duration = self.transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration, animations: {

            toViewController.view.alpha = 1

        }, completion: { _ in

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

}

```

- 換頁時系統會呼叫 animationController function，如果回傳 nil 系統就會使用預設的動畫（從右方或下方推入），所以要在這裡回傳剛剛定義的 FadePushAnimator 取代原本預設的動畫。
```
extension GanttTableViewCell: UIViewControllerTransitioningDelegate {

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return FadePushAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return FadePushAnimator()
    }
}
```

## Today Extension
<a><img src="https://i.imgur.com/VubsGZq.png" width="250"></a>

- 新增 Target: Menu File > New > Target Today Extension

- 在 Podfile 新增 target 避免 Archive 時失敗
```
target 'Schedule' do

  pod 'SwiftLint'

  target 'ScheduleWidget' do
      
      inherit! :search_paths
  end

end
```

- 從 Widget 啟動 App
  - 設定 URL Schems
  <a><img src="https://i.imgur.com/1NqOw6Z.png" width="400"></a> 

  - 利用設定好的 URL 執行 open function
  ```
  guard let scheduleUrl = URL(string: "myWidget://") else { return }
  self.extensionContext?.open(scheduleUrl, completionHandler: nil)
  ```



# Library

- SwiftLint
- Fabric
- Crashlytics
- lottie-ios
- Firebase/Core
- DynamicColor

# Requirement

- iOS 10.3+
- XCode 10.0

# Contacts

Hsin Yu Li
laalee0525@gmail.com
