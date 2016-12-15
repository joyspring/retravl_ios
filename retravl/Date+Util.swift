import Foundation

extension Date {
    
    func datesInRangeByDay(to:Date, calendar:Calendar) -> [Date] {
        let days = self.numberOfDaysUntilDateTime(toDateTime: to, calendar: calendar)
        if days > 0 {
            return (0...days).map { i in
                calendar.date(byAdding: .day, value: i, to: self) ?? self
            }
        }
        return [to]
    }
    
    func numberOfDaysUntilDateTime(toDateTime: Date, calendar: Calendar) -> Int {
        let fromDate = calendar.startOfDay(for: self)
        let toDate = calendar.startOfDay(for: toDateTime)
        let difference = calendar.dateComponents([.day], from: fromDate, to: toDate)
        return difference.day!
    }
    
}
