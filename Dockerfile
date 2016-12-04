FROM php:5-apache

WORKDIR /app/

ENV CRAFTURL 'https://download.craftcdn.com/craft/2.6/2.6.2952/Craft-2.6.2952.zip'

# create craft version
COPY scripts/ /app/scripts/

# Download the latest Craft, save as craft.zip in current folder
# Extract just the craft directory and index out of the archive, quietly
# cleanup
# Installing dependencies
RUN curl $CRAFTURL -o "/app/craft.zip" \
		&& apt-get update \
		&& apt-get install -y unzip \
		&& unzip -qqo /app/craft.zip 'craft/*' 'public/*' \
		&& rm /app/craft.zip \
		&& echo $(egrep '(CRAFT_VERSION|CRAFT_BUILD)' /app/craft/app/Info.php | awk '{print $2}' | sed s@[^0-9\.]@@g) | tee public/craftversion.txt \
		&& sh scripts/install/010_dependencies.sh

# add default config
ADD ./config /app/craft/config
ADD ./html /var/www/html

RUN cp -Rf /app/craft /var/www/ \
		&& mv /app/public/index.php /var/www/html/ \
		&& chmod -R 775 /var/www

