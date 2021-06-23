bump-patch() {
  local sv="${1}"
  [ -z "${sv}" ] && return 1
  local pv="${sv##*.}"
  jnv="${sv%.*}"
  [ "${pv}" = "${sv}" ] && return 1
  [ "${jnv}" = "${sv}" ] && return 1
  declare -i ipv=${pv}
  ipv=$(( $ipv + 1 ))
  echo "${jnv}.${ipv}"
}

validate-semver() {
  if [ -z "${1}" ]; then
    echo "Version cannot be empty!" >&2
    return 255
  fi

  local sv="${1}"
  gv="$(echo "${sv}" | "${_CMD_GREP}" -P '^[0-9]+\.[0-9]+\.[0-9]+$')"
  if ! [ "${gv}" = "${sv}" ]; then
    echo "Version [${sv}] is not a semantic version!" >&2
    return 255
  fi
  return 0
  # TODO: no leading zeroes in a part unless it's exactly one zero
}