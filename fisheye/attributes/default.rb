default[:fisheye][:name] = "fecru-2.5.1"
default[:fisheye][:download_url] = "http://www.atlassian.com/software/fisheye/downloads/binary/fisheye-2.5.1.zip"
default[:fisheye][:install] = "/usr/share/#{default[:fisheye][:name]}"
default[:fisheye][:fisheyectl] = "#{default[:fisheye][:install]}/bin/fisheyectl.sh"
