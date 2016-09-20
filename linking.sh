#!/bin/bash -e
ignore=(
'^\.$'
'^\.\.$'
'^README.md'
'linking.sh'
'^.git'
)

_match() {
  local pattern
  for pattern in "${ignore[@]}" ; do
    if [[ "${1?}" =~ ${pattern?} ]] ; then
	return 0
    fi
  done
  return 1
}

_linking() {
    local cmd="ln -fs etc/${1?} ~/${1?}"
    echo "linking $cmd"
    eval "$cmd"
#echo
}

pushd ~/etc/
for i in .* * ; do 
  _match "$i" && echo "skip $i" || _linking "$i"
done
popd
