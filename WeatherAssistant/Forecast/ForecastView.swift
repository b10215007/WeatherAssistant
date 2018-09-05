//
//  ForecastView.swift
//  WeatherAssistant
//
//  Created by michael on 2018/4/7.
//  Copyright © 2018年 michael. All rights reserved.
//

import UIKit

@IBDesignable class ForecastView: UIView {

   var view = UIView()
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var iconLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!

  override init(frame: CGRect) {
    super.init(frame: frame)
    view = loadViewFromNib()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    view = loadViewFromNib()
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

  //MARK: ViewModel
  var viewModel :ForecastViewModel? {
    didSet{
      viewModel?.time.observe {
        [unowned self] in
        self.timeLabel.text = $0
      }
      viewModel?.iconText.observe {
        [unowned self] in
        self.iconLabel.text = $0
      }
      viewModel?.temperature.observe {
        [unowned self] in
        self.temperatureLabel.text = $0
      }
    }
  }

  func loadViewModel(_ viewModel: ForecastViewModel){
    self.viewModel = viewModel
  }

  // MARK: - IBInspectable
  @IBInspectable var time: String?{
    get {
      return timeLabel.text
    }set{
      timeLabel.text = newValue
    }
  }

  @IBInspectable var iconString: String?{
    get{
      return iconLabel.text
    }set{
      iconLabel.text = newValue
    }
  }

  @IBInspectable var temperature: String? {
    get{
      return temperatureLabel.text
    }set{
      temperatureLabel.text = newValue
    }
  }

  @IBInspectable var iconColor: UIColor {
    get {
      return iconLabel.textColor
    }

    set {
      iconLabel.textColor = newValue
    }
  }

  @IBInspectable var temperatureColor: UIColor {
    get {
      return temperatureLabel.textColor
    }

    set {
      temperatureLabel.textColor = newValue
    }
  }

  @IBInspectable var bgColor: UIColor {
    get {
      return view.backgroundColor!
    }

    set {
      view.backgroundColor = newValue
    }
  }

  fileprivate func nibName() -> String{
    return String(describing: type(of: self))
  }


}
