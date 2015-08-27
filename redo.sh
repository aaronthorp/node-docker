#/bin/bash
exec kilall.sh && \
exec build.sh && \
exec run.sh
