pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        echo 'Building'    
        sh 'podman build -f Dockerfile --build-arg FROMIMAGE=ace:12.0.7.0-r1 --tag image-registry.openshift-image-registry.svc:5000/ace/aceapp:latest'
      }
    }
    stage('Authentication to Registry'){
        steps{
            echo 'Authenticating to Openshift Registry'
            sh 'podman login -u jenkins -p $(oc whoami -t) image-registry.openshift-image-registry.svc:5000 --tls-verify=false'
        }
    }
    stage('Pushing') {
      steps {
        echo 'Pushing'
        sh 'podman push image-registry.openshift-image-registry.svc:5000/ace/aceapp:latest --tls-verify=false'
            }
    }
  }
}