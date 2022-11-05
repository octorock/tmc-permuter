#!/bin/bash -e
echo "Preparing files"
cd example
rm -r output* || true
./prepare.sh
cd ..
echo "Start permuting"
python3 permuter.py --stop-on-zero -j 6 example