//
//  ForecastView.swift
//  WeatherAssistant
//
//  Created by michael on 2018/4/5.
//  Copyright © 2018年 michael. All rights reserved.
//

import UIKit

@IBDesignable class ForecastPageView: UIView {

  var view = UIView()

  @IBOutlet weak var textLabel: UILabel!
  @IBOutlet weak var dialogimageView: UIImageView!

  @IBOutlet weak var textLabel2: UILabel!
  @IBOutlet weak var dialogimageView2: UIImageView!

  @IBOutlet weak var view2: UIView!

  @IBOutlet weak var doctorImageView: UIImageView!
  @IBOutlet weak var doctorHeight: NSLayoutConstraint!
  @IBOutlet weak var doctorWidth: NSLayoutConstraint!
  @IBOutlet weak var doctorCenterX: NSLayoutConstraint!   //水平置中constraint
  @IBOutlet weak var doctorBottomConstraint: NSLayoutConstraint! //bottom constraint

  override init(frame: CGRect) {
    super.init(frame: frame)
    view = loadViewFromNib()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    view = loadViewFromNib()
  }

  override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)
    NotificationCenter.default.addObserver(self, selector: #selector(DrWeatherHandler), name: Notification.Name(rawValue: "setUpDrData"), object: nil)
  }

  func loadViewFromNib() -> UIView {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: nibName(), bundle: bundle)
    // swiftlint:disable force_cast
    let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    // swiftlint:enable force_cast

    view.frame = bounds
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(view)
    return view
  }

  // MARK: - Private
  fileprivate func nibName() -> String {
    return String(describing: type(of: self))
  }

  @objc func DrWeatherHandler(){
    var sun_count = 0
    var rain_count = 0
    for i in 0..<weatherPredict.count {
      if weatherPredict[i] == "晴天"{
        sun_count = sun_count + 1
      }else if(weatherPredict[i] == "雨天"){
        rain_count = rain_count + 1
      }
    }

    if(sun_count > 2){
      view2.isHidden = true
      dialogimageView.image = UIImage(named: "sunny_remind")
      textLabel.text = NSLocalizedString("sunny_remind_text2", comment: "")
      doctorWidth.constant = 220
      doctorImageView.image = UIImage(named: "dr_sun")
    }else{
      if(rain_count > 2){
        view2.isHidden = true
        dialogimageView.image = UIImage(named: "rain_remind")
        textLabel.text = NSLocalizedString("rain_remind_text2", comment: "")
        doctorWidth.constant = 220
        doctorImageView.image = UIImage(named: "dr_rain")
      }else{
        if(rain_count <= 1 && sun_count <= 1){
          view2.isHidden = true
          textLabel.text = NSLocalizedString("unstable_remind_text", comment: "")
          dialogimageView.image = UIImage(named: "abc")
          doctorWidth.constant = 160
          doctorImageView.image = UIImage(named: "dr_other")
        }else{
          view2.isHidden = false
          doctorWidth.constant = 120
          doctorHeight.constant = 120
          doctorCenterX.constant = -80
          doctorBottomConstraint.constant = 0
          doctorImageView.image = UIImage(named: "dr_rainsun")
          dialogimageView.image = UIImage(named: "sunny_remind")
          dialogimageView2.image = UIImage(named: "rain_remind")
          textLabel.text = NSLocalizedString("sunny_remind_text", comment: "")
          textLabel2.text = NSLocalizedString("rain_remind_text", comment: "")
        }
      }

    }
  }

  var viewModel : WeatherViewModel? {
    didSet{
      DrWeatherHandler()
    }
  }
  
}
