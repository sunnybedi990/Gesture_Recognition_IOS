import Foundation
import CoreML
import AVFoundation

class PredictionManager: ObservableObject {
    @Published var currentPrediction: String = "No Gesture Detected"
    private var model: GestureModel? // Replace GestureModel with your actual model class
    var sessionManager: SessionManager

    init() {
        sessionManager = SessionManager(predictionHandler: self)
        loadModel()
    }

    private func loadModel() {
        do {
            model = try GestureModel(configuration: MLModelConfiguration())
        } catch {
            print("Error loading model: \(error)")
        }
    }

    func processPredictionOutput(_ output: MLMultiArray) -> String {
        guard let ptr = try? UnsafeBufferPointer<Float>(output) else {
            return "Error processing output"
        }
        let array = Array(ptr)

        // Assuming the model outputs probabilities and you want to find the class with the highest probability
        if let maxProbabilityIndex = array.indices.max(by: { array[$0] < array[$1] }) {
            return className(forIndex: maxProbabilityIndex)
        }

        return "No valid prediction"
    }

    func className(forIndex index: Int) -> String {
        // Map the index to a class name based on your specific model's classes
        let classes = ["Class1", "Class2", "Class3", "Class4", "Class5"]
        return classes[index]
    }

    func makePrediction(with buffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(buffer),
              let model = model else { return } // Ensure model is loaded

        let input = GestureModelInput(x_1: <#T##MLMultiArray#>) // Correct the input according to your actual model input class

        guard let output = try? model.prediction(input: input) else {
            DispatchQueue.main.async {
                self.currentPrediction = "Failed to make prediction"
            }
            return
        }

        // Process the MLMultiArray output from the model
        DispatchQueue.main.async {
            self.currentPrediction = self.processPredictionOutput(output.linear_2)  // Replace <#outputFeatureName#> with the actual feature name of the model's output
        }
    }
}
