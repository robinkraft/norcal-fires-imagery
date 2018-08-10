# create s3 bucket norcal-fires-imagery
# create iam role so dg can push to it

# provision EC2 instance
# m4.xlarge for good network throughput
# 500 gb EBS HDD volume - this is gonna be sustained throughput of large amounts of data, don't need SSD.

# mount EBS volume at /data
# per https://devopscube.com/mount-ebs-volume-ec2-instance/
sudo file -s /dev/xvdf
sudo mkfs -t ext4 /dev/xvdf
sudo mount /dev/xvdf /data
sudo mkdir /data
sudo chown ubuntu /data

# gotta install gdal!
sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update
sudo apt install gdal-bin python-gdal

# other bits and bobs to install
sudo apt install unzip
sudo apt-get install python-setuptools python-dev build-essential
sudo easy_install pip
sudo pip install awscli
sudo pip install mapboxcli
