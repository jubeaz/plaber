	 mkdir -p ./ovmf/tmp
	 # https://packages.debian.org/sid/all/ovmf/download
	 curl -L -o ./ovmf/tmp/ovmf_2025.02-9_all.deb http://ftp.fr.debian.org/debian/pool/main/e/edk2/ovmf_2025.02-9_all.deb
	 ar xv ./ovmf/tmp/ovmf_2025.02-9_all.deb --output=./ovmf/tmp
	 tar --use-compress-program=unzstd -xvf ovmf/tmp/data.tar.xz  -C ./ovmf
	 rm -rf ./ovmf/tmp