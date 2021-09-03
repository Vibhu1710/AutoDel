import os

destination=r'C:\Users\Acer\Desktop\Paper'
filenames=os.listdir(destination)

len(filenames)

for filename,num in zip(filenames,range(1120)):
    os.rename(destination+'\\'+filename,destination+'\\'+'paper '+str(num)+'.jpg')

filenames=os.listdir(destination)