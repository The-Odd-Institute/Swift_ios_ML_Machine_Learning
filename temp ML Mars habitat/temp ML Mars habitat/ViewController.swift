import UIKit
import CoreML

class ViewController: UIViewController {

    @IBOutlet weak var showPrice: UILabel!
    @IBOutlet weak var panelsLabel: UILabel!
    @IBOutlet weak var greenHousesLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!

    let mlModel = MarsHabitatPricer()

    @IBAction func getNewPrice() {
        let solarPanels = arc4random_uniform(UInt32(5.0))
        panelsLabel.text = String(solarPanels)

        // greenhouses between 1 to 5
        let greenhouses = arc4random_uniform(UInt32(5.0))
        greenHousesLabel.text = String(greenhouses)

        // acres between 750 - 10,000
        let size = arc4random_uniform(10000) + 1000
        sizeLabel.text = String(size)

        guard let marsHabitatPricerOutput = try? mlModel.prediction(solarPanels: Double(solarPanels),
                                                                    greenhouses: Double(greenhouses),
                                                                    size: Double(size)) else {
            fatalError("Unexpected runtime error.")
        }

        /// Formatter for the output.
        let priceFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 0
            formatter.usesGroupingSeparator = true
            formatter.locale = Locale(identifier: "en_US")
            return formatter
        }()

        showPrice.text = priceFormatter.string(for: marsHabitatPricerOutput.price)
    }
}
