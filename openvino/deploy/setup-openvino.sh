sudo -i
#Download the required openvino toolkit package 
wget http://registrationcenter-download.intel.com/akdlm/irc_nas/15792/l_openvino_toolkit_p_2019.2.275.tgz

#Install the core components
tar -zxvf l_openvino_toolkit_p_2019.2.275.tgz

cd l_openvino_toolkit_p_2019.2.275

./install.sh

#----------------------------------------------------------#
#Install External Software Dependencies
cd /opt/intel/openvino/install_dependencies

sudo -E ./install_openvino_dependencies.sh

#----------------------------------------------------------#
#Set the Environment Variables
cd /root
#source /opt/intel/openvino/bin/setupvars.sh
vim .bashrc

#Add to the end of the file
source /opt/intel/openvino/bin/setupvars.sh

#----------------------------------------------------------#
#Configure the Model Optimizer
cd /opt/intel/openvino/deployment_tools/model_optimizer/install_prerequisites

#Configure all supported frameworks at the same time
#sudo ./install_prerequisites.sh

#Configure each framework separately

#Caffe
./install_prerequisites_caffe.sh

#TensorFlow
./install_prerequisites_tf.sh

#MXNet
./install_prerequisites_mxnet.sh

#ONNX
./install_prerequisites_onnx.sh

#Kaldi
./install_prerequisites_kaldi.sh

#----------------------------------------------------------#
#Run the Verification Scripts to Verify Installation
cd /opt/intel/openvino/deployment_tools/demo

#Image Classification verification script:
./demo_squeezenet_download_convert_run.sh

#Inference Pipeline verification script
./demo_security_barrier_camera.sh

#----------------------------------------------------------#
#Default use cpu to work with our trained models, to use other hardware
#Steps for Intel® Processor Graphics (GPU)
cd /opt/intel/openvino/install_dependencies/

sudo -E su

./install_NEO_OCL_driver.sh

#Steps for Intel® Movidius™ Neural Compute Stick and Intel® Neural Compute Stick 2
sudo usermod -a -G users "$(whoami)"

sudo cp /opt/intel/openvino/inference_engine/external/97-myriad-usbboot.rules /etc/udev/rules.d/

sudo udevadm control --reload-rules
sudo udevadm trigger
sudo ldconfig

#Steps for Intel® Vision Accelerator Design with Intel® Movidius™ VPU
cd /opt/intel/openvino/deployment_tools/demo

./demo_squeezenet_download_convert_run.sh -d HDDL

./demo_security_barrier_camera.sh -d HDDL
