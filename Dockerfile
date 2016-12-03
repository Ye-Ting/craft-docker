FROM php:5-apache

WORKDIR /app/

ENV CRAFTURL 'https://download.craftcdn.com/craft/2.6/2.6.2952/Craft-2.6.2952.zip'

# Download the latest Craft, save as craft.zip in current folder
RUN curl $CRAFTURL -o "/app/craft.zip"

RUN apt-get update && apt-get install -y unzip

# OR load craft source code 
# COPY Craft-2.6.2952.zip /app/craft.zip

# Extract just the craft directory and index out of the archive, quietly
RUN unzip -qqo /app/craft.zip 'craft/*' 'public/*'

# cleanup
# RUN rm /app/craft.zip

# COPY Craft-2.6.2952/ /app/

# create craft version
RUN echo $(egrep '(CRAFT_VERSION|CRAFT_BUILD)' /app/craft/app/Info.php | awk '{print $2}' | sed s@[^0-9\.]@@g) | tee public/craftversion.txt

COPY scripts/ /app/scripts/

# Installing dependencies
RUN sh scripts/install/010_dependencies.sh

# add default config
ADD ./config /app/craft/config

