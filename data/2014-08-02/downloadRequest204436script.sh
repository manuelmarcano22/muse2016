#!/bin/sh

usage () {
    cat <<__EOF__
usage: $(basename $0) [-hlp] [-u user] [-X args] [-d args]
  -h        print this help text
  -l        print list of files to download
  -p        prompt for password
  -u user   download as a different user
  -X args   extra arguments to pass to xargs
  -d args   extra arguments to pass to the download program

__EOF__
}

username=mmarcano22
xargsopts=
prompt=
list=
while getopts hlpu:xX:d: option
do
    case $option in
    h)  usage; exit ;;
    l)  list=yes ;;
    p)  prompt=yes ;;
    u)  prompt=yes; username="$OPTARG" ;;
    X)  xargsopts="$OPTARG" ;;
    d)  download_opts="$OPTARG";;
    ?)  usage; exit 2 ;;
    esac
done

if test -z "$xargsopts"
then
   #no xargs option speficied, we ensure that only one url
   #after the other will be used
   xargsopts='-L 1'
fi

if [ "$prompt" != "yes" ]; then
   # take password (and user) from netrc if no -p option
   if test -f "$HOME/.netrc" -a -r "$HOME/.netrc"
   then
      grep -ir "dataportal.eso.org" "$HOME/.netrc" > /dev/null
      if [ $? -ne 0 ]; then
         #no entry for dataportal.eso.org, user is prompted for password
         echo "A .netrc is available but there is no entry for dataportal.eso.org, add an entry as follows if you want to use it:"
         echo "machine dataportal.eso.org login mmarcano22 password _yourpassword_"
         prompt="yes"
      fi
   else
      prompt="yes"
   fi
fi

if test -n "$prompt" -a -z "$list"
then
    trap 'stty echo 2>/dev/null; echo "Cancelled."; exit 1' INT HUP TERM
    stty -echo 2>/dev/null
    printf 'Password: '
    read password
    echo ''
    stty echo 2>/dev/null
fi

# use a tempfile to which only user has access 
tempfile=`mktemp /tmp/dl.XXXXXXXX 2>/dev/null`
test "$tempfile" -a -f $tempfile || {
    tempfile=/tmp/dl.$$
    ( umask 077 && : >$tempfile )
}
trap 'rm -f $tempfile' EXIT INT HUP TERM

echo "auth_no_challenge=on" > $tempfile
if [ -n "$prompt" ]; then
   echo "--http-user=$username" >> $tempfile
   echo "--http-password=$password" >> $tempfile

fi
WGETRC=$tempfile; export WGETRC

unset password

if test -n "$list"
then cat
else xargs $xargsopts wget $download_opts 
fi <<'__EOF__'
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:38:06.631/MUSE.2014-08-02T10:38:06.631.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:37:03.741/MUSE.2014-08-02T10:37:03.741.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:35:38.030/MUSE.2014-08-02T10:35:38.030.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:31:34.973/MUSE.2014-08-02T10:31:34.973.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:25:38.041/MUSE.2014-08-02T10:25:38.041.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:24:38.601/MUSE.2014-08-02T10:24:38.601.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:37:45.706/MUSE.2014-08-02T10:37:45.706.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:34:55.464/MUSE.2014-08-02T10:34:55.464.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:33:33.647/MUSE.2014-08-02T10:33:33.647.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:37:24.731/MUSE.2014-08-02T10:37:24.731.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:30:35.834/MUSE.2014-08-02T10:30:35.834.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:32:34.164/MUSE.2014-08-02T10:32:34.164.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:35:59.516/MUSE.2014-08-02T10:35:59.516.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:23:39.193/MUSE.2014-08-02T10:23:39.193.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:29:36.573/MUSE.2014-08-02T10:29:36.573.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:36:42.411/MUSE.2014-08-02T10:36:42.411.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:36:21.120/MUSE.2014-08-02T10:36:21.120.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:26:37.630/MUSE.2014-08-02T10:26:37.630.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:28:36.691/MUSE.2014-08-02T10:28:36.691.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:34:34.222/MUSE.2014-08-02T10:34:34.222.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:27:36.742/MUSE.2014-08-02T10:27:36.742.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204436/SAF/MUSE.2014-08-02T10:35:16.658/MUSE.2014-08-02T10:35:16.658.fits.fz"

__EOF__
