#!/bin/bash

# Debug
set -eux

function f_check_is_root {
  if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
  fi
}

f_check_is_root

# Set root password
echo "root:atomic" | chpasswd

if ! id "jedi" >/dev/null 2>&1; then
  useradd jedi  
fi
usermod -a -G wheel jedi
echo "jedi:atomic" | chpasswd

# jedi
mkdir -m0700 -p /home/jedi/.ssh/

# Privage key
cat <<EOF2 >/home/jedi/.ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAt1DYqC4ie/epflCm6wUpIHewxvPXUwaRCCzE/TGuQk3ZbXIr
Qcau5NDlxlVaZsuqwYFhQHisQNKlCcFsLeK/px0pVO9YTDYdRjOYf65cfeW+dMlO
eq+eR+fy9c377PvmU3Tm1R4yWoRfrEP1Inw0bXI6z6QpmAbtPbZnjfuNQEhvOSCD
RuwNUIZ07lyxdtpCMoA4/RcMVgisfLhAnn3+6HVUtmqtI23jbfmR2kUDyALHZ8uS
F2c8ajEvI+162zCXtOjvPHFCSEfD5ErHIXposMiywOh3M9inxhI1nVY29wY2WhjT
tRAiioC0z6SnM4xsYVIpic+ifHrttjvwjdS8cwIDAQABAoIBAB+ZZw9ujHE0Gtp0
SqGejR1UpHtXExnzutJe7UH7617wjndIQ96dwg4dWE5c7i1kFDYw+DOl2YN/DAXn
ep9aQ9EpvLMwYtcYSOmOAU6ZHsZw8OiuvsF1PmKEwCPQ8wlBzs06DIRWJTXnNZq7
SCk+ocbv9uVOFgFnyENoCue1of6fcuQBD8K+7L3txH8QJ65vqmMYP5vaM2wlGcFa
O+cQapSYqjGcJjmVncsOh1LWDWeksMLB2nmfHq9nIqZUAo5st0wxXlM1y8pvV5Gm
Jg9Xnj/SYJsVd3zhZQExJXYAtclfmDteqxZDz/IH38Zyb+ZUlZK4WBvVwbaEgeU3
bAvBZTECgYEA60xQKNJEPjdcbge3rHM7LLoY/gMRnDaqlHbvogvptW1yWyNnI0FR
k3MmObnp9/Eg1r4bK8S4Nlsl5fxBvs/AE6L2n2FrOnrHGyKF+0yTMTSMfdw7YDB1
mf1CMh00l9Otf6nR17NjLb0u0j6mezF7CXvYnvqHAgUS4Ajlx0HgrrkCgYEAx3G4
lmAb9SY0jfx/Yrnlz/9baHo32irpqhtnA2JTtiltSCfu8ZAU8GdRjobjO5HyLcTk
D63+WjtrDKmdtcfKZS91ZLaPOC2x7INd97zBBQ4LND+ROgoBrsEJVLa3r9CI97QW
KZoMt2UEEms8Kgq2obSY3Mq/uFJ213SzJ9elzosCgYEAredgE1ucjnMyQCw6Bx2/
bYY5dHtmJ5OLrWDeKWEuoSW78DoRP1BGb3kalm2ey96OS8iDomypTZs+PmWbXeCD
8L9wEUnaC4W05Iw2hA4Ld8GD2H3N8IDAWkiBBTLqrRAI2iLz8b0mnyaElWUyfDiM
2+yJpK463DZNxgEteoBpBBkCgYArYNKS8khiY3LexuI16NTRDmslKB/ptZeoxdj7
5XDrl8sK/JR9uaa0OuSEKVZW6IFR7xbjSiaeHXpFAMcqeE/O/il8RDCWOWoPVOsl
LMqWfN12+bRueSqwhY+v+yWseaCwr1x6o+TMJo5iKyykwDvEo/DzZK2aO2VZqyok
KkUHzQKBgQCxgGiz/k2Jo83WFD6eZEq/NSAlKUIOhdjcVPLJmtgTAH19QS3mL9b+
/teq85fXcuoKxBaAoQ3dtFN+N+57UDZ3aL3KPtb3uCmADYLxPseH677o+ULHzYsg
FXRdOCMJo3OhWgJk5PyuqmRvDnr4zhBUl0L+qlXLdHZxlYEQCNEYRQ==
-----END RSA PRIVATE KEY-----
EOF2

# Public key
jedi_user_public_key='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3UNioLiJ796l+UKbrBSkgd7DG89dTBpEILMT9Ma5CTdltcitBxq7k0OXGVVpmy6rBgWFAeKxA0qUJwWwt4r+nHSlU71hMNh1GM5h/rlx95b50yU56r55H5/L1zfvs++ZTdObVHjJahF+sQ/UifDRtcjrPpCmYBu09tmeN+41ASG85IING7A1QhnTuXLF22kIygDj9FwxWCKx8uECeff7odVS2aq0jbeNt+ZHaRQPIAsdny5IXZzxqMS8j7XrbMJe06O88cUJIR8PkSschemiwyLLA6Hcz2KfGEjWdVjb3BjZaGNO1ECKKgLTPpKczjGxhUimJz6J8eu22O/CN1Lxz'

# SSH passwordless
cat <<EOF >/home/jedi/.ssh/id_rsa.pub
${jedi_user_public_key}
EOF
cp /home/jedi/.ssh/id_rsa.pub /home/jedi/.ssh/authorized_keys

# set permissions
chown -R jedi:jedi /home/jedi/.ssh
chmod 0600 /home/jedi/.ssh/authorized_keys
chmod 400 /home/jedi/.ssh/id_rsa

# apply to root
mkdir -m0700 -p /root/.ssh/
cp /home/jedi/.ssh/id_rsa* /root/.ssh/.
cp /home/jedi/.ssh/authorized_keys /root/.ssh/authorized_keys
chown -R root:root /root/.ssh
chmod 0600 /root/.ssh/authorized_keys
chmod 400 /root/.ssh/id_rsa

JEDI_SUDOER="jedi ALL=(ALL) NOPASSWD:ALL"
if ! grep -q '$JEDI_SUDOER' /etc/sudoers; then
  echo "jedi ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
fi
# change to add wheel NoPASSWD: ALL

