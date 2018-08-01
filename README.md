# AS_to_netowork_ranges_and_f5
A very simple and small image where you provide a list of AS and it will generate IPv4 list of network ranges, main use is to allow/block through datagroup on the F5 

It's a very simple script to list all IPv4 networks assigned to an AS. You don't need docker/rkt for it, but it is there just to make things simpler. E.g. if you are running systemd socket activation and you want it to work only on demand instead of cron etc. and you want to keep it in a jailed evn.

simply run:

`SOURCE=`pwd`/source.txt DESTINATION=/tmp ./run.sh`

or through docker

`docker run -ti --rm -v /tmp/source.txt:/source/source.txt:ro -v /tmp:/destination shellmaster/as_to_network_ranges_and_f5`

you can pass extra variables:

- SRC - default -> /source/source.txt
to point to the source file of AS, comment are allowed with #
- DST - default -> /destination
destination folder for all files
- F5 (true/false) - default true - it will generate a file that you can import as a datagroup in the F5 (we use it for allowing/blocking some netoworks + logging)
- RAW (true/false) - default true - it will just generate the file withouth any parsing

You can use any source image as long as you adapt it to have required packages
