1）查看KVM虚拟机配置文件及运行状态
KVM虚拟机默认配置文件位置: /etc/libvirt/qemu/
autostart目录是配置kvm虚拟机开机自启动目录。
 
virsh命令帮助
# virsh -help
或直接virsh命令和，再执行子命令。如下所示。
# virsh
欢迎使用 virsh，虚拟化的交互式终端。
输入：'help' 来获得命令的帮助信息
'quit' 退出
virsh # help
.......
 
查看kvm虚拟机状态
#virsh list --all
 
2）KVM虚拟机开机
# virsh start oeltest01
 
3）KVM虚拟机关机或断电
关机
默认情况下virsh工具不能对linux虚拟机进行关机操作，linux操作系统需要开启与启动acpid服务。在安装KVM linux虚拟机必须配置此服务。
# chkconfig acpid on
# service acpid restart
virsh关机
# virsh shutdown oeltest01
 
强制关闭电源
# virsh destroy wintest01
 
4）通过配置文件启动虚拟机
# virsh create /etc/libvirt/qemu/wintest01.xml
 
5）配置开机自启动虚拟机
# virsh autostart oeltest01
 
autostart目录是kvm虚拟机开机自启动目录，可以看到该目录中有KVM配置文件链接。
 
6）导出KVM虚拟机配置文件
# virsh dumpxml wintest01 > /etc/libvirt/qemu/wintest02.xml
 
KVM虚拟机配置文件可以通过这种方式进行备份。
 
7）添加与删除KVM虚拟机
删除kvm虚拟机
# virsh undefine wintest01
说明：该命令只是删除wintest01的配置文件，并不删除虚拟磁盘文件。
 
重新定义虚拟机配置文件
通过导出备份的配置文件恢复原KVM虚拟机的定义，并重新定义虚拟机。
# mv /etc/libvirt/qemu/wintest02.xml /etc/libvirt/qemu/wintest01.xml
# virsh define /etc/libvirt/qemu/wintest01.xml
 
8）编辑KVM虚拟机配置文件
# virsh edit wintest01
virsh edit将调用vi命令编辑/etc/libvirt/qemu/wintest01.xml配置文件。也可以直接通过vi命令进行编辑，修改，保存。
可以但不建议直接通过vi编辑。
# vim /etc/libvirt/qemu/wintest01.xml
 
9）irsh console 控制台管理linux虚拟机
配置virsh console见下文
kvm虚拟化学习笔记(六)之kvm虚拟机控制台登录配置
# virsh console oeltest01
 
10）其它virsh命令
挂起服务器
# virsh suspend oeltest01
 
恢复服务器
# virsh resume oeltest01
 
virsh命令丰富。可以执行各种维护任务，本文只是从维护与管理的角度例举了常用的命令，为该命令的使用提供一个思路。
 
 
-------------------------------------------其他命令-------------------------------------------
1）创建虚拟机
[root@localhost ~]# virt-install --name=centos1 \ #生成一个虚拟机
--ram 1024 --vcpus=1 \
--disk path=/root/centos1.img,size=10 \
--accelerate --cdrom /root/CentOS-6.5-x86_64-bin-DVD1.iso \
--graphics vnc,port=5921 --network bridge=br0
 
2）virsh的其他操作
[root@localhost /]# virsh start centos1 #启动虚拟机
[root@localhost /]# virt-viewer centos1 #如果有图形界面的话，可以进入虚拟机的界面
[root@localhost ~]# virsh shutdown centos1 #关闭虚拟机
[root@localhost /]# virsh reboot centos1 #重启虚拟机
[root@localhost /]# virsh suspend centos1 #暂停虚拟机
[root@localhost /]# virsh resume centos1 #恢复虚拟机
[root@localhost /]# virsh autostart centos1 #自动加载虚拟机
 
-------------------------------------------virsh参数如下-------------------------------------------
autostart      #自动加载指定的一个虚拟机
connect        #重新连接到hypervisor
console        #连接到客户会话
create         #从一个SML文件创建一个虚拟机
start          #开始一个非活跃的虚拟机
destroy        #删除一个虚拟机
define         #从一个XML文件定义一个虚拟机
domid          #把一个虚拟机名或UUID转换为ID
domuuid        #把一个郁闷或ID转换为UUID
dominfo        #查看虚拟机信息
domstate       #查看虚拟机状态
domblkstat     #获取虚拟机设备快状态
domifstat      #获取虚拟机网络接口状态
dumpxml        #XML中的虚拟机信息
edit           #编辑某个虚拟机的XML文件
list           #列出虚拟机
migrate        #将虚拟机迁移到另一台主机
quit           #退出非交互式终端
reboot         #重新启动一个虚拟机
resume         #重新恢复一个虚拟机
save           #把一个虚拟机的状态保存到一个文件
dump           #把一个虚拟机的内核dump到一个文件中以方便分析
shutdown       #关闭一个虚拟机
setmem         #改变内存的分配
setmaxmem      #改变最大内存限制值
suspend        #挂起一个虚拟机
vcpuinfo       #虚拟机的cpu信息
version        #显示virsh版本
 
3）virt-clone，如果我们要建几个一样的虚拟机，这个命令，非常有用！
# virt-clone --connect=qemu:#/system -o centos1 -n centos3 -f /root/centos3.img #克隆centos1
正在克隆 centos1.img | 10.0 GB 00:07
 
Clone 'centos3' created successfully.
libguestfs-tools是虚拟机一个管理包，很有用的工具
[root@localhost ~]# yum -y install libguestfs-tools #安装工具包
 
4）未登录的情况下，查看镜像目录
[root@localhost ~]# virt-ls centos.img /home #查看centos.img镜像文件中/home目录
tank
 
5）未登录的情况下，将镜像文件中的文件copy出来
[root@localhost ~]# virsh list --all #查看所有的虚拟机名称
Id 名称 状态
----------------------------------------------------
1 centos1 running
2 centos6.5 running
- arch 关闭
- arch1 关闭
- arch2 关闭
- arch3 关闭
- arch5 关闭
- centos3 关闭
- ubuntu 关闭
- ubuntu1 关闭
[root@localhost ~]# virt-copy-out -d centos1 /etc/passwd /tmp          #将centos1中的文件copy到tmp下面
 
6）查看虚拟机的分区情况
[root@localhost ~]# virt-filesystems -d centos1
/dev/sda1
/dev/VolGroup/lv_root
[root@localhost ~]# virt-list-partitions /root/centos.img
/dev/sda1
/dev/sda2
[root@localhost ~]# virt-df centos.img
Filesystem 1K-blocks Used Available Use%
centos.img:/dev/sda1 495844 34510 435734 7%
centos.img:/dev/VolGroup/lv_root 8780808 2842056 5492700 33%
 
7）mount虚拟机
[root@localhost ~]# guestmount -a /root/centos.img -m /dev/VolGroup/lv_root --rw /mnt/usb
[root@localhost ~]# cd /mnt/usb/
[root@localhost usb]# ls
bin dev home lib64 media mnt opt root selinux sys usr
boot etc lib lost+found misc net proc sbin srv tmp var
 
8）修改kvm中虚拟机的内存大小
[root@nfs ~]# virsh edit vm01 ##注意vi直接编辑不生效
vm01
df8604c1-dcf3-fa98-420f-6eea7b39c395
1048576 ###本来开始设置为1G，现在这个单位是k
1048576
 
修改为1.5G
[root@nfs ~]# expr 1536 \* 1024
1572864</p> <p>[root@nfs ~]# virsh list
Id Name State
----------------------------------
1 win2003 running
3 vm01 running

[root@nfs ~]# virsh shutdown vm01         ###修改配置文件后需要重新启动下虚拟机，先关闭它
Domain vm01 is being shutdown
>[root@nfs ~]# virsh list                 ###确认已经被关闭
Id Name State
----------------------------------
1 win2003 running

[root@nfs ~]# virsh start vm01 ###启动它
Domain vm01 started

[root@nfs ~]# virsh list
Id Name State
----------------------------------
1 win2003 running
3 vm01 running
 
到机器上查看内存大小：
[root@vm01 liuxiaojie]# free -m
total used free shared buffers cached
Mem: 1505 618 886 0 29 361
-/+ buffers/cache: 227 1277
Swap: 2000 0 2000
 
9）删除一个虚拟机（vm01），可以删除一个状态为“shut off”的虚拟机
[root@nfs qemu]# virsh undefine vm01
[root@nfs qemu]# rm -f /home/data/vm01.img
 
10）删除一个域
[root@nfs web01]# virsh list --all
Id Name State
----------------------------------
1 web01 running ##处于工作状态
- myweb01 shut off
- myweb03 shut off
- mywin2003 shut off
- myxp shut off
- xp shut off
[root@nfs web01]# virsh undefine web01 ##处于工作状态也能删除！
Domain web01 has been undefined
[root@nfs web01]# virsh list
Id Name State
----------------------------------
1 web01 running
[root@nfs web01]# virsh destroy web01
Domain web01 destroyed
[root@nfs web01]# virsh list --all ##web01已经没有了！
Id Name State
----------------------------------
- myweb01 shut off
- myweb03 shut off
- mywin2003 shut off
- myxp shut off
- xp shut off
[root@nfs web01]# virsh define web01
error: Failed to open file 'web01': No such file or directory
 
-------------------------------------------virsh相关命令-------------------------------------------
1）安装libvirt
#yum install kvm virt-* libvirt
2）检查是否安装成功
#lsmod |grep kvm
3）相关命令
#virsh -c qemu:#/system list
#virsh list
#virsh list --all                  #查看所有状态的虚拟机
#virsh shutdown myWin7             #关闭myWin7虚拟机
#virsh destroy myWin7          #删除myWin7虚拟机
#virsh start node4                     #开机虚拟机
#virsh define /etc/libvirt/qemu/node5.xml        #根据主机配置文档添加虚拟机
#virsh dumpxml node4 > /etc/libvirt/qemu/node6.xml      #将node4虚机的配置文件保存至node6.xml
#virsh edit node6             #修改node6的配置文件
#virsh suspend vm_name          #暂停虚拟机
#virsh resume vm_name          #恢复虚拟机
4）vm配置文件路径
/etc/libvirtd/qemu/***.xml 可以通过vim对配置文件进行管理，编辑后需要#service libvirtd restart（不会对现有VM有影响。）

