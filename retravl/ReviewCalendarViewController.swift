import UIKit
import FSCalendar

class ReviewCalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    // MARK: - outlet
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var lblDates: UILabel!
    
    // MARK: - delegate
    var delegate:ReviewCalendarDelegate?
    
    // MARK: -
    let formatter = DateFormatter()
    
    
    // MARK: actions
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnSave(_ sender: AnyObject) {
        self.dismiss(animated: true) {
            let data = self.calendar.selectedDates
            self.delegate?.dates(controller: self, dates: data)
        }
    }
    
    // MARK: override
    override func viewDidLoad() {
        self.calendar.dataSource = self
        self.calendar.delegate = self
        self.formatter.dateFormat = "MMM dd,yyyy"
        let today = Date()
        self.setDateRange(from: today, to: today)
        self.arrangeSelect(calendar: self.calendar, date: today)
    }
    
    private func getNewRange(dates:[Date], select:Date) -> [Date] {
        if dates.count > 0 {
            let first = dates.min()
            let last = dates.max()
            if let from = first, let to = last {
                if to < select  {
                    return from.datesInRangeByDay(to: select, calendar: Calendar.current).sorted()
                } else if from > select {
                    return select.datesInRangeByDay(to: to, calendar: Calendar.current).sorted()
                } else {
                    if abs(from.numberOfDaysUntilDateTime(toDateTime: select, calendar: Calendar.current)) > abs(to.numberOfDaysUntilDateTime(toDateTime: select, calendar: Calendar.current)) {
                        return select.datesInRangeByDay(to: to, calendar: Calendar.current).sorted()
                    } else {
                        return from.datesInRangeByDay(to: select, calendar: Calendar.current).sorted()
                    }
                }
            }
        }
        return []
    }
    
    private func setDateRange(from:Date, to:Date) {
        self.lblDates.text = "\(formatter.string(from: from)) ~ \(formatter.string(from: to))"
    }
    
    private func arrangeSelect(calendar: FSCalendar, date: Date) {
        if let dates = calendar.selectedDates as? [Date] {
            let newRange = self.getNewRange(dates: dates, select: date)
            
            if (newRange.count > 0) {
                setDateRange(from: newRange.first!, to: newRange.last!)
            } else {
                setDateRange(from: date, to: date)
            }
            // select new item
            newRange.forEach { d in
                if !dates.contains(d) {
                    calendar.select(d)
                }
            }
            
            // deselect old item
            if dates.count > 0 && newRange.count > 0 {
                dates.forEach { d in
                    if !newRange.contains(d) {
                        calendar.deselect(d)
                    }
                }
            }
        }
    }
    
    // MARK: - FSCalendarDelegate
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        arrangeSelect(calendar: calendar, date: date)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date) -> Bool {
        arrangeSelect(calendar: calendar, date: date)
        return true
    }
    
}

protocol ReviewCalendarDelegate {
    func dates(controller: UIViewController, dates: [Any])
}
