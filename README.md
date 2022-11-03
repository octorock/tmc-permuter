# Using Decomp permuter with tmc repo

Clone permuter repository.

`git clone https://github.com/simonlindholm/decomp-permuter.git`

Install permuter dependencies.

`pip install pycparser pynacl toml`

Clone this repository into the example folder in the permuter folder.

`git clone https://github.com/octorock/tmc-permuter.git example`

Edit the paths to devkitPro and the tmc repo in `common.sh`.

Copy the C code from NONMATCH into `input.c` and the target asm code from NONMATCH into `input.s`.

In the example folder run `./prepare.sh`.

Now start the permuter in the permuter folder:

`python permuter.py --stop-on-zero -j 4 example`

(Replace 4 with the number of parallel threads.)

For more info read the permuter docs: https://github.com/simonlindholm/decomp-permuter#decomp-permuter