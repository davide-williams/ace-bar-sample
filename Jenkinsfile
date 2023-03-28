pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        echo 'Building'    
        sh 'podman build -f Dockerfile --tag image-registry.openshift-image-registry.svc:5000/ace/aceapp:$GIT_COMMIT'
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
        sh 'podman push image-registry.openshift-image-registry.svc:5000/ace/aceapp:$GIT_COMMI --tls-verify=false'
            }
    }
  }
}
