extension Array {
    func toJsonString() -> String {
        do {
            // convert array to data
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            // load into string
            guard let string = String.init(data: jsonData, encoding: String.Encoding.utf8) else {
                print("Failed casting json to string...")
                return ""
            }
            return string
        } catch {
            print(error)
        }
        return ""
    }
}
