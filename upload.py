import os
import sys

from mapbox import Uploader

USER = 'robinkraft'

if __name__ == '__main__':
    path = sys.argv[1]
    mosaic_id = sys.argv[2]
    date = sys.argv[3]

    basepath, fname = os.path.split(path)

    u = Uploader()

    tileset = '{}.{}-{}'.format(USER, mosaic_id, date)
    url = u.stage(open(path))
    job = u.create(url, tileset, name=fname).json()

    print(job)
