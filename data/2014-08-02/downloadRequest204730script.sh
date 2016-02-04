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
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:47:43.602/MUSE.2014-08-02T11:47:43.602.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:47:16.850/MUSE.2014-08-02T11:47:16.850.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T01:47:20.921/MUSE.2014-08-02T01:47:20.921.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T00:42:48.397/MUSE.2014-08-02T00:42:48.397.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:35:00.580/MUSE.2014-08-01T12:35:00.580.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:37:15.969.NL/MUSE.2014-08-01T12:37:15.969.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T10:52:25.267/MUSE.2014-08-02T10:52:25.267.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:07:48.569.NL/MUSE.2014-08-01T12:07:48.569.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:37:15.969/MUSE.2014-08-01T12:37:15.969.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:11:02.836/MUSE.2014-08-01T12:11:02.836.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:36:49.077.NL/MUSE.2014-08-01T12:36:49.077.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:12:07.618/MUSE.2014-08-01T12:12:07.618.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:38:09.197.NL/MUSE.2014-08-01T12:38:09.197.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T10:44:51.634/MUSE.2014-08-02T10:44:51.634.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:46:49.826/MUSE.2014-08-02T11:46:49.826.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:07:48.569/MUSE.2014-08-01T12:07:48.569.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:14:17.663.NL/MUSE.2014-08-01T12:14:17.663.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:38:09.197/MUSE.2014-08-01T12:38:09.197.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T10:43:46.542/MUSE.2014-08-02T10:43:46.542.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T10:49:11.473/MUSE.2014-08-02T10:49:11.473.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:09:58.018.NL/MUSE.2014-08-01T12:09:58.018.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:50:26.418/MUSE.2014-08-02T11:50:26.418.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:05:38.555/MUSE.2014-08-01T12:05:38.555.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:50:53.129/MUSE.2014-08-02T11:50:53.129.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T10:47:01.630/MUSE.2014-08-02T10:47:01.630.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T03:27:09.633/MUSE.2014-08-02T03:27:09.633.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:38:35.930/MUSE.2014-08-01T12:38:35.930.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:19:32.219/MUSE.2014-08-02T11:19:32.219.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T19:01:18.066/MUSE.2014-08-01T19:01:18.066.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:38:35.930.NL/MUSE.2014-08-01T12:38:35.930.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:35:54.663/MUSE.2014-08-01T12:35:54.663.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:04:33.431/MUSE.2014-08-01T12:04:33.431.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:34:33.648/MUSE.2014-08-01T12:34:33.648.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:05:38.555.NL/MUSE.2014-08-01T12:05:38.555.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:37:42.374.NL/MUSE.2014-08-01T12:37:42.374.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:37:42.374/MUSE.2014-08-01T12:37:42.374.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T10:48:06.627/MUSE.2014-08-02T10:48:06.627.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:34:06.662/MUSE.2014-08-01T12:34:06.662.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:26:00.927/MUSE.2014-08-02T11:26:00.927.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:03:28.190.NL/MUSE.2014-08-01T12:03:28.190.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:27:05.636/MUSE.2014-08-02T11:27:05.636.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:06:43.596/MUSE.2014-08-01T12:06:43.596.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:06:43.596.NL/MUSE.2014-08-01T12:06:43.596.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:48:37.630/MUSE.2014-08-02T11:48:37.630.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:24:55.778/MUSE.2014-08-02T11:24:55.778.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:35:27.661.NL/MUSE.2014-08-01T12:35:27.661.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T10:42:41.233/MUSE.2014-08-02T10:42:41.233.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:36:49.077/MUSE.2014-08-01T12:36:49.077.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:11:02.836.NL/MUSE.2014-08-01T12:11:02.836.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:14:17.663/MUSE.2014-08-01T12:14:17.663.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:18:27.173/MUSE.2014-08-02T11:18:27.173.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:49:04.633/MUSE.2014-08-02T11:49:04.633.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:35:54.663.NL/MUSE.2014-08-01T12:35:54.663.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:34:33.648.NL/MUSE.2014-08-01T12:34:33.648.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:08:53.355/MUSE.2014-08-01T12:08:53.355.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:49:59.225/MUSE.2014-08-02T11:49:59.225.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:35:00.580.NL/MUSE.2014-08-01T12:35:00.580.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:23:51.366/MUSE.2014-08-02T11:23:51.366.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:13:12.574/MUSE.2014-08-01T12:13:12.574.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:49:31.634/MUSE.2014-08-02T11:49:31.634.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:35:27.661/MUSE.2014-08-01T12:35:27.661.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T10:53:29.789/MUSE.2014-08-02T10:53:29.789.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:36:21.947.NL/MUSE.2014-08-01T12:36:21.947.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:34:06.662.NL/MUSE.2014-08-01T12:34:06.662.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T00:42:48.397.NL/MUSE.2014-08-02T00:42:48.397.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:08:53.355.NL/MUSE.2014-08-01T12:08:53.355.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:13:12.574.NL/MUSE.2014-08-01T12:13:12.574.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T10:45:56.442/MUSE.2014-08-02T10:45:56.442.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:21:41.941/MUSE.2014-08-02T11:21:41.941.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:20:37.117/MUSE.2014-08-02T11:20:37.117.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:09:58.018/MUSE.2014-08-01T12:09:58.018.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:22:46.881/MUSE.2014-08-02T11:22:46.881.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T22:29:44.220/MUSE.2014-08-01T22:29:44.220.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:03:28.190/MUSE.2014-08-01T12:03:28.190.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:48:10.942/MUSE.2014-08-02T11:48:10.942.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:51:19.634/MUSE.2014-08-02T11:51:19.634.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T10:50:15.898/MUSE.2014-08-02T10:50:15.898.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:36:21.947/MUSE.2014-08-01T12:36:21.947.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:16:17.166/MUSE.2014-08-02T11:16:17.166.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T03:49:26.075/MUSE.2014-08-02T03:49:26.075.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T10:51:20.831/MUSE.2014-08-02T10:51:20.831.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:04:33.431.NL/MUSE.2014-08-01T12:04:33.431.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-02T11:17:22.056/MUSE.2014-08-02T11:17:22.056.fits.fz"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/204730/SAF/MUSE.2014-08-01T12:12:07.618.NL/MUSE.2014-08-01T12:12:07.618.NL.txt"

__EOF__
