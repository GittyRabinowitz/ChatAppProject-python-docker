#Stage 1: build Application

# set base image (host OS)
FROM python:3.8-slim AS reduce_docker_image

# update certificates
RUN update-ca-certificates
#set envaierment to development
ENV FLASK_ENV development

# Set the environment variable for room path
ENV ROOMS_PATH /app/rooms

# Set the environment variable for user path
ENV USERS_PATH /app/users

# Create directories for rooms and users
RUN mkdir -p $ROOMS_PATH $USERS_PATH

# Make sure the user running the application has access to these directories
RUN chown -R 1000:1000 $ROOMS_PATH $USERS_PATH

# Create the rooms.txt file in /app/rooms
RUN touch $ROOMS_PATH/rooms.txt

# Define the volumes
VOLUME $ROOMS_PATH
VOLUME $USERS_PATH


# set the working directory in the container
WORKDIR /code
# copy the dependencies file to the working directory
COPY requirements.txt .
# install dependencies
RUN pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt
#RUN pip install -r requirements.txt

RUN apt-get update && apt-get install -y curl

# copy the content of the local src directory to the working directory
COPY . .


#stage 2: reduce docker image size runtime
FROM reduce_docker_image

# set the working directory in the container
WORKDIR /code

# copy from the image we built before
COPY --from=reduce_docker_image /code /code

# add health checks
HEALTHCHECK --interval=10s --timeout=3s CMD curl --fail http://localhost:5000/health || exit 1

# command to run on container start
CMD [ "python", "./chatApp.py" ]

