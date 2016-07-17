import boto
import glob, os
import time
import requests

bucket_name = 'logs-sparkydots-incoming'
app_name = 'starpractice'
seconds_between_checks = 30
on_signal_file = '/EFS/conf/log_uploader_on'

def get_keys():
    # this doesn't work well yet - using instance's role instead
    cred_uri = os.environ['AWS_CONTAINER_CREDENTIALS_RELATIVE_URI']
    r = requests.get('http://169.254.170.2%s' % cred_uri) # smth. like /v1/credentials?id=b7712c71-ea8f-4bff-9939-160f8c7cdd42
    r = r.json()
    return (r['AccessKeyId'], r['SecretAccessKey'])

def candidate_log_files(base_loc = '/EFS/logs/%s' % app_name):
    return glob.glob(base_loc + '/*.log.gz')

def upload():
    print('started')
    file_paths = candidate_log_files()
    fps = [(fp.split("/")[-1].split(".")[0], fp.split("/")[-1], fp) for fp in file_paths]

    (aws_access_key_id, aws_secret_access_key) = get_keys()
    # conn = boto.connect_s3(aws_access_key_id=aws_access_key_id, aws_secret_access_key=aws_secret_access_key)
    conn = boto.connect_s3()
    bucket = conn.get_bucket(bucket_name, validate=False)

    for (typ, fname, file_path) in fps:
        print('processing %s' % file_path)
        if typ != 'health':
            full_key_name = os.path.join('logs', app_name, fname)
            k = bucket.new_key(full_key_name)
            sent_size = k.set_contents_from_filename(file_path)
            print("sent size: %d" % sent_size)
        os.remove(file_path)
    print('done')

if __name__ == '__main__':
    while True:
        if os.path.isfile(on_signal_file):
            upload()
        else:
            print("Signal file is not there, not uploading (maintenance mode): %s" % on_signal_file)
        time.sleep(seconds_between_checks)
