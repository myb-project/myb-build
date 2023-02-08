# k8s
CBSD module to deploy kubernetes cluster

This module requires the kubernetes cloud image, please fetch via:

`cbsd fetch_iso name=cloud-kubernetes-26 dstdir=default cloud=1 conv2zvol=1`

To install:

```sh
cbsd module mode=install k8s
echo 'k8s.d' >> ~cbsd/etc/modules.conf
cbsd initenv
```

Quick start:

1)
  `cbsd k8s mode=init`

or PV enabled ( 10Gb, NFS server: 10.0.100.1 ). Warning: fix/set correct interface instead of 'em0':

```
cbsd k8s mode=init k8s_name=master1 init_masters_ips=DHCP vip=DHCP \
master_interface=em0 \
worker_interface=em0 \
ip4_gw=10.0.100.1 \
ntp_servers=10.0.100.1 \
pv_enable=10 \
pv_spec_server=10.0.100.1
```

2) `cbsd k8s mode=init_upfile k8s_name="master1"`

3) `cbsd up`


  Refer to the [documentation page](https://www.bsdstore.ru/en/12.x/wf_k8s_ssi.html).


# Play with k8s

`kubectl run my-shell --rm -i --tty --image ubuntu -- bash`

When the pod is running: 
`kubectl attach my-shell -c my-shell -i -t`
