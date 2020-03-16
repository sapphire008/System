# Log into the instance

ssh -i "keras.pem" ubuntu@ec2...


3.219.80.128

Make sure add ubuntu@ before the ec2 DNS address to log in
Make sure to change the persmission file with `chmod 400 keras.pem`

# Make sure to activate keras with tensorflow by selecting the correct command below
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.4.0-1081-aws x86_64v)

Please use one of the following commands to start the required environment with the framework of your choice:
for MXNet(+Keras2) with Python3 (CUDA 10.0 and Intel MKL-DNN) _____________________________________ source activate mxnet_p36
for MXNet(+Keras2) with Python2 (CUDA 10.0 and Intel MKL-DNN) _____________________________________ source activate mxnet_p27
for MXNet(+Amazon Elastic Inference) with Python3 _______________________________________ source activate amazonei_mxnet_p36
for MXNet(+Amazon Elastic Inference) with Python2 _______________________________________ source activate amazonei_mxnet_p27
for TensorFlow(+Keras2) with Python3 (CUDA 10.0 and Intel MKL-DNN) ___________________________ source activate tensorflow_p36
for TensorFlow(+Keras2) with Python2 (CUDA 10.0 and Intel MKL-DNN) ___________________________ source activate tensorflow_p27
for Tensorflow(+Amazon Elastic Inference) with Python2 _____________________________ source activate amazonei_tensorflow_p27
for Tensorflow(+Amazon Elastic Inference) with Python3 _____________________________ source activate amazonei_tensorflow_p36
for Theano(+Keras2) with Python3 (CUDA 9.0) _____________________________________________________ source activate theano_p36
for Theano(+Keras2) with Python2 (CUDA 9.0) _____________________________________________________ source activate theano_p27
for PyTorch with Python3 (CUDA 10.0 and Intel MKL) _____________________________________________ source activate pytorch_p36
for PyTorch with Python2 (CUDA 10.0 and Intel MKL) _____________________________________________ source activate pytorch_p27
for CNTK(+Keras2) with Python3 (CUDA 9.0 and Intel MKL-DNN) _______________________________________ source activate cntk_p36
for CNTK(+Keras2) with Python2 (CUDA 9.0 and Intel MKL-DNN) _______________________________________ source activate cntk_p27
for Caffe2 with Python2 (CUDA 9.0) ______________________________________________________________ source activate caffe2_p27
for Caffe with Python2 (CUDA 8.0) ________________________________________________________________ source activate caffe_p27
for Caffe with Python3 (CUDA 8.0) ________________________________________________________________ source activate caffe_p35
for Chainer with Python2 (CUDA 10.0 and Intel iDeep) ____________________________________________ source activate chainer_p27
for Chainer with Python3 (CUDA 10.0 and Intel iDeep) ____________________________________________ source activate chainer_p36
for base Python2 (CUDA 9.0) ________________________________________________________________________ source activate python2
for base Python3 (CUDA 9.0) ________________________________________________________________________ source activate python3

Official Conda User Guide: https://docs.conda.io/projects/conda/en/latest/user-guide/
AWS Deep Learning AMI Homepage: https://aws.amazon.com/machine-learning/amis/
Developer Guide and Release Notes: https://docs.aws.amazon.com/dlami/latest/devguide/what-is-dlami.html
Support: https://forums.aws.amazon.com/forum.jspa?forumID=263
For a fully managed experience, check out Amazon SageMaker at https://aws.amazonubuntu@ip-172-31-22-41:~$ pwd


# Mount the addition EBS volumes
1. List block volumes with
`lsblk`

2. Make sure there is nothing in the block volume right now, check with
`sudo file -s /dev/xvdf`

3. Reformat the volume to ext4
`sudo mkfs -t ext4 /dev/xvdf`

4. Make a monut point
`sudo mkdir /newvolume`


5. Mount it
`sudo mount /dev/xvdf /newvolume/`
`sudo chown -R ubuntu:ubuntu /newvolume`

6. Unmount it
`umount /dev/xvdf`


# Open up the jupyter notebook

1. `nano .ssh/config` to open up a new file. Add the following into the file. Save it.
```
Host ec2
    Hostname your-ec2’s-public-ip-address here
    User ubuntu
    IdentityFile ~/.ssh/tutorialexample.pem
```
2. Spin up the jupyter notebook instance in the EC2 instance. Notice the token below (there should be two tokens concatenated by &). Take a note and it will be used later.

3. Connect local's port 9999 to EC2 jupyter notebook's port 8888

`ssh -NfL 9999:localhost:8888 ec2`

4. Now, simply go to
`http://localhost:9999/tree`
To start the jupyter notebook on the server

5. For token, copy the token from the terminal to log in. Can also set a password.

6. To terminate the notebook
* List the notebook: `jupyter notebook list`
and check which port the current notebook is at
* Find the process PID based on port number
`lsof -n -i4TCP:8888`
* Kill the process based on the PID
`kill -9 2168`


# Uploading data to the EBS volume
Use Filezilla via SFTP

1. Edit -> Settings -> SFTP --> Add key file (point to the .pem key)
2. File -> Site managers -> New Site (change name to EC2)
  Protocol: SFTP
  Host: ec2- (DNS host)
  User: ubuntu
3. Click Connect


# Jupyter notebook extension
!conda install -y -c conda-forge jupyter_contrib_nbextensions


# Check GPU
`nvidia-smi`
