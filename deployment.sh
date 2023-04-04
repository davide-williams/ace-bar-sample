cat <<EOF |oc apply -f -
kind: Deployment
apiVersion: apps/v1
metadata:
  name: aceapp
  namespace: ace
  labels:
    app: aceapp
    app.kubernetes.io/component: aceapp
    app.kubernetes.io/instance: aceapp
spec:
  replicas: 1
  selector:
    matchLabels:
      deployment: aceapp
  template:
    metadata:
      labels:
        deployment: aceapp
    spec:
      containers:
        - name: aceapp
          image: >-
            image-registry.openshift-image-registry.svc:5000/ace/aceapp:env.BUILD_NUMBER
          ports:
            - containerPort: 7600
              protocol: TCP
            - containerPort: 7800
              protocol: TCP
          resources: {}
          imagePullPolicy: IfNotPresent
      restartPolicy: Always
      dnsPolicy: ClusterFirst
      securityContext: {}
      schedulerName: default-scheduler
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 25%
      maxSurge: 25%
  revisionHistoryLimit: 10
  progressDeadlineSeconds: 600
