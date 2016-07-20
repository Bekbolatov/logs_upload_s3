import boto
import glob, os
import time
from .field_names import *


class LogUploader():

    def __init__(self):
        print("Uploader starting")
        self.last_upload_time = 0

    def candidate_log_files(self, conf, base_loc = None):
        if base_loc == None:
            base_loc = '/EFS/logs/%s' % conf[APP_NAME]
        return glob.glob(base_loc + '/*.gz')

    def upload(self, conf):
        self.last_upload_time = int(time.time())
        file_paths = self.candidate_log_files(conf)
        fps = [(fp.split("/")[-1].split(".")[0], fp.split("/")[-1], fp) for fp in file_paths]
        conn = boto.connect_s3()
        bucket = conn.get_bucket(conf[BUCKET_NAME], validate=False)

        if (len(fps) == 0):
            print("No new log files")
        for (typ, fname, file_path) in fps:
            print('processing %s' % file_path)
            if typ != 'health':
                full_key_name = os.path.join('logs', conf[APP_NAME], fname)
                k = bucket.new_key(full_key_name)
                sent_size = k.set_contents_from_filename(file_path)
                print("sent size: %d" % sent_size)
            os.remove(file_path)

    def execute(self, conf):
        cur_time = int(time.time())
        if cur_time - self.last_upload_time >= conf[LOG_CHECK_INTERVAL]:
            if conf[ACTIVE]:
                self.upload(conf)
