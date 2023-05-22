function jq-patch {
  local node="${1}"
  local expr="${2}"
  local filename="${3}"
  docker exec "${node}" \
         bash -c "jq '${expr}' '${filename}' >/tmp/jqpatch.tmp && mv /tmp/jqpatch.tmp '${filename}'"
}

function install-cni-genie {
  kubectl apply -f https://docs.projectcalico.org/v2.6/getting-started/kubernetes/installation/hosted/kubeadm/1.6/calico.yaml
  wait-for "Calico etcd" pods-ready k8s-app=calico-etcd
  wait-for "Calico node" pods-ready k8s-app=calico-node
  kubectl apply -f https://raw.githubusercontent.com/Huawei-PaaS/CNI-Genie/master/conf/1.8/genie-plugin.yaml

  jq-patch kube-node-1 '.cniVersion="0.3.0"|.default_plugin="calico,flannel"' /etc/cni/net.d/00-genie.conf
  jq-patch kube-node-1 '.cniVersion="0.3.0"' /etc/cni/net.d/10-calico.conf
  jq-patch kube-node-1 '.cniVersion="0.3.0"' /etc/cni/net.d/10-flannel.conflist
}

function wait-for {
  local title="$1"
  local action="$2"
  local what="$3"
  shift 3
  step "Waiting for:" "${title}"
  while ! "${action}" "${what}" "$@"; do
    echo -n "." >&2
    sleep 1
  done
  echo "[done]" >&2
}

function step {
  local OPTS=""
  if [ "$1" = "-n" ]; then
    shift
    OPTS+="-n"
  fi
  GREEN="$1"
  shift
  if [ -t 2 ] ; then
    echo -e ${OPTS} "\x1B[97m* \x1B[92m${GREEN}\x1B[39m $*" >&2
  else
    echo ${OPTS} "* ${GREEN} $*" >&2
  fi
}

function pods-ready {
  local label="$1"
  local out
  if ! out="$("${kubectl}" get pod -l "${label}" -n kube-system \
                           -o jsonpath='{ .items[*].status.conditions[?(@.type == "Ready")].status }' 2>/dev/null)"; then
    return 1
  fi
  if ! grep -v False <<<"${out}" | grep -q True; then
    return 1
  fi
  return 0
}


install-cni-genie
