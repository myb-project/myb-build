bhyve_%%JNAME%%()
{
	vm_ram="4g"
	vm_cpus="2"
	imgsize="30g"
	vm_os_type="openbsd"
	vm_os_profile="cloud-openbsd-x86-7"

	ip4_addr="DHCP"
	ip4_gw="10.0.100.1"
	ci_jname="${jname}"
	ci_fqdn="${fqdn}"
	ci_ip4_addr="${ip4_addr}"
	ci_gw4="${ip4_gw}"
	imgtype="zvol"
	runasap=1
	ssh_wait=1
}

postcreate_%%JNAME%%()
{
	chmod +x %%INSTALL_SRC%%
	bscp %%INSTALL_SRC%% ${jname}:install_runner.sh
	bexec jname=${jname} sudo /home/openbsd/install_runner.sh
	rm -f %%INSTALL_SRC%%
}
