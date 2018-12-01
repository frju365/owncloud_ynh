#
# Common variables
#

APPNAME="owncloud"

dependencies="acl php5-cli php5-apcu tar smbclient memcached redis"

# App package root directory should be the parent folder
PKGDIR=$(cd ../; pwd)

# Execute a command with occ as a given user from a given directory
# usage: exec_occ WORKDIR AS_USER COMMAND [ARG ...]
exec_occ() {
  local WORKDIR=$1
  local AS_USER=$2
  shift 2

  (cd "$WORKDIR" && exec_as "$AS_USER" \
      php occ --no-interaction --no-ansi "$@")
}

# Check if an URL is already handled
# usage: is_url_handled URL
is_url_handled() {
  local OUTPUT=($(curl -k -s -o /dev/null \
      -w 'x%{redirect_url} %{http_code}' "$1"))
  # it's handled if it does not redirect to the SSO nor return 404
  [[ ! ${OUTPUT[0]} =~ \/yunohost\/sso\/ && ${OUTPUT[1]} != 404 ]]
}
