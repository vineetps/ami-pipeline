if ./packer --version; then
    echo "packer already installed"
else
    wget https://releases.hashicorp.com/packer/1.1.3/packer_1.1.3_linux_386.zip
	  unzip packer_1.1.3_linux_386.zip
	  rm -rf packer_1.1.3_linux_386.zip
fi
./packer validate Packer/Template.json
./packer build Packer/Template.json
