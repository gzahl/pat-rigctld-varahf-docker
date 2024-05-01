#!/usr/bin/env bash
# supervisor does not allow for dependent startup, but e.g. pat needs to be started after rigctld. Therefore the first startup uses this bootstrap script. supervisorctl start blocks, until each program has successfully started.
supervisorctl start xvfb
supervisorctl start fluxbox
supervisorctl start x11vnc
#supervisorctl start novnc
supervisorctl start rigctld
supervisorctl start pat
supervisorctl start vara
#supervisorctl start caddy
