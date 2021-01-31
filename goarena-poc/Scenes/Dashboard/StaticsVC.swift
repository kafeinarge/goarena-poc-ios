//
//  StaticsVC.swift
//  goarena-poc
//
//  Created by serhat akalin on 30.01.2021.
//

import UIKit
import Charts

struct GoalGroup {
    let category: String
    let paid: Int
    let unpaid: Int
    let totalGoals: Int
}

class StaticsVC: BaseVC<StaticsViewModel>, ChartViewDelegate {
    weak var axisFormatDelegate: IAxisValueFormatter?
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var reportTableView: UITableView!

    var pickerShow: Bool = false
    var categories = [String]()
    var goals = [GoalGroup]()
    var unitsSold = [Double]()
    var totalGoals = [Double]()
    var totalGoal: Double = 0.0

    private var selectedItem: Int?

    private lazy var pickerViewPresenter: PickerViewPresenter = {
        let pickerViewPresenter = PickerViewPresenter()
        pickerViewPresenter.items = [
            "Ocak",
            "Şubat",
            "Mart",
            "Nisan",
            "Mayıs",
            "Haziran",
            "Temmuz",
            "Ağustos",
            "Eylül",
            "Ekim",
            "Kasım",
            "Aralık"
        ]
        pickerViewPresenter.didSelectItem = { [weak self] item in
            self?.selectedItem = item
        }
        return pickerViewPresenter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        onSubscribe()
        viewModel.getContents()
        view.addSubview(pickerViewPresenter)
        barChartView.delegate = self
        axisFormatDelegate = self
    }

    private func onSubscribe() {
        SwiftEventBus.onMainThread(self, name: SubscribeViewState.STATISTIC_STATE.rawValue) { result in
            if let event = result!.object as? Summary {
                self.removeGoals()
                if event.content.count > 0 {
                    for d in event.content {
                        guard let cats = d.category,
                            let paid = d.paidCount,
                            let unpaid = d.unpaidCount,
                            let totalGoals = d.totalGoal
                            else { return }

                        self.unitsSold.append(Double(totalGoals))
                        let dups = self.goals.contains { cats == $0.category }
                        if dups == false {
                            self.goals.append(GoalGroup(category: cats,
                                paid: paid,
                                unpaid: unpaid,
                                totalGoals: totalGoals))
                        }
                    }
                    self.reportTableView.reloadData()
                    self.categories = self.goals.map { $0.category }
                    self.setChart(dataPoints: self.categories, values: self.unitsSold)
                }
            }
        }

        SwiftEventBus.onMainThread(self, name: SubscribeViewState.DASHBOARD_CHART_REFRESH.rawValue) { result in
            if let event = result!.object as? Int {
                self.viewModel.month = event
                self.viewModel.getContents()
                self.reportTableView.reloadData()
            }
        }

    }

    private func removeGoals() {
        self.unitsSold.removeAll()
        self.categories.removeAll()
        self.totalGoals.removeAll()
        self.goals.removeAll()
    }


    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight) {
        print(entry)
    }

    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "Veri mevcut değil."
        guard dataPoints.count > 0 else { return }
        var dataEntries = [BarChartDataEntry]()

        for i in 0..<dataPoints.count {
            let entry = BarChartDataEntry(x: Double(i), y: values[i], data: categories as AnyObject?)
            dataEntries.append(entry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Units Sold")
        chartDataSet.drawValuesEnabled = true
        chartDataSet.colors = [UIColor.white]

        chartDataSet.highlightColor = UIColor.orange.withAlphaComponent(0.3)
        chartDataSet.highlightAlpha = 0.5
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.xAxis.axisMinimum = -0.5;
        barChartView.xAxis.axisMaximum = Double(chartDataSet.count) - 0.5;
        let xAxisValue = barChartView.xAxis
        xAxisValue.valueFormatter = axisFormatDelegate
        chartDataSet.colors = ChartColorTemplates.colorful()

        //Animation bars
        barChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0, easingOption: .easeInCubic)

        // X axis configurations
        barChartView.xAxis.granularityEnabled = false
        barChartView.xAxis.granularity = 1
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 15)
        barChartView.xAxis.labelTextColor = UIColor.white
        barChartView.xAxis.labelPosition = .bottomInside

        // Right axis configurations
        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawLabelsEnabled = false

        // Other configurations
        barChartView.highlightPerDragEnabled = false
        barChartView.chartDescription?.text = ""
        barChartView.legend.enabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.scaleYEnabled = false

        barChartView.drawMarkers = true

        let marker = ChartMarker()
        marker.chartView = barChartView
        barChartView.marker = marker
    }

    @IBAction func pop(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func changeGraph(_ sender: Any) {
        pickerViewPresenter.showPicker()
    }
}

extension StaticsVC: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return categories[Int(value)]
    }
}

extension StaticsVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
        cell.categoryName.text = goals[indexPath.row].category
        cell.paid.text = String(goals[indexPath.row].paid)
        cell.unpaid.text = String(goals[indexPath.row].unpaid)
        cell.total.text = String(goals[indexPath.row].totalGoals)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
