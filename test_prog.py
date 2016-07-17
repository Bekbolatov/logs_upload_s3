import time, os

on_signal_file = '/EFS/conf/log_uploader_on'

if __name__ == '__main__':
    while True:
        # os.stat(on_signal_file) # in case need exact reasons
        if os.path.isfile(on_signal_file):
            print("hello")
        else:
            print("NO")
        time.sleep(10)
