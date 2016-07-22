import os, time
import requests
from .field_names import *


class ServiceRegistryMaintainer():
    """
    Remove records from /EFS/run/services/<SERVICE>/<IP> if health checks are not good
    """
    def __init__(self):
        self.cleaner = 'yes'

    def execute(self, conf):
        for service, info in conf[SERVICES].items():
            cur_time = int(time.time())
            health_url = info.get_string(HEALTH_URL)
            loc = conf[BASE_LOC] + '/' + service
            entries = [x for x in os.listdir(loc) if len(x) > 7 and not x.startswith('.')]
            for entry in entries:
                last_mod = os.path.getmtime(loc + '/' + entry)
                # don't touch just freshly touched services
                if cur_time - last_mod > 10:
                    try:
                        pieces = entry.split(":")
                        address = 'http://%s:%s%s' % (pieces[0], pieces[1], health_url)
                        response = requests.get(address)
                        status = response.status_code
                    except Exception as exc:
                        status = -1
                    if status != 200:
                        print("Removing %s: status: %s" % (loc + '/' + entry, str(status)))
                        os.remove(loc + '/' + entry)
