//
//  ViewController.swift
//  UIScrolViewTest
//
//  Created by Игорь Козлов on 16.03.2021.
//

import UIKit
// Do any additional setup after loading the view.
//(1) При касании какого-то контента(вью) Скролвью запускает таймер и если по истечению таймера палец не сместился(или сместился незначительно), то отправляет событие вью, которого коснулся юзер, если палец сместился, то скролВью выполняет прокрутку сам
//Подклассы могут переопределять методы touchShouldBegin (_: with: in :), isPagingEnabled и touchesShouldCancel (in :) (которые вызываются представлением прокрутки), чтобы влиять на то, как представление прокрутки обрабатывает жесты прокрутки.
//scrolView.isPagingEnabled Если = true, то прокрутка останавливается
//scrolView.touchesShouldBegin(<#T##touches: Set<UITouch>##Set<UITouch>#>, with: <#T##UIEvent?#>, in: <#T##UIView#>)  по умолчании при касании, вызывается метод обработки сыбытий вью, если соблюдены условия(1)
//scrolView.touchesShouldCancel(in: <#T##UIView#>)Вызывается, если палец сместился далеко(1) и нужжно отменить передачу события сабвью и начать перетаскивание
//Методы выше можно переопределить!
//ScrolView может реализовать жест щипка для масштабирования и панарамирования
//Для работы масштабирования и панорамирования делегат должен реализовать как viewForZooming (in :), так и scrollViewDidEndZooming (_: with: atScale :); кроме того, максимальный (maximumZoomScale) и минимальный (minimumZoomScale) масштаб масштабирования должны отличаться.
/*restorationIdentifier - если данному свойству присвоить значение, то оно постарается сохранить состояние скрол вью между запусками приложения. В частности, сохраняются значения свойств zoomScale, contentInset и contentOffset. Так что содержимое восстанавливается в то же состояние прокрутки что и раньше. Присвойте значение этому свойству, только если вы реализуете настраиваемое представление, которое реализует методы encodeRestorableState (with :) и decodeRestorableState (with :) для сохранения и восстановления состояния. Вы используете эти методы для записи любой информации о состоянии, связанной с представлением, и впоследствии используете эти данные для восстановления представления до его предыдущей конфигурации.
Важнo
Простого задания значения этого свойства недостаточно, чтобы гарантировать сохранение и восстановление представления. Контроллер представления-владельца и все контроллеры родительского представления этого контроллера представления также должны иметь идентификатор восстановления. Дополнительные сведения о процессе сохранения и восстановления см. В Руководстве по программированию приложений для iOS.
 */
class ViewController: UIViewController{
    var imageNames = ["image.jpg", "image2.jpg", "image3.jpg"]
    var mainScrolView: UIScrollView!
    var scrollImageArray = Array<SinglePhotoScrolView?>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateMainScrollView()
    }
}

//MARK: - Configurate scrollView
extension  ViewController {
    fileprivate func configurateMainScrollView() {
        let spaceBetweenImages: CGFloat = 10.0
        var mainScrollViewFrame = view.bounds
        
        mainScrollViewFrame.size.width += spaceBetweenImages // + 10 для расстояния между фото, что бы при Padding'е это усчитывалось
        mainScrolView = UIScrollView(frame: mainScrollViewFrame)
        
        view.addSubview(mainScrolView)
        
        mainScrolView.showsVerticalScrollIndicator = false
        mainScrolView.showsHorizontalScrollIndicator = false
        
        scrollImageArray.append(SinglePhotoScrolView(frame: view.bounds))
        scrollImageArray.append(SinglePhotoScrolView(frame: view.bounds))
        scrollImageArray.append(SinglePhotoScrolView(frame: view.bounds))
        
        var viewWidth: CGFloat = 0.0
        for ( i, _ ) in scrollImageArray.enumerated() {
            
            scrollImageArray[i]!.frame.origin = CGPoint(x: viewWidth, y: 0)
            viewWidth += view.bounds.width + spaceBetweenImages
            mainScrolView.addSubview(scrollImageArray[i]!)
            if let image = UIImage(named: imageNames[i]) {
                scrollImageArray[i]?.set(image: image)
            }
        }
        let contentWidth = (view.bounds.size.width + spaceBetweenImages) * CGFloat(scrollImageArray.count)
        let contentSize = CGSize(width: contentWidth, height: view.bounds.size.height )// + 30, что бы влез последний фрэйм ScrollView т.к. он + 10
        
        mainScrolView.contentSize = contentSize
        mainScrolView.isPagingEnabled = true
    }
}
