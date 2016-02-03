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
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T03:12:02.161.AT/MUSE.2014-08-02T03:12:02.161.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T02:50:54.362.AT/MUSE.2014-08-02T02:50:54.362.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T03:34:32.010.AT/MUSE.2014-08-02T03:34:32.010.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T02:48:11.269.NL/MUSE.2014-08-02T02:48:11.269.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T01:47:20.921/MUSE.2014-08-02T01:47:20.921.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:32:00.291/MUSE.2014-08-02T03:32:00.291.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T02:45:30.632/MUSE.2014-08-02T02:45:30.632.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:00:01.108.NL/MUSE.2014-08-02T03:00:01.108.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T03:00:01.108.AT/MUSE.2014-08-02T03:00:01.108.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:37:04.200.NL/MUSE.2014-08-02T03:37:04.200.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T03:14:33.067.AT/MUSE.2014-08-02T03:14:33.067.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:07:41.100.NL/MUSE.2014-08-02T03:07:41.100.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T02:50:54.362.NL/MUSE.2014-08-02T02:50:54.362.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T01:55:11.343/MUSE.2014-08-02T01:55:11.343.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T01:40:08.386.AT/MUSE.2014-08-02T01:40:08.386.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:29:27.242.NL/MUSE.2014-08-02T03:29:27.242.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T02:17:48.130.AT/MUSE.2014-08-02T02:17:48.130.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:05:07.470.NL/MUSE.2014-08-02T03:05:07.470.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:34:32.010.NL/MUSE.2014-08-02T03:34:32.010.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T01:47:20.921.AT/MUSE.2014-08-02T01:47:20.921.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T01:40:08.386.NL/MUSE.2014-08-02T01:40:08.386.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T02:45:30.632.NL/MUSE.2014-08-02T02:45:30.632.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:27:09.633/MUSE.2014-08-02T03:27:09.633.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:00:01.108/MUSE.2014-08-02T03:00:01.108.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T02:50:54.362/MUSE.2014-08-02T02:50:54.362.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T02:17:48.130/MUSE.2014-08-02T02:17:48.130.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T02:48:11.269.AT/MUSE.2014-08-02T02:48:11.269.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T01:40:08.386/MUSE.2014-08-02T01:40:08.386.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:12:02.161/MUSE.2014-08-02T03:12:02.161.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:32:00.291.NL/MUSE.2014-08-02T03:32:00.291.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T02:08:16.815/MUSE.2014-08-02T02:08:16.815.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T01:49:48.332/MUSE.2014-08-02T01:49:48.332.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T01:52:30.416.NL/MUSE.2014-08-02T01:52:30.416.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T02:53:37.380.NL/MUSE.2014-08-02T02:53:37.380.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T02:45:30.632.AT/MUSE.2014-08-02T02:45:30.632.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T01:49:48.332.AT/MUSE.2014-08-02T01:49:48.332.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T01:52:30.416.AT/MUSE.2014-08-02T01:52:30.416.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T03:02:33.060.AT/MUSE.2014-08-02T03:02:33.060.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T03:32:00.291.AT/MUSE.2014-08-02T03:32:00.291.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T03:27:09.633.AT/MUSE.2014-08-02T03:27:09.633.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T03:49:26.075.AT/MUSE.2014-08-02T03:49:26.075.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T02:08:16.815.AT/MUSE.2014-08-02T02:08:16.815.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T01:55:11.343.NL/MUSE.2014-08-02T01:55:11.343.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:14:33.067.NL/MUSE.2014-08-02T03:14:33.067.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:02:33.060/MUSE.2014-08-02T03:02:33.060.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T02:53:37.380.AT/MUSE.2014-08-02T02:53:37.380.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T01:57:54.294.NL/MUSE.2014-08-02T01:57:54.294.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T01:57:54.294.AT/MUSE.2014-08-02T01:57:54.294.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T03:05:07.470.AT/MUSE.2014-08-02T03:05:07.470.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:37:04.200/MUSE.2014-08-02T03:37:04.200.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T02:48:11.269/MUSE.2014-08-02T02:48:11.269.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:12:02.161.NL/MUSE.2014-08-02T03:12:02.161.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:02:33.060.NL/MUSE.2014-08-02T03:02:33.060.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T02:17:48.130.NL/MUSE.2014-08-02T02:17:48.130.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:07:41.100/MUSE.2014-08-02T03:07:41.100.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T02:53:37.380/MUSE.2014-08-02T02:53:37.380.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T03:07:41.100.AT/MUSE.2014-08-02T03:07:41.100.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:29:27.242/MUSE.2014-08-02T03:29:27.242.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:34:32.010/MUSE.2014-08-02T03:34:32.010.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:05:07.470/MUSE.2014-08-02T03:05:07.470.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T03:29:27.242.AT/MUSE.2014-08-02T03:29:27.242.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T03:37:04.200.AT/MUSE.2014-08-02T03:37:04.200.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T01:49:48.332.NL/MUSE.2014-08-02T01:49:48.332.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:49:26.075/MUSE.2014-08-02T03:49:26.075.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:17:05.327.NL/MUSE.2014-08-02T03:17:05.327.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T03:17:05.327.AT/MUSE.2014-08-02T03:17:05.327.xml"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:17:05.327/MUSE.2014-08-02T03:17:05.327.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T02:08:16.815.NL/MUSE.2014-08-02T02:08:16.815.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T01:52:30.416/MUSE.2014-08-02T01:52:30.416.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T03:14:33.067/MUSE.2014-08-02T03:14:33.067.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/SAF/MUSE.2014-08-02T01:57:54.294/MUSE.2014-08-02T01:57:54.294.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204309/STAGING/MUSE.2014-08-02T01:55:11.343.AT/MUSE.2014-08-02T01:55:11.343.xml"

__EOF__
