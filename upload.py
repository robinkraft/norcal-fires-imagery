import os
import sys

from mapbox import Uploader

USER = 'robinkraft'
BASEPATH = '/data/saturday/out'
FNAME_MODEL = '{}_wm.tif'
DATE = '2017-10-14'

if __name__ == '__main__':
    mosaic_id = sys.argv[1]

    JOBS = []


    u = Uploader()

    fname = FNAME_MODEL.format(mosaic_id)
    path = os.path.join(BASEPATH, fname)
    tileset = '{}.{}-{}'.format(USER, mosaic_id, DATE)
    url = u.stage(open(path))
    job = u.create(url, tileset, name=fname).json()
    print(job)
    JOBS.append(job)
