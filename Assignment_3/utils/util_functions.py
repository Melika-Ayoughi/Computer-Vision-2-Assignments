import os


def ensure_current_directory():

    current_dir = os.getcwd()
    os.chdir(current_dir.split("Assignment_3")[0] + "Assignment_3/")
