# Start include from shared/sshd-privilege-separation.m4
#

RUN mkdir -p /var/empty && \
	  chown root:sys /var/empty && \
	  chmod 755 /var/empty && \
	  groupadd --force sshd && \
	  id -u sshd >/dev/null 2>&1 || useradd --gid sshd \
                                          --comment 'sshd privilege separation.' \
                                          --create-home \
                                          --home-dir /var/empty \
                                          --shell /bin/false sshd

#
# End include from shared/sshd-privilege-separation.m4
