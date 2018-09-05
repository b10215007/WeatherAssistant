//
//  MainPageView.swift
//  WeatherAssistant
//
//  Created by michael on 2018/4/5.
//  Copyright © 2018年 michael. All rights reserved.
//

import UIKit

@IBDesignable class MainPageView: UIView {

  var view = UIView()

  @IBOutlet weak var weatherIconLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var weatherTextLabel: UILabel!
  @IBOutlet var forecastViews: [ForecastView]!

  let identifier = "WeatherIdentifier"

  var currentLocation: String = ""
  var currentIcon: String = ""
  var currentTemperature: String = ""

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

  var viewModel: WeatherViewModel? {
    didSet{
      viewModel?.location.observe{
        [unowned self] in
        self.currentLocation = $0
      }

      viewModel?.iconText.observe{
        [unowned self] in
        self.weatherIconLabel.text = $0
      }

      viewModel?.temperature.observe{
        [unowned self] in
        self.temperatureLabel.text = $0
      }

      viewModel?.description.observe{
        [unowned self] in
        
        self.weatherTextLabel.text = "現在是 " + $0
      }

      viewModel?.forecasts.observe{
        [unowned self] (forecastViewModels) in
        if forecastViewModels.count >= 4 {
          for (index, forecastView) in self.forecastViews.enumerated(){
            forecastView.loadViewModel(forecastViewModels[index])
          }
        }
      }
      
    }
  }


  // MARK: - Private
  fileprivate func nibName() -> String {
    return String(describing: type(of: self))
  }

}
