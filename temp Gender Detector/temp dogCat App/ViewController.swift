import CoreML
import Vision
import ImageIO
import UIKit


class ViewController: UIViewController
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classificationLabel: UILabel!
    
    
    
    /// - Tag: IN MD
    // Great library
    
    // MLModelSetup
    lazy var classificationRequest: VNCoreMLRequest =
        {
            do {
                let model = try VNCoreMLModel(for: GenderNet().model)
                
                let request = VNCoreMLRequest(model: model,
                                              completionHandler:
                    {
                        [weak self] request,
                        error in self?.processClassifications(for: request, error: error)
                })
                
                request.imageCropAndScaleOption = .centerCrop
                return request
            }
            catch
            {
                fatalError("Failed to load Vision ML model: \(error)")
            }
    }()
    
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage)
    {
        classificationLabel.text = "Classifying..."

        guard let ciImage = CIImage(image: image)
            else
        {
            fatalError("Unable to create \(CIImage.self) from \(image).")
        }
        
        DispatchQueue.global(qos: .userInitiated).async
            {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: CGImagePropertyOrientation.up)
            do {
                try handler.perform([self.classificationRequest])
            }
            catch
            {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    /// Updates the UI with the results of the classification.
    /// - Tag: ProcessClassifications
    func processClassifications(for request: VNRequest, error: Error?)
    {
        DispatchQueue.main.async
            {
            guard let results = request.results else
            {
                self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty
            {
                self.classificationLabel.text = "Nothing recognized."
            }
            else
            {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map
                { classification in
                    // Formats the classification for display; e.g. "(0.37) A, drop, drop-off".
                    return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                self.classificationLabel.text = "Classification:\n" + descriptions.joined(separator: "\n")
            }
        }
    }
    
}




// IMAGE MATTERS
extension ViewController:
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{
    @IBAction func takePicture()
    {
        // Show options for the source picker only if the camera is available.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else
        {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhoto = UIAlertAction(title: "Take Photo",
                                      style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo",
                                        style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        photoSourcePicker.addAction(takePhoto)
        photoSourcePicker.addAction(choosePhoto)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel",
                                                  style: .cancel,
                                                  handler: nil))
        
        present(photoSourcePicker, animated: true)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        picker.dismiss(animated: true)
        
        // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        
        
        updateClassifications(for: image)
    }
    
}
        
        

