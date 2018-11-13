//
//  ColorWheel.swift
//  Schedule
//
//  Created by HsinYuLi on 2018/10/15.
//  Copyright © 2018年 laalee. All rights reserved.
//

//swiftlint:disable variable_name

import UIKit

protocol ColorWheelDelegate: class {

    func hueAndSaturationSelected(_ hue: CGFloat, saturation: CGFloat)
}

class ColorWheel: UIView {

    var color: UIColor!
    var nonTouchedRadius: CGFloat!

    var wheelLayer: CALayer!
    var innerRadius: CGFloat!
    let innerOuterRatio: CGFloat = 0.9

    var brightnessLayer: CAShapeLayer!
    var brightness: CGFloat = 1.0

    var indicatorLayer: CAShapeLayer!
    var point: CGPoint! {

        didSet {

            print("pointX", point.x, "pointY", point.y, "didSet")
        }
    }
    var indicatorCircleRadius: CGFloat = 12.0
    var indicatorColor: CGColor = UIColor.white.cgColor
    var indicatorBorderWidth: CGFloat = 2.0

    let scale: CGFloat = UIScreen.main.scale

    weak var delegate: ColorWheelDelegate?

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }

    init(frame: CGRect, color: UIColor!, nonTouchedRadius: CGFloat!) {

        super.init(frame: frame)

        self.color = color
        self.nonTouchedRadius = nonTouchedRadius

        wheelLayer = CALayer()
        wheelLayer.frame = CGRect(x: 20, y: 20, width: self.frame.width-40, height: self.frame.height-40)
        let dimension: CGFloat = min(wheelLayer.frame.width, wheelLayer.frame.height)
        let radius: CGFloat = dimension/2
        innerRadius = radius * innerOuterRatio
        wheelLayer.contents = createColorWheel(wheelLayer.frame.size)

        self.layer.addSublayer(wheelLayer)

        brightnessLayer = CAShapeLayer()

        brightnessLayer.path = UIBezierPath(
            roundedRect: CGRect(x: 20.5,
                                y: 20.5,
                                width: self.frame.width - 40.5,
                                height: self.frame.height - 40.5),
            cornerRadius: (self.frame.height - 40.5) / 2).cgPath

        self.layer.addSublayer(brightnessLayer)

        indicatorLayer = CAShapeLayer()
        indicatorLayer.strokeColor = indicatorColor
        indicatorLayer.lineWidth = indicatorBorderWidth
        indicatorLayer.fillColor = nil

        self.layer.addSublayer(indicatorLayer)
        setViewColor(color)
    }

    func onTheTouchableWheel(_ coord: CGPoint, _ nonTouchedRadius: CGFloat) -> (Bool) {

        let dimension: CGFloat = min(wheelLayer.frame.width, wheelLayer.frame.height)

        let radius: CGFloat = dimension/2

        let wheelLayerCenter: CGPoint = CGPoint(
            x: wheelLayer.frame.origin.x + radius,
            y: wheelLayer.frame.origin.y + radius
        )

        let distanceX: CGFloat = coord.x - wheelLayerCenter.x

        let distanceY: CGFloat = coord.y - wheelLayerCenter.y

        let distance: CGFloat = sqrt(distanceX * distanceX + distanceY * distanceY)

        let isOntheWheel: Bool

        if (distance < radius + 50) && (distance > nonTouchedRadius) {

            isOntheWheel = true

        } else {

            isOntheWheel = false
        }

        return isOntheWheel
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = touches.first {

            point = touch.location(in: self)
        }

        if onTheTouchableWheel(point, nonTouchedRadius) {

            indicatorCircleRadius = 12.0
            touchHandler(touches)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = touches.first {

            point = touch.location(in: self)
        }

        if onTheTouchableWheel(point, nonTouchedRadius) {

            touchHandler(touches)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = touches.first {

            point = touch.location(in: self)
        }

        if onTheTouchableWheel(point, nonTouchedRadius) {

            indicatorCircleRadius = 10.0
            touchHandler(touches)
        }
    }

    func touchHandler(_ touches: Set<UITouch>) {

        if let touch = touches.first {

            point = touch.location(in: self)
        }

        let indicator = getIndicatorCoordinate(point)
        point = indicator.point
        var color = (hue: CGFloat(0), saturation: CGFloat(0))

        if !indicator.isCenter {

            color = hueSaturationAtPoint(CGPoint(x: point.x*scale, y: point.y*scale))
        }

        self.color = UIColor(hue: color.hue, saturation: color.saturation, brightness: self.brightness, alpha: 1.0)

        delegate?.hueAndSaturationSelected(color.hue, saturation: color.saturation)

        drawIndicator()
    }

    func drawIndicator() {

        if point == nil {

            return
        }

        if point != nil {

            indicatorLayer.path = UIBezierPath(
                roundedRect: CGRect(x: point.x - indicatorCircleRadius,
                                    y: point.y - indicatorCircleRadius,
                                    width: indicatorCircleRadius * 2,
                                    height: indicatorCircleRadius * 2),
                cornerRadius: indicatorCircleRadius).cgPath

            indicatorLayer.fillColor = self.color.cgColor
        }
    }

    func getIndicatorCoordinate(_ coord: CGPoint) -> (point: CGPoint, isCenter: Bool) {

        let dimension: CGFloat = min(wheelLayer.frame.width, wheelLayer.frame.height)

        let radius: CGFloat = dimension/2

        let wheelLayerCenter: CGPoint = CGPoint(
            x: wheelLayer.frame.origin.x + radius,
            y: wheelLayer.frame.origin.y + radius
        )

        let distanceX: CGFloat = coord.x - wheelLayerCenter.x
        let distanceY: CGFloat = coord.y - wheelLayerCenter.y
        let distance: CGFloat = sqrt(distanceX * distanceX + distanceY * distanceY)
        var outputCoord: CGPoint = coord

        if distance > radius {

            let theta: CGFloat = atan2(distanceY, distanceX)

            outputCoord.x = radius * cos(theta) + wheelLayerCenter.x

            outputCoord.y = radius * sin(theta) + wheelLayerCenter.y
        }

        if distance < innerRadius {

            let theta: CGFloat = atan2(distanceY, distanceX)

            outputCoord.x = innerRadius * cos(theta) + wheelLayerCenter.x

            outputCoord.y = innerRadius * sin(theta) + wheelLayerCenter.y
        }

        let isCenter = false

        return (outputCoord, isCenter)
    }

    func createColorWheel(_ size: CGSize) -> CGImage {

        let originalWidth: CGFloat = size.width
        let originalHeight: CGFloat = size.height
        let dimension: CGFloat = min(originalWidth*scale, originalHeight*scale)
        let bufferLength: Int = Int(dimension * dimension * 4)

        let bitmapData: CFMutableData = CFDataCreateMutable(nil, 0)

        CFDataSetLength(bitmapData, CFIndex(bufferLength))

        let bitmap = CFDataGetMutableBytePtr(bitmapData)

        for y in stride(from: CGFloat(0), to: dimension, by: CGFloat(1)) {

            for x in stride(from: CGFloat(0), to: dimension, by: CGFloat(1)) {

                var hsv: HSV = (hue: 0, saturation: 0, brightness: 0, alpha: 0)
                var rgb: RGB = (red: 0, green: 0, blue: 0, alpha: 0)

                let color = hueSaturationAtPoint(CGPoint(x: x, y: y))
                let hue = color.hue
                let saturation = color.saturation
                var a: CGFloat = 0.0
                if saturation < 1.0 {

                    if saturation > 0.99 {

                        a = (1.0 - saturation) * 100

                    } else {

                        a = 1.0
                    }

                    hsv.hue = hue
                    hsv.saturation = saturation
                    hsv.brightness = 1.0
                    hsv.alpha = a
                    rgb = hsv2rgb(hsv)
                }

                let offset = Int(4 * (x + y * dimension))

                bitmap?[offset] = UInt8(rgb.red*255)
                bitmap?[offset + 1] = UInt8(rgb.green*255)
                bitmap?[offset + 2] = UInt8(rgb.blue*255)
                bitmap?[offset + 3] = UInt8(rgb.alpha*255)

            }
        }

        let colorSpace: CGColorSpace? = CGColorSpaceCreateDeviceRGB()
        let dataProvider: CGDataProvider? = CGDataProvider(data: bitmapData)
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.last.rawValue)
        let imageRef: CGImage? = CGImage(width: Int(dimension),
                                         height: Int(dimension),
                                         bitsPerComponent: 8,
                                         bitsPerPixel: 32,
                                         bytesPerRow: Int(dimension) * 4,
                                         space: colorSpace!,
                                         bitmapInfo: bitmapInfo,
                                         provider: dataProvider!,
                                         decode: nil,
                                         shouldInterpolate: false,
                                         intent: CGColorRenderingIntent.defaultIntent)

        return imageRef!
    }

    func hueSaturationAtPoint(_ position: CGPoint) -> (hue: CGFloat, saturation: CGFloat) {

        let dimension: CGFloat = min(wheelLayer.frame.width*scale, wheelLayer.frame.height*scale)
        let radius: CGFloat = dimension/2
        let c = radius
        let dx = CGFloat(position.x - c) / c
        let dy = CGFloat(position.y - c) / c
        let d = sqrt(CGFloat (dx * dx + dy * dy))

        var saturation: CGFloat = d

        if saturation < 0.99 && saturation > innerOuterRatio {

            saturation = 0.98

        } else {

            saturation = 1
        }

        var hue: CGFloat

        if d == 0 {

            hue = 0

        } else {

            hue = acos(dx/d) / CGFloat(Double.pi) / 2.0

            if dy < 0 {

                hue = 1.0 - hue
            }
        }

        return (hue, saturation)
    }

    func pointAtHueSaturation(_ hue: CGFloat, saturation: CGFloat) -> CGPoint {

        let dimension: CGFloat = min(wheelLayer.frame.width*scale, wheelLayer.frame.height*scale)

        let radius: CGFloat = saturation * dimension / 2

        let x = dimension / 2 + radius * cos(hue * CGFloat(Double.pi) * 2) + 20

        let y = dimension / 2 + radius * sin(hue * CGFloat(Double.pi) * 2) + 20

        return CGPoint(x: x, y: y)
    }

    func setViewColor(_ color: UIColor) {

        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0

        let ok: Bool = color.getHue(&hue,
                                    saturation: &saturation,
                                    brightness: &brightness,
                                    alpha: &alpha)

        if !ok {

            print("SwiftHSVColorPicker: exception <The color provided to SwiftHSVColorPicker is not convertible to HSV>")
        }

        self.color = color

        self.brightness = brightness

        brightnessLayer.fillColor = UIColor(white: 0, alpha: 1.0-self.brightness).cgColor

        drawIndicator()
    }

}
