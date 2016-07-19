import boto
import glob, os
from pyhocon import ConfigFactory
import time

CONF_SECTION = 'sparkydots.log_uploader'

SYNC_CONF_INTERVAL = 'sync_conf_interval'
CONF_FILE = 'conf_file'
BUCKET_NAME = 'bucket_name'
APP_NAME = 'app_name'
LOG_CHECK_INTERVAL = 'log_check_interval'
ACTIVE = 'active'

class LogUploader():

    def __init__(self, conf_file = '/EFS/conf/sparkydots.conf', sync_conf_interval = 15):
        print("Uploader starting")
        self.conf = {
            SYNC_CONF_INTERVAL: sync_conf_interval,
            CONF_FILE: conf_file
        }
        self.last_sync_conf = 0
        self.last_upload_time = 0
        self.sync_conf()

    def sync_conf(self):
        cur_time = int(time.time())
        last_mod = os.path.getmtime(self.conf[CONF_FILE])
        last_mod = max(last_mod, os.path.getmtime('/EFS/conf/log_uploader.conf'))
        if last_mod > self.last_sync_conf:
            root_conf = ConfigFactory.parse_file(self.conf[CONF_FILE])
            source_conf = root_conf[CONF_SECTION]

            self.conf[BUCKET_NAME] = source_conf.get_string(BUCKET_NAME)
            self.conf[APP_NAME] = source_conf.get_string(APP_NAME)
            self.conf[LOG_CHECK_INTERVAL] = source_conf.get_int(LOG_CHECK_INTERVAL)
            self.conf[SYNC_CONF_INTERVAL] = source_conf.get_int(SYNC_CONF_INTERVAL)
            self.conf[CONF_FILE] = source_conf.get_string(CONF_FILE)
            self.conf[ACTIVE] = source_conf.get_bool(ACTIVE)
            print("New conf:")
            print(self.conf)
            self.last_sync_conf = cur_time
        else:
            print("Conf not modified")

    def candidate_log_files(self, base_loc = None):
        if base_loc == None:
            base_loc = '/EFS/logs/%s' % self.conf[APP_NAME]
        return glob.glob(base_loc + '/*.gz')

    def upload(self):
        self.last_upload_time = int(time.time())
        file_paths = self.candidate_log_files()
        fps = [(fp.split("/")[-1].split(".")[0], fp.split("/")[-1], fp) for fp in file_paths]
        conn = boto.connect_s3()
        bucket = conn.get_bucket(self.conf[BUCKET_NAME], validate=False)

        if (len(fps) == 0):
            print("No new log files")
        for (typ, fname, file_path) in fps:
            print('processing %s' % file_path)
            if typ != 'health':
                full_key_name = os.path.join('logs', self.conf[APP_NAME], fname)
                k = bucket.new_key(full_key_name)
                sent_size = k.set_contents_from_filename(file_path)
                print("sent size: %d" % sent_size)
            os.remove(file_path)

    def tick(self):
        self.sync_conf()
        cur_time = int(time.time())
        if cur_time - self.last_upload_time >= self.conf[LOG_CHECK_INTERVAL]:
            if self.conf[ACTIVE]:
                self.upload()
        time.sleep(self.conf[SYNC_CONF_INTERVAL])

    def run(self):
        while True:
            self.tick()

if __name__ == '__main__':
    uploader = LogUploader()
    uploader.run()

