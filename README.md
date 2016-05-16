    socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
    docker run --rm -v ~/git/wx:/home -e DISPLAY=<host-ip>:0 <image>
