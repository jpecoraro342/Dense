import UIKit
import Vision
import _Concurrency
import PlaygroundSupport

struct NutritionLabel {
    var rawText: [String]
    var parsedText: String
    var servingsPerContainer: String?
    var servingSize: String?
    var servingSizeG: String?
    var calories: String?
    var totalFat: String?
    var sodium: String?
    var totalCarbohydrate: String?
    var dietaryFiber: String?
    var sugar: String?
    var protein: String?
}

// MARK: Text Parsing

func parseNutritionlabel(fromImage image: UIImage) async -> NutritionLabel? {
    let rawText = await parseNutritionlabel(fromImage: image.cgImage)
    let parsedText = rawText.joined(separator: " ")
    
    print(rawText)
    return nil
}

private func parseNutritionlabel(fromImage image: CGImage?) async -> [String] {
    await withCheckedContinuation { continuation in
        parseNutritionlabel(fromImage: image, completion: { fullLabelText in
            continuation.resume(returning: fullLabelText)
        })
    }
}

private func parseNutritionlabel(fromImage: CGImage?, completion: @escaping ([String]) -> Void) {
    guard let image = fromImage else {
        completion([])
        return
    }
    // Create a new image-request handler.
    let requestHandler = VNImageRequestHandler(cgImage: image)

    // Create a new request to recognize text.
    let request = VNRecognizeTextRequest { request, error in
        let parsedText = recognizeTextHandler(request: request, error: error)
        completion(parsedText)
    }

    do {
        // Perform the text-recognition request.
        try requestHandler.perform([request])
    } catch {
        completion([])
        print("Unable to perform the requests: \(error).")
    }
}

private func recognizeTextHandler(request: VNRequest, error: Error?) -> [String] {
    guard let observations =
            request.results as? [VNRecognizedTextObservation] else {
        return []
    }
    // print(observations)
    
    let recognizedStrings = observations.compactMap { observation in
        // Return the string of the top VNRecognizedText instance.
        return observation.topCandidates(1).first?.string
    }
    
    return recognizedStrings
}

let pngs = Bundle.main.paths(forResourcesOfType: "png", inDirectory: nil)
let jpgs = Bundle.main.paths(forResourcesOfType: "jpg", inDirectory: nil)
let jpegs = Bundle.main.paths(forResourcesOfType: "jpeg", inDirectory: nil)
let webp = Bundle.main.paths(forResourcesOfType: "webp", inDirectory: nil)
let heic = Bundle.main.paths(forResourcesOfType: "heic", inDirectory: nil)

//let images = (pngs + jpgs + jpegs + webp).map({ path in
//    return await parseCoffee(fromImage: UIImage(contentsOfFile: path)!.cgImage)
//})

func getNutrition() async -> [NutritionLabel] {
    var nutrition : [NutritionLabel] = []

    let group = DispatchGroup()

    for path in (pngs + jpgs + jpegs + webp + heic) {
        group.enter()
        if let nutritionLabel = await parseNutritionlabel(fromImage: UIImage(contentsOfFile: path)!) {
            nutrition.append(nutritionLabel)
        }
        group.leave()
    }

    group.notify(queue: .main, execute: { // executed after all async calls in for loop finish
        print("done with all async calls")
    })
    
    return nutrition
}

Task {
    let nutrition = await getNutrition()
    print("done getting coffees")
    nutrition.forEach { nutrition in
        print(nutrition.parsedText)
    }
    
    PlaygroundPage.current.finishExecution()
}

PlaygroundPage.current.needsIndefiniteExecution = true
