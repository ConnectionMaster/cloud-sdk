# cloud-sdk

Google Cloud SDK

##### Run a shell script:
```
cat foo.sh | docker run -i --rm softonic/cloud-sdk
```

##### Bind mount your code:
```
docker run -it --rm -v ${PWD}:/code softonic/cloud-sdk
```

##### Enable DooD (Docker out of Docker):
```
docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock softonic/cloud-sdk
```

##### All combined:
```
echo "docker version" | docker run -i --rm \
-v /var/run/docker.sock:/var/run/docker.sock \
-v ${PWD}:/code softonic/cloud-sdk
```
