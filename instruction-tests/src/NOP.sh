#!/bin/bash
# No-OP.
# 1 break.

I=$1

cat <<- EOM
	; --- Test $I ---
	$I
	break
EOM
