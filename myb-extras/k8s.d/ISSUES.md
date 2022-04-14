2022-01:

mount.nfs4: timeout set for Thu Jan 13 21:25:36 2022
mount.nfs4: trying text-based options 'addr=172.16.0.3'
mount.nfs4: prog 100003, trying vers=3, prot=6
mount.nfs4: trying 172.16.0.3 prog 100003 vers 3 prot TCP port 2049
mount.nfs4: prog 100005, trying vers=3, prot=17
mount.nfs4: trying 172.16.0.3 prog 100005 vers 3 prot UDP port 649

rpcinfo -p <ip> 

по какой-то причине не всегда показывает nfsd, на порту 2049 (другие сервисы ок)
    100003    2   udp   2049  nfs
    100003    3   udp   2049  nfs
    100003    2   tcp   2049  nfs
    100003    3   tcp   2049  nfs

помогает рестарт service nfsd restart на хосте

