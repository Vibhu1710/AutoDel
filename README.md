# AutoDel
Non-essential whatsapp images classifier using MobileNet CNN model

* Trained MobileNet CNN model on a custom dataset of about 5000 whatsapp images. 
* The model classifies the images into 6 categories namely Paper, Screenshots, Family, Posters, Memes and Others.
* The idea is to categorize the images and select non-essential whatsapp images among these categories based on confidence scores which can then be deleted in one go instead of having to select them manually for deletion.

### Final Accuracy of the model
The model achieved a final accuracy of 94.66% after performing transfer learning on a COCO dataset trained MobileNet model.
