#!/usr/bin/with-contenv sh
s6-setuidgid $SERVICE_USER "$SERVICE_INIT" run
