#!/bin/bash

function print_usage() {
  printf "Usage: %s: -a action -b backend [-c /path/to/config/file] \n\n" $(basename $0) >&2
  printf "where: \n" >&2
  printf "  -a specifies the action to perform. Supported actions are backup \n" >&2
  printf "  -b specifies which backend to use. Supported backends are aws, backblaze. \n" >&2
  printf "  -c specifies the path to the config file, e.g. /etc/dupit.conf \n" >&2
  printf "     (if -c is not specified, then the script will look for dupit.conf in the current directory) \n" >&2
  printf "  -h displays this help \n" >&2
  exit 1
}

backend_backblaze() {

  TDIR="b2://${B2_ACCT_ID}:${B2_APP_KEY}@${B2_BUCKET}/$(hostname)"
  
  export PASSPHRASE

  printf "Beginning backup to Backblaze - `date`\n=================================================\n\n" > $LOGFILE
  $DUPLICITY_BIN --verbosity ${LOGLEVEL} --full-if-older-than 1M --encrypt-key ${GPG_ENCRYPT_KEY} --include-filelist ${BACKUP_SOURCES} --exclude '**' / ${TDIR} >> $LOGFILE
}

##---------- MAIN ----------##

# set the default config file path to the CWD
CONF_FILE="$(pwd)/dupit.conf"

# parse the command line args and if no args print usage and exit
if [ $# == 0 ]; then print_usage; fi

while getopts ':a:b:c:h' OPTION
do
    case $OPTION in
      a)
        ACTION=$OPTARG
        ;;
      b)
        BACKEND=$OPTARG
        ;;
      c)
        CONF_FILE=$OPTARG
        ;;
      h)
        print_usage
        ;; 
      \?) printf "Invalid option: -%s \n" $OPTARG >&2
          print_usage
          ;;
      :)  printf "Option -%s requires an argment. \n" $OPTARG >&2
          print_usage
          ;;
    esac
done

if [ -z $ACTION ]; then
  printf "Error: You need to specify an action. \n\n" >&2
  print_usage
fi

# get the full path to the directory that we're running within
SCRIPT_BASE=$( cd "$( dirname "$0" )" && pwd )
cd ${SCRIPT_BASE}

# set the location of Duplicity
DUPLICITY_BIN=$( which duplicity )

if [ ! -z $CONF_FILE ] && [ -f $CONF_FILE ]; then
  source $CONF_FILE
else
  printf "Error: Cannot find configuration file. \n\n" >&2
  print_usage
fi

case $BACKEND in
  aws)
    backend_aws
    ;;
  backblaze)
    backend_backblaze
    ;;
  *)
    printf "Error: You need to choose a backend type. \n"
    print_usage
    ;;
esac

unset PASSPHRASE

exit 0
