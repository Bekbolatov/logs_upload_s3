import os
import requests
from field_names import *


class ServiceRegistryCleaner():
    def __init__(self):
        self.cleaner = 'yes'

    def execute(self, conf):
        for service, port in conf[SERVICES].items():
            loc = conf[BASE_LOC] + '/' + service
            entries = [x for x in os.listdir(loc) if len(x) > 7 and not x.startswith('.')]
            for entry in entries:
                address = 'http://%s:%s/health.html' % (entry, port)
                try:
                    response = requests.get(address)
                    status = response.status_code
                except Exception as exc:
                    status = -1
                if status != 200:
                    os.remove(loc + '/' + entry)
