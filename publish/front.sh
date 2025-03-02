ssh -i ./BoerisKeys.pem ubuntu@boeris.zapto.org "./FrontendPublishUtilsScripts/removeFrontendFiles.sh"
scp -i ./BoerisKeys.pem -r $BOERISFRONT/* ubuntu@boeris.zapto.org:/var/www/html/
ssh -i ./BoerisKeys.pem ubuntu@boeris.zapto.org "./FrontendPublishUtilsScripts/grantPermissionsToFrontendFiles.sh"
