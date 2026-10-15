
import os
import shutil
import time
print("PROGRAM STARTED")


path= r"C:/Users/Admin/OneDrive/Desktop/File_Sorter/"

Folder_Names = ["CSV files", "Image files", "Text files"]

def sorter():
    file= os.listdir(path)

    for folder_type in Folder_Names:
        if not os.path.exists(path + folder_type):
            os.makedirs(path + folder_type)
    for file_type in file:
        if file_type.endswith(".xlsx") and not os.path.exists(path +"CSV files/"+file_type):
            shutil.move(path+file_type , path + "CSV files/"+file_type)
        elif file_type.endswith(".png") and not os.path.exists(path +"Image files/"+file_type):
            shutil.move(path+file_type , path + "Image files/"+file_type)
        elif file_type.endswith(".txt") and not os.path.exists(path +"Text files/"+file_type):
            shutil.move(path+file_type , path + "Text files/"+file_type)

while True:
        print("Checking for new files...")
        sorter()
        time.sleep(10)


