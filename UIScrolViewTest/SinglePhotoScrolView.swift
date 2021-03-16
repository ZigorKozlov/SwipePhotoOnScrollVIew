//
//  SinglePhotoScrolView.swift
//  UIScrolViewTest
//
//  Created by Игорь Козлов on 16.03.2021.
//

import UIKit

class SinglePhotoScrolView: UIScrollView, UIScrollViewDelegate {

    var imageZoomView: UIImageView?
    lazy var zoomingTap: UITapGestureRecognizer = {
        let zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
        zoomingTap.numberOfTapsRequired = 2
        return zoomingTap
    }()
    
    
    func set(image: UIImage) {
        imageZoomView?.removeFromSuperview()//Если переиспользуем данную ячейку класса
        imageZoomView = nil
        
        self.delegate = self // Подписываемся на делегат
        
        self.showsVerticalScrollIndicator = false // убираем индикатор прокрутки
        self.showsHorizontalScrollIndicator = false
        
        self.decelerationRate = UIScrollView.DecelerationRate.fast // Скорость скрола
        
        imageZoomView = UIImageView(image: image)
        self.addSubview(imageZoomView!)
        
        configurateFor(imagesize: image.size)
    }
    
    func configurateFor(imagesize: CGSize) {
        self.contentSize = imagesize//Указываем размер для скрола
        
        //self.minimumZoomScale = 0.1 // Минимальный  % от исходного изображения
        //self.maximumZoomScale = 5 //максимальный -||-
        setCurrentMaxAndMinScale()
        self.zoomScale = self.minimumZoomScale//Текущий коэфициент фасштабирования
        self.imageZoomView?.addGestureRecognizer(zoomingTap)//регистрируем жест
        self.imageZoomView?.isUserInteractionEnabled = true
    }
    
    func setCurrentMaxAndMinScale() {//Ставим изображение в ширину нашего экрана
        //минимальный масштабирование
        let boundsSize = self.bounds.size //
        let imageSize = imageZoomView!.bounds.size
        
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        
        let minScale = min(xScale, yScale)
        
        //максимальный масштабирование
        var maxScale: CGFloat = 1.0
        if minScale < 0.1 {
            maxScale = 0.3
        } else if minScale >= 0.1 && minScale < 0.5 {
            maxScale = 0.7
        } else {
            maxScale = max(minScale, 1.0)
        }
        
        self.minimumZoomScale = minScale
        self.maximumZoomScale = maxScale
    }
    
    func  setCenterImage() { // Функция должна срабатывать каждый раз когда опускаем палец называется она layoutSubviews
        let boundsSize = self.bounds.size
        var frameCenter = imageZoomView?.frame ?? CGRect.zero
        
        if frameCenter.size.width < boundsSize.width {
            frameCenter.origin.x = (boundsSize.width - frameCenter.width)/2
        } else {
            frameCenter.origin.x = 0
        }
        
        if frameCenter.size.height < boundsSize.height {
            frameCenter.origin.y = (boundsSize.height - frameCenter.height)/2
        } else {
            frameCenter.origin.y = 0
        }
        
        imageZoomView?.frame = frameCenter
    }
    
    override func layoutSubviews() {
        self.setCenterImage()
    }

    //MARK: - OBJ selectors gesture
    @objc func handleZoomingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        
        self.zoom(point: location, animated: true)
    }
    //
    func zoom(point: CGPoint, animated: Bool) {//Для высчитывания зума при нажатии
        let currentScale = self.zoomScale
        let minScale = self.minimumZoomScale
        let maxScale = self.maximumZoomScale
        
        if (minScale == maxScale) && minScale > 1 {
            return
        }
        
        let toScale = maxScale
        let finalScale = (currentScale == minScale) ? toScale : minScale
        let zoomRect = self.zooRect(scale: finalScale, center: point)
        
        zoom(to: zoomRect, animated: animated)
        
    }
    
    func zooRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.bounds
        
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.width / 2)

        return zoomRect
     }
    
    //MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageZoomView// для зума
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {//ЧТо бы возвращалось через центр, а не через верхний левый угол
        self.setCenterImage()
    }
}

