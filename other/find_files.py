
import boto #.s3.connection import S3Connection
import glob, os

app_name = 'starpractice'

def candidate_log_files(base_loc = '/EFS/logs/%s' % app_name):
    return glob.glob(base_loc + '/*.log.gz')

def upload():
    print('starting...')
    file_paths = candidate_log_files()
    fps = [(fp.split("/")[-1].split(".")[0], fp.split("/")[-1], fp) for fp in file_paths]
    bucket_name = 'logs-sparkydots-incoming'

    conn = boto.connect_s3()
    bucket = conn.get_bucket(bucket_name)

    for (typ, fname, file_path) in fps:
        print('processing %s' % file_path)
        if typ != 'health':
            full_key_name = os.path.join('logs', app_name, fname)
            k = bucket.new_key(full_key_name)
            print('uploading')
            sent_size = k.set_contents_from_filename(file_path)
            print("sent size: %d" % sent_size)
        print('deleting')
        os.remove(file_path)
    print('done')

if __name__ == '__main__':
    upload()

# more elaborate way below:
# import os
#
# import boto
# from boto.s3.key import Key
#
# def upload_to_s3(aws_access_key_id, aws_secret_access_key, file, bucket, key, callback=None, md5=None, reduced_redundancy=False, content_type=None):
#     """
#     Uploads the given file to the AWS S3
#     bucket and key specified.
#
#     callback is a function of the form:
#
#     def callback(complete, total)
#
#     The callback should accept two integer parameters,
#     the first representing the number of bytes that
#     have been successfully transmitted to S3 and the
#     second representing the size of the to be transmitted
#     object.
#
#     Returns boolean indicating success/failure of upload.
#     """
#     try:
#         size = os.fstat(file.fileno()).st_size
#     except:
#         # Not all file objects implement fileno(),
#         # so we fall back on this
#         file.seek(0, os.SEEK_END)
#         size = file.tell()
#
#     conn = boto.connect_s3(aws_access_key_id, aws_secret_access_key)
#     bucket = conn.get_bucket(bucket, validate=True)
#     k = Key(bucket)
#     k.key = key
#     if content_type:
#         k.set_metadata('Content-Type', content_type)
#     sent = k.set_contents_from_file(file, cb=callback, md5=md5, reduced_redundancy=reduced_redundancy, rewind=True)
#
#     # Rewind for later use
#     file.seek(0)
#
#     if sent == size:
#         return True
#     return False
#
#
# file = open('someFile.txt', 'r+')
#
# key = file.name
# bucket = 'your-bucket'
#
# if upload_to_s3(AWS_ACCESS_KEY, AWS_ACCESS_SECRET_KEY, file, bucket, key):
#     print 'It worked!'
# else:
#     print 'The upload failed...'
#
