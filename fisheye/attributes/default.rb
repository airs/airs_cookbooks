default[:fisheye][:name] = "fecru-2.5.1"
default[:fisheye][:download_url] = "http://www.atlassian.com/software/fisheye/downloads/binary/fisheye-2.5.1.zip"
default[:fisheye][:install] = "/usr/share/#{default[:fisheye][:name]}"
default[:fisheye][:config] = "#{default[:fisheye][:install]}/config.xml"
default[:fisheye][:fisheyectl] = "#{default[:fisheye][:install]}/bin/fisheyectl.sh"
default[:fisheye][:mysql_db] = "fisheye"
default[:fisheye][:mysql_user] = "fisheye"
default[:fisheye][:mysql_password] = "FISHEYE_MYSQL_USER_PASSWORD"

