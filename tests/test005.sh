#!/bin/bash
#
# user mpm interoperates with kernel mpm
#

. `dirname $0`/include.sh

[ $(uname) = "Linux" ] || err_exit "This test only runs on Linux"

wait_for_clean_start

nradios=2
load_hwsim $nradios || err_exit "Failed to load mac80211-hwsim module."

set_default_configs $nradios
# disable security
for conf in ${CONFIGS[@]}; do
    sed -i 's/meshid/is-secure=0;&/' $conf
done

read -a hwsim_radios <<<"$(get_hwsim_radios)"
start_meshd ${hwsim_radios[0]} || err_exit "Failed to start meshd-nl80211"
start_mesh_iw ${hwsim_radios[1]} || err_exit "Failed to start mesh using iw"
IFACES+=(${IW_IFACES[@]})

wait_for_plinks $nradios

echo PASS
