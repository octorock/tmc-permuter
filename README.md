# Using Decomp permuter with tmc repo

## Run locally

Clone permuter repository.
```
git clone https://github.com/simonlindholm/decomp-permuter.git
```

Install permuter dependencies.
```
pip install pycparser pynacl toml
```

Copy the example folder from this repository into the permuter folder.

Edit the paths to devkitPro and the tmc repo in `compile.sh` and `prepare.sh`.

Copy the C code from NONMATCH into `input.c` and the target asm code from NONMATCH into `input.s`.

In the example folder run `./prepare.sh`.

Now start the permuter in the permuter folder:
```
./permuter.py --stop-on-zero -j 4 example
```
(Replace 4 with the number of parallel threads.)

For more info read the permuter docs: https://github.com/simonlindholm/decomp-permuter#decomp-permuter

## Import from NONMATCH
Run the following to directly import code and asm from a NONMATCH submission.
```
./import.py NONMATCH_URL
```

## permuter@home
The permuter supports a distributed mode, where people can donate processor power to your permuter runs to speed them up.

### Connect to the network
```
./pah.py setup
```
Enter name and send the resulting command to someone who already is in the tmc permuter@home network.
Enter the token that they send you.
Check that the connection was successfully set up.

### Run client
To use the permuter@home network for compilation add `-J` to the permuter:
```
./permuter.py --stop-on-zero -J -j 4 FOLDER
```

### Run worker
To allow others to use your computer for permuter runs, you need to have Docker installed for sandboxing and the current user needs to be in the docker group.  
Install the required python package:
```
pip install docker
```

Now run the worker.
```
./pah.py run-server --cores CORES --memory MEMORY_GB
```

It should automatically fetch the docker image from the GitHub container repository. If it does not or you architecture is not available, you can manually build the permuter-agbcc docker image.
```
cd docker/pah_worker
docker build . -t ghcr.io/octorock/permuter-agbcc:latest
```

## Run using Docker
If you do not have the tmc repository with devkitPro and agbcc already setup, you can run the permuter locally with Docker.

```
cd docker/standalone
docker compose up
```