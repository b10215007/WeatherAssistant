//
//  ViewController.swift
//  WeatherAssistant
//
//  Created by michael on 2018/4/5.
//  Copyright © 2018年 michael. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var yearLabel: UILabel!
  @IBOutlet weak var monthLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var scrollView: UIScrollView!

  var mainView:MainPageView?

  var today = Calendar.current.component(.day, from: Date())
  var currentMonth = Calendar.current.component(.month, from: Date())
  var currentYear = Calendar.current.component(.year, from: Date())
  var numberOfDaysInThisMonth: Int{
    let dateComponents = DateComponents(year: currentYear, month: currentMonth)
    let date = Calendar.current.date(from: dateComponents)
    let range = Calendar.current.range(of: .day, in: .month, for: date!)

    return range?.count ?? 0
  }

  var whatDayIsIt: Int{
    let dateComponents = DateComponents(year: currentYear, month: currentMonth)
    let date = Calendar.current.date(from: dateComponents)
    return Calendar.current.component(.weekday, from: date!)
  }

  var addMoreDateItems:Int {
    return whatDayIsIt - 1
  }
  var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]

  var viewModel: WeatherViewModel?{
    didSet{
      viewModel?.forecast4Days.observe{
        [unowned self] (forecast4DaysViewModel) in
        weatherList = []
        temperatureList = []
        for i in 0..<forecast4DaysViewModel.count{
          forecast4DaysViewModel[i].mainWeather.observe{
            //[unowned self] in
            weatherList.append($0)
          }
          forecast4DaysViewModel[i].temperature_Double.observe {
            //[unowned self] in
            temperatureList.append($0)
          }
        }
        UserDefaults.standard.set(weatherList, forKey: "weatherList")
        UserDefaults.standard.set(temperatureList, forKey: "temperatureList")
        self.reloadScrollView()
      }
    }
  }

  let fullSize = UIScreen.main.bounds.size
  var pageCount = 3
  var currentIndex: Int = 1{
    didSet{
      pageControl.currentPage = currentIndex
    }
  }


  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = WeatherViewModel()
    viewModel?.startLocationService()

    collectionView.delegate = self
    collectionView.dataSource = self

    pageControl.isEnabled = false
    scrollView.bounces = true
    scrollView.alwaysBounceHorizontal = true
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.contentSize = CGSize(width: 3*fullSize.width, height: 300)

    mainView = MainPageView(frame: CGRect(x: 0, y: 0, width: fullSize.width, height: 300))
    let scene = UIImageView(frame: CGRect(x: self.view.bounds.width, y: 0, width: self.view.bounds.width, height: 300))
    scene.image = #imageLiteral(resourceName: "scene")
    let scene2 = UIImageView(frame: CGRect(x: self.view.bounds.width*2, y: 0, width: self.view.bounds.width, height: 300))
    scene2.image = #imageLiteral(resourceName: "scene2")

    scrollView.addSubview(mainView!)
    scrollView.addSubview(scene)
    scrollView.addSubview(scene2)
    scrollView.delegate = self
    scrollView.isPagingEnabled = true

    setAllDate()
    NotificationCenter.default.addObserver(self, selector: #selector(reloadScrollView), name: Notification.Name(rawValue: "reloadView"), object: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  func setAllDate(){
    yearLabel.text = "\(currentYear)"
    monthLabel.text = months[currentMonth - 1]
  }

  @objc func reloadScrollView(){
    mainView?.viewModel = viewModel
   
    weatherHandler()
    scrollView.reloadInputViews()
    collectionView.reloadData()
  }

  func weatherHandler(){
    var value = 0
    for i in 0..<weatherList.count{
      if weatherList[i] == "雨天"{
        value = value - 3
      }else{
        value = value + 1
      }
      if(i % 6 == 5){
        if(value > 0){
          weatherPredict.append("晴天")
        }else if(value == 0){
          weatherPredict.append("陰天")
        }else{
          weatherPredict.append("雨天")
        }
      }
    }
    NotificationCenter.default.post(name: Notification.Name(rawValue: "setUpDrData"), object: nil)
  }


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if(numberOfDaysInThisMonth + addMoreDateItems <= 35){
      return 35
    }else{
      return 42
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width / 7
    return CGSize(width: width, height: 40)
  }


  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarCollectionViewCell
    let date = indexPath.row + 1 - addMoreDateItems

    if indexPath.row < addMoreDateItems{
      cell.dateLabel.text = ""
      cell.bgImageView.isHidden = true
      //cell.bgImageView.image = UIImage(named: "")
    }else if(date > numberOfDaysInThisMonth){
      cell.dateLabel.text = "\(date - numberOfDaysInThisMonth)"
      cell.dateLabel.textColor = UIColor.lightGray
      cell.bgImageView.isHidden = true
      cell.alpha = 0.9
    }else{
      cell.dateLabel.text = "\(date)"
      cell.dateLabel.textColor = UIColor.darkGray
      cell.bgImageView.isHidden = true
      //cell.bgImageView.image = UIImage(named: "")
      if(indexPath.row % 7 == 0 || indexPath.row % 7 == 6){
         cell.dateLabel.textColor = UIColor.red
      }
      if(date == today){
        cell.bgImageView.isHidden = false
        cell.bgImageView.image = UIImage(named: "darkGray_point")
        cell.bgImageView.contentMode = .scaleAspectFit
        cell.dateLabel.textColor = UIColor.white
      }else if(date <= today + 5  && date > today){
        print(date)
        cell.bgImageView.isHidden = false
        if(weatherPredict.count > 0){
          let index = date - today - 1
          if(weatherPredict[index] == "雨天"){
            cell.bgImageView.image = UIImage(named: "blue_point")
            cell.bgImageView.contentMode = .scaleAspectFit
          }else{
            cell.bgImageView.image = UIImage(named: "yellow_point")
            cell.bgImageView.contentMode = .scaleAspectFit
          }
        }
      }


    }


    return cell
  }
}

extension ViewController: UIScrollViewDelegate{

  func scrollViewDidScroll(_ scrollView: UIScrollView) {

    //頁面超過 0.5 即+1
    let page = Int( (scrollView.contentOffset.x) / scrollView.bounds.width + 0.5)

    let offset = scrollView.contentOffset.x / scrollView.bounds.width
    //page 沒變，直接return
    if(page == currentIndex){
      return
    }
    // 设为 == 1 在快速拖动的时候有几率直接pass。 > 0.99 几乎看不出来&可以防止拖的太快导致无法滑动 好像不需要
    if offset > CGFloat(page) + 0.99 {
      scrollView.setContentOffset(CGPoint(x: fullSize.width, y: 0), animated: false)
    }
    if(page == 0){
      currentIndex = page
    }else{
      currentIndex = page
    }
    scrollView.isScrollEnabled = true
  }


}

