# docker build -t mychatappimg . --build-arg ENVIRONMENT=development
# docker run -p 5000:5000 mychatappimg

docker build -t mychatappimg .
docker run -p 5000:5000 --name mem-and-cpu-limit-demo --memory=1g --memory-reservation=512m --cpus=1 --cpuset-cpus=2 mychatappimg

#docker stats mem-and-cpu-limit-demo