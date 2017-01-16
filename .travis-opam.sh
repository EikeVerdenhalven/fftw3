# If a fork of these scripts is specified, use that GitHub user instead
fork_user=${FORK_USER:-ocaml}

# If a branch of these scripts is specified, use that branch instead of 'master'
fork_branch=${FORK_BRANCH:-master}

STARTDIR=$(pwd)

### Bootstrap

set -uex

get() {
  wget https://raw.githubusercontent.com/${fork_user}/ocaml-ci-scripts/${fork_branch}/$@
}

TMP_BUILD=$(mktemp -d 2>/dev/null || mktemp -d -t 'citmpdir')
cd ${TMP_BUILD}

cp ${STARTDIR}/.travis-ocaml.sh .
sh .travis-ocaml.sh

export OPAMYES=1
eval $(opam config env)

# This could be removed with some OPAM variable plumbing into build commands
opam install ocamlfind
opam install ocamlbuild
