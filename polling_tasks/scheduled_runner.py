import os
import time
from pyhocon import ConfigFactory
from field_names import *
from service_registry_cleaner import ServiceRegistryCleaner
from upload_logs import LogUploader


class ScheduledRunner():
    def __init__(self, conf_file = '/EFS/conf/sparkydots.conf', sync_conf_interval = 15):
        print("ScheduledRunner starting")
        self.conf = {
            SYNC_CONF_INTERVAL: sync_conf_interval,
            CONF_FILE: conf_file
        }
        self.last_sync_conf = 0
        self.sync_conf()
        self.log_uploader = LogUploader()
        self.registry_cleaner = ServiceRegistryCleaner()


    def sync_conf(self):
        cur_time = int(time.time())
        last_mod = os.path.getmtime(self.conf[CONF_FILE])
        last_mod = max(last_mod, os.path.getmtime('/EFS/conf/log_uploader.conf'))
        if last_mod > self.last_sync_conf:
            root_conf = ConfigFactory.parse_file(self.conf[CONF_FILE])['sparkydots']
            self.conf[CONF_FILE] = root_conf.get_string(CONF_FILE)
            self.conf[SYNC_CONF_INTERVAL] = root_conf.get_int(SYNC_CONF_INTERVAL)

            source_conf = root_conf[SECTION_LOG_UPLOADER]
            self.conf[BUCKET_NAME] = source_conf.get_string(BUCKET_NAME)
            self.conf[APP_NAME] = source_conf.get_string(APP_NAME)
            self.conf[LOG_CHECK_INTERVAL] = source_conf.get_int(LOG_CHECK_INTERVAL)
            self.conf[ACTIVE] = source_conf.get_bool(ACTIVE)

            source_conf = root_conf[SECTION_REGISTRY_CLEANER]
            self.conf[BASE_LOC] = source_conf.get_string(BASE_LOC)
            self.conf[SERVICES] = source_conf.get_string(SERVICES)

            print("New conf:")
            print(self.conf)
            self.last_sync_conf = cur_time
        else:
            print("Conf not modified")

    def tick(self):
        self.sync_conf()

        self.log_uploader.execute(self.conf)
        self.registry_cleaner.execute(self.conf)

        time.sleep(self.conf[SYNC_CONF_INTERVAL])

    def run(self):
        while True:
            self.tick()

if __name__ == '__main__':
    scheduledRunner = ScheduledRunner()
    scheduledRunner.run()
