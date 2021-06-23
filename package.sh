#=import os

bump-major() {
  local sv="${1}"
  [ -z "${sv}" ] && return 1
  local jv="${sv%%.*}"
  local npv="${sv#*.}"
  [ "${jv}" = "${sv}" ] && return 1
  [ "${npv}" = "${sv}" ] && return 1
  declare -i ijv=${jv}
  ijv=$(( $ijv + 1 ))
  echo "${ijv}.${npv}"
}

bump-patch() {
  local sv="${1}"
  [ -z "${sv}" ] && return 1
  local pv="${sv##*.}"
  local jnv="${sv%.*}"
  [ "${pv}" = "${sv}" ] && return 1
  [ "${jnv}" = "${sv}" ] && return 1
  declare -i ipv=${pv}
  ipv=$(( $ipv + 1 ))
  echo "${jnv}.${ipv}"
}

bump-minor() {
  local sv="${1}"
  [ -z "${sv}" ] && return 1
  local jv="${sv%%.*}"
  local npv="${sv#*.}"
  local nv="${npv%.*}"
  [ "${jv}" = "${sv}" ] && return 1
  [ "${npv}" = "${sv}" ] && return 1
  [ "${nv}" = "${npv}" ] && return 1
  declare -i inv=${nv}
  inv=$(( $inv + 1 ))
  echo "${jv}.${inv}.${pv}"
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

  jnv="${gv%.*}"
  jv="${jnv%.*}"
  nv="${jnv#*.}"
  pv="${gv##*.}"

  for expr in "major=${jv}" "minor=${nv}" "patch=${pv}"; do
    part="${expr%=*}"
    xv="${expr#*=}"
    if [ ${#xv} -gt 1 ] && [ '0' = "${xv:0:1}" ]; then
      echo "The ${part} version [${xv}] cannot have leading zeroes, unless it is exactly '0' !" >&2
      return 255
    fi
  done

  return 0
}
