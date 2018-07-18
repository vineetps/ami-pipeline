def kernel = params.kernel_update
pipeline {
    agent { node { label 'master' } }
    parameters {
        string(name: 'creator', defaultValue: 'abc@xyz.com', description: 'Enter Creator Name')
        string(name: 'region', defaultValue: 'eu-west-1', description: 'Enter only one region')
        booleanParam(name: 'kernel_update', defaultValue: true, description: 'Check box to update to latest kernel version.')
    }
    stages {
      stage('Preparation') {
             steps {
                 echo 'Fetching files from git..'
                 git credentialsId: '503fcf64-4e6c-4a2e-b94e-f67b27852fad', url: 'https://github.com/hisrarul/ami-pipeline.git'
             }
         }
    stage('Baking AMI') {
      steps {
        echo 'Baking AMI..'
        script{
        if(kernel) {
          sh """ if ./packer --version; then
                 echo "packer already installed"
                 else
                     wget https://releases.hashicorp.com/packer/1.1.3/packer_1.1.3_linux_386.zip
                     unzip packer_1.1.3_linux_386.zip
                     rm -rf packer_1.1.3_linux_386.zip
                 fi
                ./packer validate Packer/Template.json
                ./packer build Packer/Template.json """ }
        else {
          sh """ if ./packer --version; then
                 echo "packer already installed"
                 else
                     wget https://releases.hashicorp.com/packer/1.1.3/packer_1.1.3_linux_386.zip
                     unzip packer_1.1.3_linux_386.zip
                     rm -rf packer_1.1.3_linux_386.zip
                 fi
                ./packer validate Packer/Template_exclude_kernel.json
                ./packer build Packer/Template_exclude_kernel.json """ }
            }
        }
    }
    stage('Launch Instance with ami') {
        steps {
            echo 'Launch Instance with Golden-AMI....'
            sh "bash launch.sh ${params.creator}"
        }
    }
     stage('Scanning AMI') {
        steps{
          script{
            echo 'Run inspector by triggering lambda....'
            def stack_name ="abc-xyz-spector"
            sh (""" 
            aws cloudformation describe-stacks --region ${params.region} --stack-name $stack_name | grep \"OutputValue\" | cut -d'"' -f4 > sns_arn
            cat sns_arn
            """)
            def sns_arn = readFile('sns_arn').trim()//get sns arn
            sh (""" aws sns publish --region ${params.region} --topic-arn $sns_arn --message 'run inspector' """)
          }
        }  
    }
  }
}
