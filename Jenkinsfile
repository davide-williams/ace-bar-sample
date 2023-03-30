pipeline {
  agent any
  stages {
    stage('Image Build') {
      steps {
        echo 'Building'    
        git url: 'https://github.com/davide-williams/ace-bar-sample.git', branch: 'master'
        sh 'podman build -f Dockerfile --tag image-registry.openshift-image-registry.svc:5000/ais-service-demo/aceapp:$GIT_COMMIT'
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
        sh 'podman push image-registry.openshift-image-registry.svc:5000/ais-service-demo/aceapp:$GIT_COMMIT --tls-verify=false'
      }
    }
    stage('Application Build') {
      steps {
        echo 'Building the application now...'
        sh 'oc apply -f service.yaml'
        sh 'oc apply -f route.yaml'
        sh 'chmod 755 deployment.sh'
        sh './deployment.sh'
      }
    }
  }
}
