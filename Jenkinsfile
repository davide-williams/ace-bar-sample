pipeline {
  agent any
  stages {
    stage('Image Build') {
      steps {
        echo 'Building'    
        echo '  --from project https://github.com/davide-williams/ace-bar-sample.git'
        git url: 'https://github.com/davide-williams/ace-bar-sample.git', branch: 'main'
        sh 'podman build --creds cp:eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE2NDY4ODI4NzEsImp0aSI6ImE2OWNiNjE0ODhlNDQyN2E5YTI5YTA3MTM4NzdkMGI4In0.XYURbGgQkGCNBbD15QknS4zZkbpF1iv8UBGtHeDtcfU -f Dockerfile --tag image-registry.openshift-image-registry.svc:5000/ais-service-demo/aceapp:'+env.BUILD_NUMBER
      }
    }
    stage('Authentication to Internal Registry'){
        steps{
            echo 'Authenticating to Openshift Registry'
            sh 'podman login -u jenkins -p $(oc whoami -t) image-registry.openshift-image-registry.svc:5000 --tls-verify=false'
        }
    }
    stage('Pushing to Internal Registry') {
      steps {
        echo 'Pushing'
        sh 'podman push --tls-verify=false image-registry.openshift-image-registry.svc:5000/ais-service-demo/aceapp:'+env.BUILD_NUMBER
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
  stage('Application Test') {
        steps {
          echo 'Testing the application now...'
          sh 'oc rollout status -n ais-service-demo deployment/aceapp --timeout=1m'
        }
      }
  }
  post {
        // Clean after build
        always {
           echo 'Cleaning up after build...'
            cleanWs(cleanWhenNotBuilt: false,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true,
                    patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
                               [pattern: '.propsfile', type: 'EXCLUDE']])
        }
    }
}
